# frozen_string_literal: true
#
# steganos_pure.rb — reimplementação do algoritmo de ../steganos/steganos.rb
# usando SOMENTE a stdlib do Ruby (base64, zlib), sem a gem `oily_png`.
#
# Motivo: o ambiente onde este script roda não tem acesso a rubygems.org
# (bloqueado pela política de rede) para instalar `oily_png`, e o binário
# Rust pré-compilado em ../steganos/target/release/steganos é para outra
# arquitetura (Exec format error aqui). O algoritmo de codificação é
# idêntico ao de steganos.rb: base64 -> zlib -> hex -> pixels RGB. Só o
# escritor/leitor de PNG é reimplementado manualmente (chunks PNG crus)
# para não depender de nenhuma gem externa.
#
# Compatível para leitura com qualquer decodificador PNG padrão (incluindo
# o ChunkyPNG usado pelo steganos.rb original), já que o formato de saída
# é um PNG RGB de 8 bits comum — só a forma de escrevê-lo é diferente.

require 'zlib'
require 'base64'

module SteganosPure
  module_function

  def get_dimension(size)
    Math.sqrt(size).ceil
  end

  # data (bytes) -> string hexadecimal (mesma pipeline de steganos.rb:
  # to_b64.zip.to_hex)
  def encode_hex(data)
    b64 = Base64.encode64(data)
    zipped = Zlib::Deflate.deflate(b64, Zlib::BEST_COMPRESSION)
    zipped.unpack1('H*')
  end

  # string hexadecimal -> data original (inverso: from_hex.unzip.from_b64)
  def decode_hex(hex)
    zipped = [hex].pack('H*')
    b64 = Zlib::Inflate.inflate(zipped)
    Base64.decode64(b64)
  end

  def crc32_chunk(type, data)
    Zlib.crc32(type + data)
  end

  def chunk(type, data)
    [data.bytesize].pack('N') + type + data + [crc32_chunk(type, data)].pack('N')
  end

  # Escreve um PNG RGB de 8 bits a partir de uma lista plana de bytes RGB
  # (dimension*dimension*3 bytes, preenchida em ordem row-major).
  def write_png(path, dimension, rgb_bytes, text_meta = {})
    sig = "\x89PNG\r\n\x1a\n".b
    ihdr = [dimension, dimension, 8, 2, 0, 0, 0].pack('NNCCCCC')

    # monta as scanlines com filtro 0 (None) no início de cada linha
    row_bytes = dimension * 3
    raw = String.new(capacity: dimension * (row_bytes + 1))
    dimension.times do |y|
      raw << 0.chr
      raw << rgb_bytes[y * row_bytes, row_bytes]
    end

    idat = Zlib::Deflate.deflate(raw, Zlib::BEST_COMPRESSION)

    File.open(path, 'wb') do |f|
      f.write(sig)
      f.write(chunk('IHDR', ihdr))
      text_meta.each do |k, v|
        f.write(chunk('tEXt', "#{k}\0#{v}"))
      end
      f.write(chunk('IDAT', idat))
      f.write(chunk('IEND', ''))
    end
  end

  def read_png(path)
    bytes = File.binread(path)
    raise 'not a PNG' unless bytes[0, 8] == "\x89PNG\r\n\x1a\n".b

    pos = 8
    width = height = nil
    idat = String.new
    text = {}
    while pos < bytes.bytesize
      len = bytes[pos, 4].unpack1('N')
      type = bytes[pos + 4, 4]
      data = bytes[pos + 8, len]
      case type
      when 'IHDR'
        width, height = data.unpack('NN')
      when 'IDAT'
        idat << data
      when 'tEXt'
        k, v = data.split("\0", 2)
        text[k] = v
      end
      pos += 8 + len + 4
      break if type == 'IEND'
    end

    raw = Zlib::Inflate.inflate(idat)
    row_bytes = width * 3
    rgb = String.new
    height.times do |y|
      offset = y * (row_bytes + 1)
      filter = raw.getbyte(offset)
      raise "unsupported PNG filter #{filter}" unless filter == 0
      rgb << raw[offset + 1, row_bytes]
    end
    [width, height, rgb, text]
  end

  def encode_file(input_path, output_path)
    data = File.binread(input_path)
    hex = encode_hex(data)

    size = hex.length / 6 + 1
    dim = get_dimension(size)

    rgb = String.new(capacity: dim * dim * 3)
    count = 0
    hex.scan(/.{1,6}/).each do |chunk6|
      chunk6 = chunk6 + ('0' * (6 - chunk6.size)) if chunk6.size < 6
      rgb << [chunk6].pack('H*')
      count += 1
    end
    # preenche pixels restantes (a última linha do quadrado) com preto
    (dim * dim - count).times { rgb << "\x00\x00\x00" }

    write_png(output_path, dim, rgb,
              'Author' => 'ExtraPolo!',
              'Title' => File.basename(input_path),
              'PayloadLength' => hex.length.to_s)
    [dim, count, hex.length]
  end

  def decode_file(input_path, output_path)
    _width, _height, rgb, text = read_png(input_path)
    hex = rgb.unpack('H*')[0]
    hex = hex[0, text['PayloadLength'].to_i] if text['PayloadLength']
    data = decode_hex(hex)
    File.binwrite(output_path, data)
    data
  end
end

if $PROGRAM_NAME == __FILE__
  cmd, a, b = ARGV
  case cmd
  when 'encode'
    dim, count, hexlen = SteganosPure.encode_file(a, b)
    puts "encoded #{a} -> #{b} (#{dim}x#{dim}, #{count} pixels, #{hexlen} hex chars)"
  when 'decode'
    SteganosPure.decode_file(a, b)
    puts "decoded #{a} -> #{b}"
  else
    warn 'Usage: ruby steganos_pure.rb encode INPUT OUTPUT | decode INPUT OUTPUT'
    exit 1
  end
end

# frozen_string_literal: true
#
# soneto_alfanumerico.rb
#
# Reconstrução experimental do procedimento de cifragem usado por
# Erthos Albino de Souza em "SONETO ALFANUMÉRICO" (revista Código
# n.1, Salvador, 1974), uma "tradução criptográfica" do soneto de
# Mallarmé "Le vierge, le vivace et le bel aujourd'hui" (1885).
#
# Este arquivo NÃO é uma reconstituição do programa Fortran/PL-1
# original de Erthos (que não sobreviveu / não foi publicado).
# É uma tabela de substituição monoalfabética inferida por
# alinhamento manual, caractere a caractere, entre o soneto de
# Mallarmé e a transcrição da página publicada (original.png).
#
# Rodando este arquivo (`ruby soneto_alfanumerico.rb`), a nossa
# função encode() aplicada aos 14 versos originais de Mallarmé
# reproduz 509 dos 512 caracteres da página publicada (99.4%),
# com uma ÚNICA tabela fixa letra -> símbolo (maiúsculas e
# minúsculas tratadas igual, acentos removidos antes da
# substituição).
#
# A constante `transcribed` abaixo é uma transcrição diplomática:
# reproduz o que está impresso na página de 1974, glifo a glifo,
# sem correção editorial.
#
# Os 3 caracteres que não fecham se dividem em DUAS naturezas
# diferentes, e vale não somá-los: 2 são divergências do impresso
# em relação a Mallarmé (versos 10 e 14), e 1 é limite do próprio
# alfabeto (verso 4, o "!" de "fui!"). Exceções à tabela: nenhuma.
# Ver DECIFRACAO.md, seção 3.5, para cada caso.

module SonetoAlfanumerico
  # --------------------------------------------------------------
  # Tabela de substituição (letra normalizada -> símbolo da página)
  # Reconstruída por alinhamento com os 14 versos de Mallarmé.
  # k, w, z não ocorrem no soneto de Mallarmé e por isso não têm
  # símbolo atestado (permanecem nil).
  # --------------------------------------------------------------
  LETTER_TO_SYMBOL = {
    'a' => 'A', 'b' => '!', 'c' => '"', 'd' => ':', 'e' => ')',
    'f' => ';', 'g' => '¬', 'h' => "'", 'i' => '2', 'j' => '4',
    'k' => nil, 'l' => '6', 'm' => '7', 'n' => '(', 'o' => '3',
    'p' => '&', 'q' => '+', 'r' => '¢', 's' => '>', 't' => '-',
    'u' => '1', 'v' => '=', 'w' => nil, 'x' => '?', 'y' => '|',
    'z' => nil
  }.freeze

  # Pontuação que, pela evidência das 14 linhas, atravessa a cifra
  # sem alteração. O "!" de "fui!" (linha 4) não está aqui e não tem
  # símbolo: não é falta de evidência, é que o glifo "!" já está
  # ocupado pela letra "b", e o alfabeto de 23 símbolos não tem
  # nenhum livre para ele — a página simplesmente não o imprime.
  LITERAL_PASSTHROUGH = %w[' , . -].freeze

  SYMBOL_TO_LETTER = LETTER_TO_SYMBOL.each_with_object({}) do |(letter, symbol), h|
    next unless symbol
    # "-" também é usado literalmente (hífen de "Va-t-il"), então na
    # volta ele é ambíguo com "t"; decode() prioriza o hífen literal.
    h[symbol] ||= letter
  end.freeze

  module_function

  # Remove acentos e baixa a caixa, como a cifra faz.
  def normalize(text)
    text.unicode_normalize(:nfd).gsub(/[̀-ͯ]/, '').downcase
  end

  # Codifica um verso em francês para o alfabeto do Soneto Alfanumérico.
  def encode(text)
    normalize(text).each_char.map do |ch|
      if LETTER_TO_SYMBOL.key?(ch)
        LETTER_TO_SYMBOL[ch] || "[#{ch}?]" # letra sem símbolo atestado
      elsif LITERAL_PASSTHROUGH.include?(ch) || ch == ' '
        ch
      else
        ch # pontuação não mapeada: mantém como está
      end
    end.join
  end

  # Decodifica (best-effort) um trecho cifrado de volta a letras.
  # Como a tabela não é bijetora perfeita ("-" serve a "t" e ao
  # hífen literal), o resultado é uma hipótese, não uma certeza.
  def decode(cipher)
    cipher.each_char.map { |ch| SYMBOL_TO_LETTER[ch] || ch }.join
  end

  # Alinha duas sequências de caracteres por subsequência comum
  # máxima (LCS) e devolve a lista de operações. Alinhamento, e
  # não comparação posicional: a página tem um caractere inserido
  # no verso 14, e uma comparação posicional ingênua contaria isso
  # como 22 erros em cascata em vez de 1.
  def align(ours, theirs)
    n = ours.length
    m = theirs.length
    dp = Array.new(n + 1) { Array.new(m + 1, 0) }
    (1..n).each do |i|
      (1..m).each do |j|
        dp[i][j] = if ours[i - 1] == theirs[j - 1]
                     dp[i - 1][j - 1] + 1
                   else
                     [dp[i - 1][j], dp[i][j - 1]].max
                   end
      end
    end

    ops = []
    i = n
    j = m
    while i.positive? || j.positive?
      if i.positive? && j.positive? && ours[i - 1] == theirs[j - 1]
        ops << [:match, ours[i - 1], theirs[j - 1]]
        i -= 1
        j -= 1
      elsif j.positive? && (i.zero? || dp[i][j - 1] >= dp[i - 1][j])
        # caractere presente na página e ausente na nossa cifragem
        ops << [:na_pagina, nil, theirs[j - 1]]
        j -= 1
      else
        # caractere que a cifra prevê e que a página não imprime
        ops << [:na_cifra, ours[i - 1], nil]
        i -= 1
      end
    end
    ops.reverse!

    # Um :na_cifra imediatamente seguido de um :na_pagina é uma
    # substituição (um glifo trocado por outro), não duas operações.
    collapsed = []
    until ops.empty?
      a = ops.shift
      b = ops.first
      if a[0] == :na_cifra && b && b[0] == :na_pagina
        ops.shift
        collapsed << [:trocado, a[1], b[2]]
      elsif a[0] == :na_pagina && b && b[0] == :na_cifra
        ops.shift
        collapsed << [:trocado, b[1], a[2]]
      else
        collapsed << a
      end
    end
    collapsed
  end

  # Compara o verso cifrado por nós com a transcrição diplomática
  # da página. Retorna [acertos, total, divergencias] para auditoria,
  # onde total é o comprimento da mais longa das duas sequências
  # (para que sobra e falta de caractere pesem igual).
  def score_line(original_fr, transcribed_cipher)
    ours = encode(original_fr).delete(' ')
    theirs = transcribed_cipher.delete(' ')
    ops = align(ours, theirs)
    hits = ops.count { |op| op[0] == :match }
    [hits, [ours.length, theirs.length].max, ops.reject { |op| op[0] == :match }]
  end
end

if $PROGRAM_NAME == __FILE__
  mallarme = [
    "Le vierge, le vivace et le bel aujourd'hui",
    "Va-t-il nous déchirer avec un coup d'aile ivre",
    "Ce lac dur oublié que hante sous le givre",
    "Le transparent glacier des vols qui n'ont pas fui!",
    "Un cygne d'autrefois se souvient que c'est lui",
    "Magnifique mais qui sans espoir se délivre",
    "Pour n'avoir pas chanté la région où vivre",
    "Quand du stérile hiver a resplendi l'ennui.",
    "Tout son col secouera cette blanche agonie",
    "Par l'espace infligée à l'oiseau qui le nie,",
    "Mais non l'horreur du sol où le plumage est pris.",
    "Fantôme qu'à ce lieu son pur éclat assigne,",
    "Il s'immobilise au songe froid de mépris",
    "Que vêt parmi l'exil inutile le Cygne."
  ]

  transcribed = [
    %q{6) =2)¢¬),6) =2=A") )- 6) !)6 A1431¢:''12},
    %q{=A---26 (31> :)"'2¢)¢ A=)" 1( "31& :'A26) 2=¢)},
    %q{") 6A" :1¢ 31!62) +1) 'A(-) >31> 6) ¬2=¢)},
    %q{6) -¢A(>&A¢)(- ¬6A"2)¢ :)> =36> +12 ('3(- &A> ;12},
    %q{1( "|¬() :'A1-¢);32> >) >31=2)(- +1) "')>- 612},
    %q{7A¬(2;2+1) 7A2> +12 >A(> )>&32¢ >) :)62=¢)},
    %q{&31¢ ('A=32¢ &A> "'A(-) 6A ¢)¬23( 31 =2=¢)},
    %q{+1A(: :1 >-)¢26) '2=)¢ A ¢)>&6)(:2 6')((12.},
    %q{-31- >3( "36 >)"31)¢A ")--) !6A("') A¬3(2)},
    %q{&A> 6')>&A") 2(;62¬)) A 6'32>)A1 +12 6) (2),},
    %q{7A2> (3( 6''3¢¢)1¢ :1 >36 31 6) &617A¬) )>- &¢2>.},
    %q{;A(-37) +1'A ") 62)1 >3( &1¢ )"6A- A>>2¬(),},
    %q{26 >'2773!262>) A1 >3(¬) ;¢32: :) 7)&¢2>},
    %q{+1) =)- &A¢72- 6')?26 2(1-26) 6) "|¬().}
  ]

  total_hits = 0
  total_len = 0

  mallarme.each_with_index do |verse, i|
    encoded = SonetoAlfanumerico.encode(verse)
    hits, len, diffs = SonetoAlfanumerico.score_line(verse, transcribed[i])
    total_hits += hits
    total_len += len
    pct = (100.0 * hits / len).round(1)
    puts format('%2d  %5.1f%%  %s', i + 1, pct, verse)
    puts "        nosso:    #{encoded}"
    puts "        pagina:   #{transcribed[i]}"
    unless diffs.empty?
      descritas = diffs.map do |kind, nosso, pagina|
        case kind
        when :trocado
          "divergencia do impresso: a pagina traz #{pagina.inspect} " \
            "onde a cifra pede #{nosso.inspect}"
        when :na_pagina
          "divergencia do impresso: a pagina traz #{pagina.inspect} a mais"
        when :na_cifra
          # Nao e divergencia: e o alfabeto de 23 simbolos batendo no teto.
          "limite do alfabeto: a cifra pede #{nosso.inspect}, " \
            'glifo que ja esta ocupado por uma letra'
        end
      end
      puts descritas.map { |d| "        #{d}" }.join("\n")
    end
    puts
  end

  puts format('TOTAL: %d/%d caracteres coincidem (%.1f%%)', total_hits, total_len, 100.0 * total_hits / total_len)
end

# Soneto Alfanumérico, de Erthos Albino de Souza — a obra e a nossa decifração

Arquivos deste projeto: `original.png` (scan da página), `poema.md` (transcrição
e comparação lado a lado), `soneto_alfanumerico.rb` (algoritmo em Ruby).

## 1. A obra

**Erthos Albino de Souza** (1932–2000) foi um engenheiro de minas baiano que
trabalhou na Petrobras e, paralelamente, um dos pioneiros internacionais da
poesia feita com computador. A partir de fins dos anos 1960, influenciado pelos
experimentos de Pedro Xisto com computadores no Canadá, passou a usar as
linguagens Fortran e PL/1 — ferramentas de cálculo numérico de grandes empresas
— como instrumento poético, submetendo texto verbal a processos de cálculo e
combinatória. Fundou e financiou sozinho a revista *Código*, publicada em
Salvador entre 1974 e 1990 (12 números), um dos principais veículos da poesia
experimental brasileira depois de *Noigandres* e *Invenção*, com colaborações de
Augusto de Campos e Décio Pignatari, entre outros.

O **Soneto Alfanumérico** foi publicado no número 1 de *Código* (1974). Antonio
Risério, em ensaio de 1998, descreve a peça como um texto em que letras e
dígitos se combinam "em base permutatória" dentro da forma clássica do soneto.
Augusto de Campos a situa como resultado de "estudos de tradução criptográfica"
que Erthos fez a partir do soneto de Mallarmé "Le vierge, le vivace et le bel
aujourd'hui" (1885) — o mesmo poema que inspira o "Coup de dés" da crítica
mallarmeana sobre o cisne preso no gelo. Um ano depois, Erthos voltaria ao tema
com "Tombeau de Mallarmé", em número dedicado ao poeta francês.

Ou seja: não é um poema que *contém* um código escondido, mas um poema cujo
*processo de composição* — passar cada verso de Mallarmé por um procedimento de
computação, letra por letra — é a própria obra. O experimento também é, em certo
sentido, um comentário sobre o próprio soneto de Mallarmé: nele, um cisne fica
preso no gelo ("Il s'immobilise au songe froid de mépris"); aqui, a linguagem do
poeta fica presa dentro de uma máquina.

## 2. O artefato que examinamos

`original.png` é o scan de uma página datilografada/impressa em impressora
matricial de computador dos anos 1970, com o cabeçalho da revista *Código*
(logotipo hexagonal) e o título "SONETO ALFANUMERICO", seguido de 14 linhas
organizadas em dois quartetos e dois tercetos — exatamente a estrutura de um
soneto, e a mesma estrutura do original de Mallarmé.

## 3. O processo de decifração

### 3.1. Por que não usamos OCR

Uma primeira tentativa (em outra conversa, anexada a este projeto) tentou usar
OCR e leitura automática da imagem, mas os caracteres especiais do soneto (¢, ¬,
&, |, etc., típicos do conjunto de caracteres de impressoras de computador dos
anos 1970) são sistematicamente confundidos por OCR genérico com dígitos e
letras parecidos (3/8, 1/l, 2/Z...). Por isso, transcrevemos a imagem **à mão,
por leitura visual direta**, recortando cada uma das 14 linhas e ampliando-as
individualmente (3-4x, com realce de contraste) para diferenciar com segurança
símbolos como `¢` (cifrão) de `>` (maior-que), ou `¬` (negação) de `7`.

### 3.2. A hipótese testada

As fontes históricas falam em "tradução criptográfica" e "permutação", o que
sugeriria embaralhar a ordem dos caracteres. Mas a primeira comparação visual
entre o início do soneto de Mallarmé e a primeira linha da página já sugeria
outra coisa: a ordem das palavras e das letras **não muda** — só a aparência de
cada caractere. "Le" vira "6)"; "vierge," vira "=2)¢¬),"; e assim por diante,
sempre na mesma posição relativa. Isso aponta para uma **cifra de substituição
monoalfabética**: cada letra do original é trocada por um símbolo fixo, sempre
o mesmo, ao longo de todo o poema — não uma permutação da ordem dos caracteres.

### 3.3. Como testamos a hipótese

Para cada um dos 14 versos, alinhamos manualmente palavra por palavra o texto de
Mallarmé (normalizado: sem acento, sem distinção maiúscula/minúscula) com a
transcrição da linha correspondente na página, e fomos anotando qual símbolo
aparecia no lugar de cada letra. Como muitas letras se repetem várias vezes ao
longo dos 14 versos (o "e" mudo do francês, o "u", o "l"...), cada nova
ocorrência servia de teste de consistência para a tabela que estava sendo
montada: se a hipótese estivesse errada, ela teria entrado em contradição já
nos primeiros versos. Isso não aconteceu: a tabela abaixo foi confirmada, sem
exceção alguma, por **todas** as 14 linhas. Os três caracteres que não fecham
entre a cifra e o impresso não são da tabela — dois são divergências da página
e um é limite do próprio alfabeto — ver 3.5.

### 3.4. A tabela de substituição encontrada

| letra | símbolo | | letra | símbolo | | letra | símbolo |
|---|---|---|---|---|---|---|---|
| a | `A` | | j | `4` | | s | `>` |
| b | `!` | | k | *(não ocorre)* | | t | `-` |
| c | `"` | | l | `6` | | u | `1` |
| d | `:` | | m | `7` | | v | `=` |
| e | `)` | | n | `(` | | w | *(não ocorre)* |
| f | `;` | | o | `3` | | x | `?` |
| g | `¬` | | p | `&` | | y | `\|` |
| h | `'` | | q | `+` | | z | *(não ocorre)* |
| i | `2` | | r | `¢` | | | |

Regras acessórias, também induzidas do próprio texto:

- Acentos são removidos antes da substituição (à, é, ê, ô, ù viram a, e, e, o, u).
- Maiúscula e minúscula usam o mesmo símbolo (o "L" de início de verso e o "l"
  minúsculo caem ambos em `6`).
- Vírgula, ponto, apóstrofo e hífen atravessam a cifra sem mudar de símbolo
  (o apóstrofo francês `'` continua `'`; note que isso faz `-` valer tanto para
  o hífen literal de "Va-t-il" quanto para a letra `t` — a cifra não é
  perfeitamente reversível nesse ponto).
- Espaços entre palavras em geral se mantêm como espaço, embora a página deixe
  de reproduzir com perfeição a pontuação mais rara — o ponto de exclamação de
  "fui!" (fim do verso 4) não aparece com símbolo próprio na página.
- `k`, `w` e `z` simplesmente não ocorrem em nenhuma palavra do soneto de
  Mallarmé, então não temos como saber que símbolo teriam.

Não é uma cifra de César simples: convertendo letra e símbolo para seus códigos
ASCII, a diferença entre os dois não é constante (varia de -69 a +74 conforme a
letra), então não é um deslocamento aritmético trivial do alfabeto latino sobre
a tabela ASCII. É possível que a correspondência venha de uma tabela de código
diferente (cartão perfurado, EBCDIC/BCD, ou o conjunto de caracteres específico
da impressora usada por Erthos em 1974) em vez de uma escolha "artística"
arbitrária símbolo a símbolo — mas isso é uma hipótese para investigação futura,
não algo que pudemos confirmar.

### 3.5. Os três caracteres que não fecham

A transcrição em `poema.md` e em `soneto_alfanumerico.rb` é **diplomática**:
reproduz o que está impresso na página de 1974, glifo a glifo, sem correção
editorial. Comparada com a cifragem que a tabela prevê a partir de Mallarmé,
ela coincide em 509 dos 512 caracteres. Os três que não fecham são estes — e
nenhum deles é exceção da tabela, que vale sem ressalva nas 14 linhas.

Vale não somá-los, porque são de duas naturezas diferentes. **Dois** são
divergências do impresso em relação a Mallarmé (versos 10 e 14). O **terceiro**
não é divergência de ninguém: é o alfabeto de 23 símbolos batendo no teto
(verso 4). Ou seja, a contagem honesta é de **duas** divergências, não três —
e, dessas duas, nenhuma é comprovadamente "erro", já que o verso 14 admite
leitura que não exige supor erro algum e o verso 10 não permite decidir entre
lapso e intenção.

**Verso 4 — o `!` de "fui!" não é impresso.** Não é lapso, é limite do
alfabeto: o glifo `!` já está ocupado pela letra "b" (`bel`, `blanche`,
`oublié`, `s'immobilise`), de modo que a cifra não tem símbolo livre para o
ponto de exclamação. A página termina o verso em `;12` e nada depois.

**Verso 10 — a página imprime `&A>` onde a cifra pede `&A¢`.** Como `>` vale
"s" e `¢` vale "r", a linha lê "Pas l'espace" onde Mallarmé escreve "Par
l'espace". A leitura do glifo é segura: nessa impressora o `¢` é um "c"
atravessado por barra (visível no verso 11, `6''3¢¢)1¢` = "l'horreur") e o `>`
é um chevron — formas sem semelhança. Correlação de template do glifo em
questão contra glifos conhecidos da mesma página: 0,69 contra um `>` atestado,
0,18 e 0,17 contra dois `¢` atestados (que correlacionam 0,96 entre si, como
controle). O próprio verso 10 traz um `>` legítimo quatro caracteres depois,
em `6')>&A")` ("l'espace").

**Verso 14 — a página imprime um `-` a mais, em `&A¢72-`.** `-` vale "t", de
modo que a linha lê "parmit" onde Mallarmé escreve "parmi". O traço é um glifo
regular, não mancha: correlaciona 0,925 com o `-` legítimo da mesma linha (o
"t" de `=)-`, "vêt"), com a mesma largura e a mesma densidade de tinta dos
demais caracteres. É uma inserção pura — vem um espaço depois, logo não
desloca o resto do verso.

Vale notar que `-` é o único glifo ambíguo de toda a tabela: serve à letra "t"
e também ao hífen literal (o de "Va-t-il", `=A---26`). O caractere que sobra
cai exatamente sobre ele, o que dá duas leituras para a linha — "parmit", que
não é palavra francesa, ou "parmi-", com hífen suspenso. Não há como decidir
entre lapso e intenção a partir do impresso; registra-se a coincidência.

#### O que as duas variantes dizem

As duas divergências do impresso — versos 10 e 14 — não são equivalentes entre
si, e a diferença entre elas é o dado mais interessante que sobra.

**Verso 10 produz palavra francesa real.** `pas` é a partícula de negação, e em
uso elíptico, sem o `ne`, é corrente ("Pas de problème", "Pas moi"). Então a
linha lê "não o espaço" — não "sem o espaço", que seria *sans l'espace*. É
negação de identificação, não de privação. Só que ela desmonta a arquitetura do
terceto: em Mallarmé a agonia **é** infligida pelo espaço (`par l'espace`) e
**não** pelo horror do solo (`mais non l'horreur du sol`, v. 11). Negar os dois
lados colapsa a antítese sobre a qual os três versos estão construídos. E
`infligée`, feminino concordando com `agonie` (v. 9), tem em `par l'espace` o
seu agente: sem o `par`, o particípio fica sem agente e a sintaxe desanda.

**Verso 14 produz não-palavra.** `parmit` não existe em francês. Nem se trata de
`permit`: este cifra como `&)¢72-`, a um único glifo do impresso — mas o glifo
em questão é o da vogal, e nós o lemos, é `A` (letra "a"), não `)` (letra "e").
Além disso `permit` é passé simple de *permettre*, "permitiu", não "permite"
(que seria `permet` = `&)¢7)-`, a dois glifos), e *"Que vêt permit l'exil"*
poria dois verbos finitos em sequência. `parmi` é peça estrutural: o `que` do
verso 14 retoma o `songe froid de mépris` do verso 13 como objeto, `le Cygne` é
o sujeito posposto de `vêt`, e é `parmi l'exil inutile` que se interpõe entre
verbo e sujeito, sustentando a inversão. Removida a preposição, nenhuma palavra
vizinha salva a linha.

Daí a assimetria: o verso 10 tem cara de acidente **linguístico** — alguém
transcreveu Mallarmé errado, num ponto onde a negação é semanticamente
carregada. O verso 14 tem cara de acidente **mecânico** — coluna repetida na
perfuração, do mesmo tipo que produz `=A---26` para "va-t-il". Dois desvios com
causas de natureza diferente, o que, sem provar nada, pesa contra a hipótese de
um desenho único e deliberado: quem quisesse marcar o poema com duas variantes
escolheria duas que funcionassem, e "parmit" não funciona em leitura alguma. A
única leitura do verso 14 que não exige supor erro segue sendo o hífen
suspenso, `parmi-`.

Por isso a comparação em `soneto_alfanumerico.rb` alinha as duas sequências
por subsequência comum máxima (`align`) em vez de compará-las posição a
posição: o caractere inserido no verso 14 contaria, numa comparação ingênua,
como 22 erros em cascata em vez de 1.

Uma quarta observação, que não entra na contagem: o primeiro caractere do
verso 14 está impresso como um traço baixo e grosso, mais largo que qualquer
glifo da linha e com mais tinta (mínimo de 66 contra mediana de 96), onde a
cifra pede `+` (a letra "q" de "Que"). O `+` desta impressora é uma cruz bem
definida (verso 12, `+1'A`). A transcrição mantém `+`, por ser o caractere
que a cifra exige e que a mancha cobre, mas o borrão fica registrado aqui.

## 4. Resultado

`soneto_alfanumerico.rb` implementa a tabela acima como `encode()`/`decode()` e,
ao rodar (`ruby soneto_alfanumerico.rb`), compara automaticamente sua própria
saída, verso a verso, com a transcrição da página — reproduzindo o processo de
verificação descrito acima de forma auditável e repetível.

```
$ ruby soneto_alfanumerico.rb
 1  100.0%  Le vierge, le vivace et le bel aujourd'hui
 ...
10   97.3%  Par l'espace infligée à l'oiseau qui le nie,
        divergencia do impresso: a pagina traz ">" onde a cifra pede "¢"
 ...
14   97.0%  Que vêt parmi l'exil inutile le Cygne.
        divergencia do impresso: a pagina traz "-" a mais
TOTAL: 509/512 caracteres coincidem (99.4%)
```

## 5. O que isso muda em relação ao que já se sabia

As fontes secundárias disponíveis (Risério, Augusto de Campos, historiografia da
poesia eletrônica brasileira) descrevem o procedimento em termos gerais —
"tradução criptográfica", "letras e dígitos em base permutatória" — sem publicar
a tabela ou o programa original. Não encontramos, nas fontes que consultamos,
nenhuma reconstrução publicada da transformação completa em código executável.
O que apresentamos aqui é:

- uma transcrição cuidadosa, feita por leitura direta da imagem (não OCR), das
  14 linhas do Soneto Alfanumérico;
- a tabela de substituição letra-a-símbolo que essa transcrição implica, quando
  comparada ao soneto de Mallarmé, verso a verso;
- um algoritmo em Ruby que verifica essa tabela de forma reprodutível, com
  99,4% de correspondência exata contra a página publicada — e que localiza e
  classifica os três caracteres restantes: duas divergências do impresso de
  1974 e um limite do alfabeto da própria cifra.

Isso é uma **reconstrução nossa da camada de substituição**, obtida por
engenharia reversa a partir do resultado publicado — não uma recuperação do
programa Fortran/PL-1 original de Erthos, que não sobreviveu (ou ao menos não
está disponível nas fontes consultadas). Em particular, continuamos sem saber
*como* Erthos chegou a essa tabela específica de 23 símbolos (se por escolha
manual, por uma tabela de código de máquina da época, ou por algum outro
procedimento algorítmico) — essa é a pergunta que ficaria para uma próxima
etapa de pesquisa, idealmente em arquivo com acesso aos números originais da
revista *Código* ou a papéis pessoais de Erthos.

### 5.1. Uma conjectura sobre os dígitos (e sobre o `k`)

Sobre *como* Erthos chegou à tabela, há um fragmento que talvez tenha
explicação — e que vale registrar como conjectura falsificável, não como
achado.

Seis letras recebem dígito como símbolo: `u→1`, `i→2`, `o→3`, `j→4`, `l→6`,
`m→7`. Elas não estão espalhadas pelo alfabeto: são vizinhas no teclado. São o
bloco 3×3 sob os dedos indicador, médio e anular da mão direita num QWERTY.
Numerando as nove teclas em ordem de leitura:

```
u=1   i=2   o=3
j=4   k=5   l=6
m=7   ,=8   .=9
```

As seis atestadas conferem, todas. E a hipótese faz duas previsões que não
foram usadas para montá-la:

- o dígito **8** não pode aparecer, porque sua tecla é a vírgula — e a vírgula
  atravessa a cifra como pontuação literal, nunca precisou de símbolo;
- o dígito **9** não pode aparecer, pelo mesmo motivo, com o ponto.

Os dígitos ausentes da página são exatamente `0`, `5`, `8`, `9`. O 8 e o 9 são
a vírgula e o ponto; o 0 não tem tecla no bloco; e o 5 é o `k`, que não ocorre
em nenhuma palavra do soneto de Mallarmé. Daí a conjectura: **`k` seria `5`**.

Dois freios, ambos sérios:

1. O padrão foi encontrado olhando os dados, não previsto antes deles. Se o
   layout tivesse sido fixado *a priori*, acertar as seis seria 1 em 720; como
   o layout foi escolhido depois de ver o resultado, esse número não vale. O
   que sustenta a conjectura não é o acerto de 6 em 6, é as duas previsões
   independentes sobre o 8 e o 9.
2. A hipótese não explica as outras 17 letras. Dispondo os 23 símbolos sobre o
   teclado, o restante (`q→+`, `w→?`, `e→)`, `a→A`, `s→>`…) não exibe estrutura
   defensável. Se o teclado explica algo, explica um fragmento — os dígitos — e
   não a tabela inteira. Pode ser que Erthos tenha atribuído os dígitos por
   proximidade no teclado e o resto por outro critério; pode ser coincidência
   num pedaço pequeno.

Para `w` e `z` não há nem isso: caem fora do bloco, e sobram `0`, `8`, `9` mais
os glifos do conjunto EBCDIC que a página nunca imprime. Nada permite escolher.
A conjectura é sobre `k`, e só.

Ela é falsificável de duas maneiras: por qualquer outro texto cifrado por
Erthos que contenha um `k` (o "Tombeau de Mallarmé" de 1975, por exemplo), ou
por um teclado ou perfuradora documentadamente usados por ele cujo arranjo
contradiga o bloco acima.

## 6. O cisne que é signo: a alusão em Mallarmé

Por que Erthos escolheu justo *este* soneto de Mallarmé para submeter ao
computador, e não outro? A resposta está no próprio poema francês — e é um
trocadilho que só existe em francês, o que torna a escolha ainda mais
pontuda quando o soneto vira, literalmente, uma sequência de símbolos.

### 6.1. O poema: um cisne preso no gelo

"Le vierge, le vivace et le bel aujourd'hui" (1885) — às vezes chamado
simplesmente de "Le Cygne" ("O Cisne") pela crítica — descreve um lago
gelado onde um cisne ficou preso. Ele quer se libertar de um bater de asas
("un coup d'aile ivre") que rasgaria o gelo, mas não consegue: suas penas
estão presas na "geleira transparente dos voos que não fugiram" (v. 3-4).
O motivo de estar preso é revelado no primeiro terceto: ele não cantou a
"região onde viver" ("pour n'avoir pas chanté la région où vivre", v. 7) —
ou seja, não é um acidente, é uma espécie de punição por silêncio, por não
ter criado a tempo. No fim, o cisne é reduzido a um fantasma imóvel,
"vestido" pelo "exílio inútil" (v. 14), puro brilho preso a um lugar do
qual não pode escapar.

A leitura crítica corrente — presente tanto em comentários acadêmicos
quanto em ensaios de tradutores do soneto — trata esse cisne congelado como
alegoria do próprio poeta (ou da Poesia) tomado por uma paralisia criativa:
a vontade de romper com a forma poética herdada e "voar" para algo novo,
travada pelo peso da tradição e pelo medo/fracasso de já ter deixado passar
o momento certo de cantar. É um poema sobre o poeta que não conseguiu
escrever o poema.

### 6.2. O trocadilho que sustenta tudo: cygne / signe

Em francês, "cygne" (cisne) e "signe" (signo, sinal) são homófonos — soam
exatamente igual. Comentadores do soneto (e da obra de Mallarmé em geral,
onde o mesmo jogo reaparece em outros poemas, como o célebre "sonnet en
-yx") apontam esse duplo sentido como central, não acidental: ao escrever
sobre um cisne, Mallarmé também está escrevendo sobre um *signo* — sobre a
própria natureza da linguagem poética, presa entre o que quer dizer e o que
consegue dizer. O cisne gelado é, ao mesmo tempo, um pássaro e um signo
linguístico imóvel, incapaz de significar o que deveria.

### 6.3. Por que isso importa para o Soneto Alfanumérico

É aqui que a escolha de Erthos deixa de ser arbitrária. Um poema que já é,
no nível da língua francesa, sobre um cisne-que-é-signo — sobre a
linguagem presa, incapaz de se libertar da forma que a aprisiona — é
justamente o poema que Erthos decide converter, literal e mecanicamente,
numa sequência de *signos*: os 23 símbolos alfanuméricos da tabela da
seção 3.4 (`A`, `¢`, `6`, `¬`...). O trocadilho cygne/signe, que em
Mallarmé é metafórico, Erthos o torna concreto: o cisne francês vira, sob
o processamento Fortran/PL-1, um punhado de signos datilografados — a
"geleira transparente" do poema original tem agora um equivalente real, o
código-fonte que aprisiona cada letra num símbolo fixo, verso a verso, sem
que nenhuma delas possa "bater as asas" e sair da tabela de substituição.

Nesse sentido, o Soneto Alfanumérico não é só uma brincadeira formal com
computador — é uma leitura crítica do próprio Mallarmé, feita com os meios
de 1974: se o poeta simbolista já imaginava a linguagem como um sistema de
signos frios e autônomos, presos a uma forma da qual não escapam sozinhos,
Erthos leva essa ideia ao pé da letra e constrói, com um programa de
computador, a "geleira" literal em que o poema de Mallarmé — junto com o
cisne que ele descreve — fica preso.

## 7. Fontes

- [Erthos Albino de Souza — Wikipédia](https://pt.wikipedia.org/wiki/Erthos_Albino_de_Souza)
- [Revista Código — Revista Acrobata](https://revistaacrobata.com.br/acrobata/artigo/codigo-revista-codigo-site/)
- [Jorge Luiz Antonio, "Trayectoria de la poesía electrónica en Brasil" — Escáner Cultural](https://revista.escaner.cl/node/714.html)
- [Regina, "Poesia: do dáctilo ao dígito" (blog)](https://regina-sussurro.blogspot.com/2013/10/poesia-do-dactilo-ao-digito.html)
- Texto de Mallarmé conforme edição corrente de *Poésies* (1899), "Le vierge, le vivace et le bel aujourd'hui".
- [Analysis of Mallarmé's 1885 sonnet "Le vierge, le vivace et le bel aujourd'hui" — LitExplore](https://litexplore.com/2020/07/18/analysis-of-mallarmes-1885-sonnet-le-vierge-le-vivace-et-le-bel-aujourdhui/)
- [Le Bel Aujourd'hui: Translating Mallarmé's "Le Cygne" — LitAllOver](https://litallover.com/2016/09/28/le-bel-aujourdhui-a-translation-walkthrough-of-mallarmes-le-cygne/)

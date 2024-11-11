
- [Exercícios para terça-feira](#exercícios-para-terça-feira)
  - [Ver o vídeo:](#ver-o-vídeo)
  - [Praticando o uso do pacote
    stringr](#praticando-o-uso-do-pacote-stringr)
  - [Praticando conceitos vistos na parte de
    pré-processamento](#praticando-conceitos-vistos-na-parte-de-pré-processamento)

# Exercícios para terça-feira

## Ver o vídeo:

- [Como organizar seu banco de dados para análises
  estatísticas](https://www.youtube.com/watch?v=wzfPR2oQ61A), por
  Fernanda Peres

------------------------------------------------------------------------

## Praticando o uso do pacote stringr

``` r
library(stringr)
```

    ## Warning: package 'stringr' was built under R version 4.2.3

``` r
library(purrr)
# https://www.camara.leg.br/enquetes/2373385
texto_exemplo <- "   Altera o Decreto Lei nº 1.804, de 3 de setembro de 1980, para aumentar o valor de minimis na importação de USD 50,00 para USD 100,00, reduzir a alíquota do imposto de importação de 60% para 20% e aumentar o valor máximo das remessas expressas de USD 3.000,00 para USD 5.000,00.   "
```

1)  Use a função `str_to_lower()` para deixar todas as letras do texto
    em minúsculo.

``` r
str_to_lower(texto_exemplo)
```

    ## [1] "   altera o decreto lei nº 1.804, de 3 de setembro de 1980, para aumentar o valor de minimis na importação de usd 50,00 para usd 100,00, reduzir a alíquota do imposto de importação de 60% para 20% e aumentar o valor máximo das remessas expressas de usd 3.000,00 para usd 5.000,00.   "

2)  Use a função `str_to_upper()` para deixar todas as letras do texto
    em maiúsculo.

``` r
str_to_upper(texto_exemplo)
```

    ## [1] "   ALTERA O DECRETO LEI Nº 1.804, DE 3 DE SETEMBRO DE 1980, PARA AUMENTAR O VALOR DE MINIMIS NA IMPORTAÇÃO DE USD 50,00 PARA USD 100,00, REDUZIR A ALÍQUOTA DO IMPOSTO DE IMPORTAÇÃO DE 60% PARA 20% E AUMENTAR O VALOR MÁXIMO DAS REMESSAS EXPRESSAS DE USD 3.000,00 PARA USD 5.000,00.   "

3)  Use a função `str_trim()` para remover os espaços em branco no
    início e no final do texto.

``` r
str_trim(texto_exemplo)
```

    ## [1] "Altera o Decreto Lei nº 1.804, de 3 de setembro de 1980, para aumentar o valor de minimis na importação de USD 50,00 para USD 100,00, reduzir a alíquota do imposto de importação de 60% para 20% e aumentar o valor máximo das remessas expressas de USD 3.000,00 para USD 5.000,00."

4)  Use a função `str_detect()` para verificar se o texto contém a
    palavra “importação”.

- Retorna verdadeiro/Falso

``` r
str_detect(texto_exemplo, pattern = "importação")
```

    ## [1] TRUE

``` r
textos <- c("tres", "x")
str_detect(texto_exemplo, pattern = textos)
```

    ## [1] FALSE  TRUE

``` r
textos_2 <- c("tres", "x") |> 
  paste0(collapse = "|")
str_detect(texto_exemplo, pattern = textos_2)
```

    ## [1] TRUE

5)  Use a função `str_count()` para contar quantas vezes a palavra
    “importação” aparece no texto.

``` r
str_count(texto_exemplo, pattern = "importação")
```

    ## [1] 2

6)  Use a função `str_replace()` para substituir a palavra “importação”
    por “exportação”.

``` r
# só substitui na primeira vez que o padrão aparece
str_replace(texto_exemplo, pattern = "importação", replacement = "exportação")
```

    ## [1] "   Altera o Decreto Lei nº 1.804, de 3 de setembro de 1980, para aumentar o valor de minimis na exportação de USD 50,00 para USD 100,00, reduzir a alíquota do imposto de importação de 60% para 20% e aumentar o valor máximo das remessas expressas de USD 3.000,00 para USD 5.000,00.   "

``` r
# substituir em todas as vezes que o padrão aparece
str_replace_all(texto_exemplo, pattern = "importação", replacement = "exportação")
```

    ## [1] "   Altera o Decreto Lei nº 1.804, de 3 de setembro de 1980, para aumentar o valor de minimis na exportação de USD 50,00 para USD 100,00, reduzir a alíquota do imposto de exportação de 60% para 20% e aumentar o valor máximo das remessas expressas de USD 3.000,00 para USD 5.000,00.   "

``` r
str_replace(texto_exemplo, pattern = "USD", replacement = "R$")
```

    ## [1] "   Altera o Decreto Lei nº 1.804, de 3 de setembro de 1980, para aumentar o valor de minimis na importação de R$ 50,00 para USD 100,00, reduzir a alíquota do imposto de importação de 60% para 20% e aumentar o valor máximo das remessas expressas de USD 3.000,00 para USD 5.000,00.   "

``` r
str_replace_all(texto_exemplo, pattern = "USD", replacement = "R$")
```

    ## [1] "   Altera o Decreto Lei nº 1.804, de 3 de setembro de 1980, para aumentar o valor de minimis na importação de R$ 50,00 para R$ 100,00, reduzir a alíquota do imposto de importação de 60% para 20% e aumentar o valor máximo das remessas expressas de R$ 3.000,00 para R$ 5.000,00.   "

7)  Use a função `str_replace_all()` para substituir a palavra
    “importação” por “exportação” e a palavra “Decreto Lei” por “Lei”.

``` r
# mais fácil de ler
texto_exemplo |>
  str_replace_all(pattern = "importação", replacement = "exportação") |>
  str_replace_all(pattern = "Decreto Lei", replacement = "Lei")
```

    ## [1] "   Altera o Lei nº 1.804, de 3 de setembro de 1980, para aumentar o valor de minimis na exportação de USD 50,00 para USD 100,00, reduzir a alíquota do imposto de exportação de 60% para 20% e aumentar o valor máximo das remessas expressas de USD 3.000,00 para USD 5.000,00.   "

``` r
# menos código
str_replace_all(texto_exemplo, 
                c("importação" = "exportação",
                  "Decreto Lei" = "Lei"))
```

    ## [1] "   Altera o Lei nº 1.804, de 3 de setembro de 1980, para aumentar o valor de minimis na exportação de USD 50,00 para USD 100,00, reduzir a alíquota do imposto de exportação de 60% para 20% e aumentar o valor máximo das remessas expressas de USD 3.000,00 para USD 5.000,00.   "

``` r
# %>% - magrittr, tidyverse 
# |> - R >= 4.1 
```

8)  Use a função `str_split()` para separar o texto em duas partes:
    antes e depois da vírgula “,”.

``` r
str_split_1(texto_exemplo, pattern = ",") |> 
  str_trim()# retorna um vetor!
```

    ## [1] "Altera o Decreto Lei nº 1.804"                                                                                            
    ## [2] "de 3 de setembro de 1980"                                                                                                 
    ## [3] "para aumentar o valor de minimis na importação de USD 50"                                                                 
    ## [4] "00 para USD 100"                                                                                                          
    ## [5] "00"                                                                                                                       
    ## [6] "reduzir a alíquota do imposto de importação de 60% para 20% e aumentar o valor máximo das remessas expressas de USD 3.000"
    ## [7] "00 para USD 5.000"                                                                                                        
    ## [8] "00."

1)  Nesse exemplo, usamos a função ver `str_view()` onde estão
    localizados os valores monetários.

``` r
# SIM, PARECE QUE UM GATO ANDOU NO TECLADO!
str_view(texto_exemplo, "USD \\d+?[.]?\\d+[,]?\\d+")
```

    ## [1] │    Altera o Decreto Lei nº 1.804, de 3 de setembro de 1980, para aumentar o valor de minimis na importação de <USD 50,00> para <USD 100,00>, reduzir a alíquota do imposto de importação de 60% para 20% e aumentar o valor máximo das remessas expressas de <USD 3.000,00> para <USD 5.000,00>.

Agora tente usar essa função para localizar as porcentagens:

``` r
str_view(texto_exemplo, pattern = "\\d+%")
```

    ## [1] │    Altera o Decreto Lei nº 1.804, de 3 de setembro de 1980, para aumentar o valor de minimis na importação de USD 50,00 para USD 100,00, reduzir a alíquota do imposto de importação de <60%> para <20%> e aumentar o valor máximo das remessas expressas de USD 3.000,00 para USD 5.000,00.

``` r
str_detect(texto_exemplo, pattern = "\\d+%")
```

    ## [1] TRUE

``` r
str_extract(texto_exemplo, "\\d+%")
```

    ## [1] "60%"

``` r
str_extract_all(texto_exemplo, "\\d+%") |> 
  list_c()
```

    ## [1] "60%" "20%"

------------------------------------------------------------------------

## Praticando conceitos vistos na parte de pré-processamento

O site da Câmara dos deputados tem uma página de temas:
<https://www.camara.leg.br/temas/>

- Agropecuária

- Cidades e transportes

- Ciência, tecnologia e comunicações

- Consumidor

- Coronavírus

- Direitos humanos

- Economia

- Educação, cultura e esportes

- Meio ambiente e energia

- Política e administração pública

- Reforma da Previdência

- Relações exteriores

- Saúde

- Segurança

- Trabalho, previdência e assistência

Escolha um tema de interesse, e na página do tema, é possível ver as
enquetes mais votadas. Escolha alguma enquete de interesse (de
preferência que tenha respostas para conseguirmos analisar), e tente
explorar os conceitos vistos na parte de pré-processamento usando esses
dados.

Anote as dúvidas. De preferência, anote também suas dúvidas no arquivo
que estamos usando no Google Drive, para que seja fácil de encontrar e
conversar sobre durante a aula.

Coloque o link para a enquete que você escolheu lá no arquivo do Google
drive, ao lado do seu nome! Assim, podemos ver as enquetes que cada um
escolheu.

# Carragando os pacotes
library(tidyverse)
library(tidytext)
library(stopwords)
# devtools::install_github("dfalbel/ptstem")
library(ptstem)


# importando os dados
resultados_enquete_raw <- read_rds("dados-brutos/resultados_enquete.rds")

# Conhecendo um pouco a base
resultados_enquete <- resultados_enquete_raw |>
  # separar a coluna data em data e hora
  separate(data, into = c("data", "hora"), sep = " ") |> 
  # converter a data que está em texto na classe data
  mutate(data = lubridate::dmy(data)) |> 
  # gerar um id para o comentário
  rowid_to_column("id_comentario") |> 
  # substituir ponto e _ por espaço
  mutate(
    conteudo = stringr::str_replace_all(conteudo, "\\.", " "),
    conteudo = stringr::str_replace_all(conteudo, "_", " "),
  )

# espiando os dados
glimpse(resultados_enquete)


# quantidade de comentários
# cada linha é um comentário
nrow(resultados_enquete)

# quantidade de curtidas nos comentários
sum(resultados_enquete$qtd_curtidas)

# quantidade de curtidas por posicionamento
# tabela de frequenca
resultados_enquete |> 
  group_by(posicionamento) |> 
  summarise(total_curtidas = sum(qtd_curtidas)) |> 
  mutate(porc_curtidas = total_curtidas / sum(total_curtidas),
         porc_curtidas = scales::percent(porc_curtidas)) 

# gráfico simples
resultados_enquete |> 
  count(data, posicionamento) |> 
  arrange(desc(n))
  ggplot() +
  aes(x = data, y = n) +
  geom_line(aes(color = posicionamento)) 

# Vamos começar a explorar o texto dos comentários ---------------------------

# Vamos usar o pacote tidytext para fazer a tokenização
tokens_enquete <- resultados_enquete  |> 
  unnest_tokens(output = palavra,
                input = conteudo,
                # o token é a palavra
                token = "words") 

# Palavras mais frequentes

tokens_enquete |> 
  count(palavra, sort = TRUE) |> View()

# tem muitas palavras que não são relevantes para a análise
# chamamos de STOP WORDS!

# Removendo stopwords ------------------------

# Ir para arquivo : scripts/stop-words.R

source("scripts/stop-words.R")


tokens_sem_stopwords <- tokens_enquete |> 
  filter(!palavra %in% stop_words_completo) |> 
  # Removendo números
  filter(!str_detect(palavra, "[0-9]"))

# Palavras mais frequentes sem stopwords

tokens_sem_stopwords |> 
  count(palavra, sort = TRUE) |> View()

# Problemas:
# - palavras com a mesma raiz são contadas separadamente
# ex: "votar", "votou", "votando", "votaram"
# - palavras singular/plural são contadas separadamente
# ex: imposto, impostos

# Erros de português -----

tokens_arrumados <- tokens_sem_stopwords |> 
  mutate(palavra = case_when(
    palavra %in% c("estrupador", "estruprad", "estrubador", "estrupudor", 
                   "estrupadoores", "estrupadoores", "estrutupador") ~ "estuprador",
    palavra %in% c("estrupo", "estrupos", "estrupro") ~ "estupro",
    palavra %in% c("estruprada", "estrupada") ~ "estuprada",
    .default = palavra
  ))


# https://docs.ropensci.org/spelling/index.html
# Pensar em formas melhores de fazer isso!


# Stemming ------------------------

# Stemming é o processo de reduzir palavras flexionadas 
# (ou às vezes derivadas) ao seu tronco (stem), base ou raiz,
# geralmente uma forma da palavra escrita.

# Vamos usar o pacote ptstem para fazer o stemming
# É um processo que pode demorar
# Vamos buscar os tokens únicos, e depois unir com os dados

# rm(resultados_enquete_raw)


length(tokens_arrumados$palavra)
length(unique(tokens_arrumados$palavra))

# pode demorar
stems <- tokens_arrumados |> 
  distinct(palavra) |> 
  mutate(stem = ptstem::ptstem(palavra)) # isso é meio demorado!

tokens_stem <- tokens_arrumados |>
  left_join(stems, by = "palavra") # proc V do excel

tokens_stem |> 
  count(stem, sort = TRUE) 

# checando os termos mais frequentes
tokens_stem |> 
  count(stem, sort = TRUE) |> View()




fs::dir_create("dados")


# Agora sim!
tokens_stem |> 
  write_rds("dados/tokens_preparados.rds")

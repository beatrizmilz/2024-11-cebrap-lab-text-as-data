# Importar dados textuais podem ser um desafio!
# Nesse exemplo, queremos chegar até o token, 
# que é a menor unidade de texto que faz sentido para a análise.
# A partir do token, podemos usar os conceitos usados nas aulas anteriores.

# Pacote readtext é útil
# https://cran.r-project.org/web/packages/readtext/vignettes/readtext_vignette.html

# Importar texto de sites: técnicas de web scraping, como 
# rvest::html_text() (mais avançado)

# pdftables
library(tidyverse)
library(tidytext)

library(readtext)
arquivo_pdf <- readtext::readtext("referencias/1859-Texto do artigo-3971-2-10-20210608.pdf")

# \n = pular

df_texto_estruturado <- arquivo_pdf |>
  mutate(text = str_split(text, "Steven Dutt-Ross ︱ Breno de Paula Andrade Cruz")) |> 
  unnest(text) |> 
  rowid_to_column("n_pagina") |>
  mutate(text = str_split(text, "\n")) |> 
  unnest(text) |> 
  group_by(n_pagina) |> 
  mutate(n_linha = row_number()) |> 
  ungroup()


textos_inicio_linha_remover <- c("Análise Quantitativa de Textos: ",
                                 "Quantitative Analysis of Texts: ",
                                 "DOI",
                                 "ISSN",
                                 "Administração: Ensino e Pesquisa") 



df_texto_limpo <- df_texto_estruturado |> 
  mutate(text = str_squish(text)) |> 
  filter(text != "", 
         !str_starts(text, paste0(textos_inicio_linha_remover, collapse = "|")),
         n_pagina %in% 1:32) |> 
  mutate(inicio = text == "Ciência e Coleta de Dados no Ambiente On-line",
         soma_inicio = cumsum(inicio)) |> 
  filter(soma_inicio > 0) |> 
  select(-c(inicio, soma_inicio))

source("scripts/stop-words.R")

df_tokens <- df_texto_limpo |>
  unnest_tokens(input = text, output = "word") 


df_sem_stop_words <- df_tokens |> 
  filter(!word %in% stop_words_completo,
         !str_detect(word, "[0-9]"))


df_sem_stop_words |> 
  count(word, sort = TRUE) |> 
  View()
    


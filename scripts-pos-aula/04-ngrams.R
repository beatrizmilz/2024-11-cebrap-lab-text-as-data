library(tidyverse)
library(tidytext)
library(stopwords)

resultados_enquete <- read_rds("dados-brutos/resultados_enquete.rds")



# Vamos usar o pacote tidytext para fazer a tokenização
# a função é a mesma que usavamos antes, 
# mas agora vamos informar os argumentos
# token e n (número de palavras por token)
tokens_bigram <- resultados_enquete  |>
  # gerar um id para o comentário
  rowid_to_column("id_comentario") |>
  # substituir ponto e _ por espaço
  mutate(
    conteudo = stringr::str_replace_all(conteudo, "\\.", " "),
    conteudo = stringr::str_replace_all(conteudo, "_", " "),
  ) |>
  unnest_tokens(
    output = bigram,
    input = conteudo,
    token = "ngrams",
    n = 2
  ) 

# preparando os dados

tokens_bigram_separados <- tokens_bigram |> 
   filter(!is.na(bigram)) |> 
    separate(bigram, c("palavra1", "palavra2"), sep = " ", remove = FALSE) 

# pergunta thiago
stringr::str_replace_all(c("eu moro em Vitória da Conquista e é muito legal",
                           "blablabla Vitória da Conquista"),
                         pattern = "Vitória da Conquista",
                          replacement = "Vitória-da-Conquista")

# Removendo stopwords ------------------------
# Carregando as stopwords em português
source("scripts/stop-words.R")

# Removendo stopwords e números
tokens_sem_stopwords <- tokens_bigram_separados |> 
  filter(!palavra1 %in% stop_words_completo) |> 
  filter(!palavra2 %in% stop_words_completo) |> 
  filter(!bigram %in% stop_words_bigram) |> 
  filter(!str_detect(bigram, "[0-9]")) 

bigrams_freq <- tokens_sem_stopwords |> 
  count(bigram, posicionamento, sort = TRUE) |> 
  group_by(posicionamento) |> 
  slice_max(n, n = 15) |> 
  ungroup() 

bigrams_freq |> 
  filter(posicionamento == "negativo") |> 
  mutate(bigram = forcats::fct_reorder(bigram, n)) |>  
  ggplot(aes(x = n, y = bigram)) +
  geom_segment(aes(y = bigram ,yend = bigram, x=0, xend=n)) +
  geom_point()
    

bigrams_freq |> 
  filter(posicionamento == "positivo") |> 
  mutate(bigram = forcats::fct_reorder(bigram, n)) |>  
  ggplot(aes(x = n, y = bigram)) +
  geom_segment(aes(y = bigram ,yend = bigram, x=0, xend=n)) +
  geom_point()
    

# dúvida do christy - análise de sentimento
# install.packages("syuzhet")

palavras <- bigrams_freq |>
  tidyr::separate_longer_delim(
    bigram, delim = " "
  ) |> 
  pull(bigram)

sentimentos <- syuzhet::get_nrc_sentiment(palavras, language = "portuguese")

sentimentos_com_palavra <- sentimentos |> 
  bind_cols(palavra = palavras) |> 
  relocate(palavra, .before = everything())


# install.packages("lexiconPT")
library(lexiconPT)
sentimentos_lexicon <- lexiconPT::get_word_sentiment(palavras[10])

sentimentos_lexicon

# Visualizando o tf-idf ------------------------

# Calculando o tf-idf por posicionamento
tf_idf <- tokens_sem_stopwords |> 
  count(bigram, posicionamento, sort = TRUE)   |> 
  bind_tf_idf(term = bigram, document = posicionamento, n = n) |> 
  arrange(desc(tf_idf))

# Visualizando os resultados
tf_idf |>
  group_by(posicionamento) |> 
  slice_max(tf_idf, n = 10, with_ties = FALSE) |> 
  mutate(bigram = reorder(bigram, tf_idf)) |>
  ungroup() |> 
  ggplot() +
  aes(x = tf_idf, y = bigram) +
  geom_col() +
  facet_wrap(~posicionamento, scales = "free")
  


# dúvida: e como detectar uma frase "pronta" copiada e colada em vários comentários?

janitor::get_dupes(resultados_enquete, conteudo) |> View()


buscando_padrao <- resultados_enquete |> 
  mutate(conteudo_limpo = str_to_lower(conteudo) |> 
           abjutils::rm_accent(),
         tem_frase = str_detect(conteudo_limpo, pattern = "crianca nao e mae")) 
  
buscando_padrao |> 
  filter(tem_frase == TRUE) |> 
  count(posicionamento, tem_frase)

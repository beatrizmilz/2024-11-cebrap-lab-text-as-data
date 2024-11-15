# instalar pacotes:
# install.packages("topicmodels")
# install.packages("tidytext")
# https://www.tidytextmining.com/topicmodeling
library(tidyverse)
library(tidytext)
library(topicmodels)
tokens <- readr::read_rds("dados/tokens_preparados.rds")


document_term_matrix <- tokens |>
  dplyr::count(posicionamento, stem) |>
  tidytext::cast_dtm(term = stem,
                     document = posicionamento,
                     value = n)


set.seed(1234)
sample(1:100, 3)





agrupamentos <- topicmodels::LDA(document_term_matrix, 
                                 # número de tópicos
                                 k = 2,
                                 control = list(seed = 1234))


# install.packages("reshape2")
# beta: method for extracting the per-topic-per-word probabilities
topicos_tidy <- tidytext::tidy(agrupamentos, matrix = "beta")

termos_topicos <- topicos_tidy |>
  group_by(topic) |> 
  slice_max(beta, n = 10) |> 
  ungroup() |> 
  arrange(topic, -beta)


termos_topicos |> 
  mutate(term = reorder_within(x = term, by = beta, within = topic)) |> 
  ggplot(aes(x = beta, y = term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()

  

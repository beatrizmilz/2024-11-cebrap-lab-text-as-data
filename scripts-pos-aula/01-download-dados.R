# Vamos usar os dados de enquetes da Câmara dos deputados
# onde a população pode votar a favor ou contra determinado
# projeto de lei, e deixar um comentário.

# Carregando pacotes
library(tidyverse)
library(janitor)

# Vamos buscar a enquete mais votada nos últimos 6 meses!
# https://www.camara.leg.br/enquetes/2434493
# https://www.camara.leg.br/propostas-legislativas/2434493

# ID da enquete é o numero que aparece no final da URL
id_enquete <- "2434493"

# URL para baixar os dados
# Conseguimos entender o link usando o botão baixar
url <- paste0(
  "https://www.camara.leg.br/enquetes/posicionamentos/download/todos-posicionamentos?idEnquete=",
  id_enquete,
  "&exibicao=undefined&ordenacao=undefined"
)

# Baixando os dados, limpando o nome das colunas,
# salvando o id da enquete como uma coluna


resultados_enquete <- read_csv(url, skip = 1) |>
  clean_names() |>
  mutate(id = id_enquete, .before = everything())


# criando pasta para guardar resultados
fs::dir_create("dados-brutos")

# Salvando os dados
write_rds(resultados_enquete, "dados-brutos/resultados_enquete.rds")


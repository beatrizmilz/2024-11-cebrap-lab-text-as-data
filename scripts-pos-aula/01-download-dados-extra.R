# Caso queira baixar dados de várias enquetes,
# o código a seguir pode ajudar:

# Dados abertos - Câmara dos deputados
# https://dadosabertos.camara.leg.br/swagger/api.html

# Carregando pacotes
library(tidyverse)
library(janitor)

# Buscando dados de projetos de lei
url_proposicoes_2024 <- "https://dadosabertos.camara.leg.br/arquivos/proposicoes/csv/proposicoes-2024.csv"

proposicoes <- read_csv2(url_proposicoes_2024)


baixar_proposicoes_ano <- function(ano, path = "dados/proposicoes/"){
  # criando url para baixar
  url_proposicoes <- paste0("https://dadosabertos.camara.leg.br/arquivos/proposicoes/csv/proposicoes-", ano, ".csv")
  
  # caso a pasta nao exista, criar
  fs::dir_create(path)
  
  # criar nome do arquivo para baixar
  nome_arquivo <- paste0(path, basename(url_proposicoes))
  
  # baixar arquivo
  download.file(url = url_proposicoes, destfile = nome_arquivo)

}

purrr::map(2010:2024, .f = baixar_proposicoes_ano, .progress = TRUE)

arquivos_para_ler <- fs::dir_ls("dados/proposicoes/")

proposicoes <- purrr::map(arquivos_para_ler, .f = read_csv2) |> 
  purrr::list_rbind()


proposicoes |> 
  count(descricaoTipo, sort = TRUE)

projetos_de_lei <- proposicoes |> 
  filter(descricaoTipo == "Projeto de Lei") 


# Para buscar os dados de enquete, podemos criar uma função simples:

baixar_enquete <- function(id_enquete) {
  url <- paste0(
    "https://www.camara.leg.br/enquetes/posicionamentos/download/todos-posicionamentos?idEnquete=",
    id_enquete,
    "&exibicao=undefined&ordenacao=undefined"
  )
  dados <- read_csv(url, skip = 1) |>
    clean_names() |>
    mutate(id = id_enquete, .before = everything()) |> 
    mutate(qtd_curtidas = as.numeric(qtd_curtidas))
  dados
}

# Experimentando a função:

baixar_enquete("2373385")

# Baixando dados de várias enquetes:

palavras_tema <- c("inteligência artificial")

projetos_tema <- projetos_de_lei |>
  filter(str_detect(str_to_lower(keywords), palavras_tema)) 


resultados_tema_lista <- map(projetos_tema$id, baixar_enquete, .progress = TRUE) 

resultados_tema <- resultados_tema_lista |> 
  bind_rows()


resultados_tema |> 
  count(id, sort = TRUE)


fs::dir_create("dados-brutos")


resultados_tema |> 
  write_rds("dados-brutos/resultados_enquetes-aborto.rds")

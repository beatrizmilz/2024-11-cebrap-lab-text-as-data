# gerar_zip
zip::zip(
  zipfile = "2023-11-cebrap-lab-text-as-data.zip",
  files = c(
    "2023-11-cebrap-lab-text-as-data.Rproj",
    "referencias/1859-Texto do artigo-3971-2-10-20210608.pdf",
    list.files("scripts", full.names = TRUE),
    list.files("exercicios", full.names = TRUE),
    list.files("scripts-pos-aula", full.names = TRUE)
  ),
  recurse = FALSE,
  compression = "zip"
)

library(googlesheets4)

url_sheet <- "https://docs.google.com/spreadsheets/d/1eSJ0n8yu_adDvgEeVnlfkK7eFT5vbyA8LoC1z1QKac8/edit?usp=sharing"

sheet_names(url_sheet)

tabela_links <- read_sheet(url_sheet, sheet = "Links de interesse")

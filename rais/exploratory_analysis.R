library(data.table)
library(reshape2)
library(ggplot2)
setwd("~/Desktop/tcc/data/rais")
path <- "data/"
files <- list.files(path)

# Função que recebe uma string e volta o número. Ex: ESTB2004.txt -> 2004
getYear <- function(filename){
  year <- gsub("\\D", "", filename)
  return(year)
}

# Cria uma lista de dt
dtList <- list()
for(file in files){
  data.tab <- fread(paste(path,file,sep=""))
  data.tab$year <- getYear(file)
  dtList[[getYear(file)]] <- data.tab
}
# Junta todos os arquivos
fulldt <- rbindlist(dtList)

# Tira a lista de DataTables porque não vai mais ser necessária
rm(dtList)

# Agrega por distrito
aggVat <- aggregate(qtd_vativo ~ distrito_sp + year, data = fulldt, FUN=sum)

# Colocaa os anos como colunas
dcastVat <- dcast(aggVat, distrito_sp ~ year)

# Calcula o total de empregos por ano 
total.jobs.year <- colSums(dcastVat[,-1], na.rm=T)

# Calcula o % de empregos por ano e por distrito
evo.jobs.year <- dcastVat[,-1]/total.jobs.year


x.axis <- as.numeric(names(evo.jobs.year))
plot(x.axis, evo.jobs.year[8,], type = 'l')




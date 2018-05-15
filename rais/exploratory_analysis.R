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
aggInd <- aggregate(qtd_vativo ~ cnae2 + year,  data = fulldt, FUN=sum) 


# Colocaa os anos como colunas
dcastVat <- dcast(aggVat, distrito_sp ~ year)
dcastInd <- dcast(aggInd, cnae2 ~ year)

# Calcula o total de empregos por ano 
total.jobs.year <- colSums(dcastVat[,-1], na.rm=T)
total.ind.year <- colSums(dcastInd[,-1], na.rm=T)

# Calcula o % de empregos por ano e por distrito
evo.jobs.year <- dcastVat[,-1]/total.jobs.year
evo.ind.year <- dcastInd[,-1]/total.ind.year

x.axis <- as.numeric(names(evo.jobs.year))

qplot(x=x.axis,y=as.numeric(evo.jobs.year[15,])) +
  geom_smooth()

qplot(x=x.axis,y=as.numeric(evo.ind.year[75,])) +
  geom_smooth()


# Os trabalhos estão mais distribuídos do que em 2006
hist(evo.jobs.year$`2006`)
hist(evo.jobs.year$`2016`)

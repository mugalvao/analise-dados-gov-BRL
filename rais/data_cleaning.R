library(data.table)
#Cria lista de arquivos .txt na pasta raw_data
setwd("/Users/renantardelli/Desktop/tcc/data/rais")

path_r <- "raw_data/"
raw_files <- list.files(path_r)

#Local dos arquivos depois de limpar
path_clean <- "data/"

# Como a ordem das colunas não muda podemos indexar pelo numero da coluna ou renomear 
for(file in raw_files){
  start_time <- Sys.time()
  print(paste("Reading file: ",file,sep = ""))
  base_full <- fread(paste(path, file, sep=""), sep = ";", showProgress = F)
  
  new_cols=c('bairro_sp', 'bairros_fortaleza', 'bairros_rj', 'cnae2', 'cnae95',
             'distrito_sp', 'qtd_vclt', 'qtd_vativo', 'qtd_vestat', 'atividade_ano', 
             'cei', 'pat', 'rais_negativa', 'ind_simples', 'municipio',
             'natureza_jur', 'regiao_df', 'cnae2_sub', 'tamanho_estab', 'tipo_estab',
             'tipo_estab2')

  # Cria colunas para os arquivos que nao tem, senao da erro porque o new_cols tem que tem mesmo length do dataframe
  file_cols <- dim(base_full)[2]
  dif <- file_cols - length(new_cols)
  if (length(new_cols) < file_cols){
    base_full[,(length(new_cols)+1):(length(new_cols) + dif)] <- NULL
  }
  
  names(base_full) <- new_cols
  base_full <- write.csv(base_full[base_full$municipio == 355030,],
                         file=paste(path_clean, substr(file, 1, 8), ".csv", sep = ""))
  print(Sys.time()-start_time)
}
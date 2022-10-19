# Definindo diretório ####
setwd('C:/FCD/R/UCI/Income_Predict')
getwd()


# Introdução ####

# O dataset foi feito a partir de uma pesquisa nacional em 1994 nos E.U.A
# O objetivo da análise é prever quem pode ter uma renda > ou <= $50K
# Essa análise tem como objetivo retornar uma acurácia de 90%

# fonte: https://archive.ics.uci.edu/ml/datasets/adult

# Carga dos datasets ####

bd1 <- read.csv('adult_train.csv') #32.561 registros
bd2 <- read.csv('adult_test.csv') # 16.281 registros
bd <- rbind(bd1, bd2) #48.842 registros
View(bd)

# Carga dos pacotes ####

library(ggplot2)
library(dplyr)
library(caret)


# Analise Exploratória ####

#Tipos de dados
str(bd)






# MOdelo de Classificação ####



# Resultados Finais ####





















# Arquivo para Kaggle ####

submission <- read.csv('sample_submission.csv') #3.982 registros


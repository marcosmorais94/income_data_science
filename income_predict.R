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
library(RColorBrewer)
library(forcats)

# Analise Exploratória ####

#Tipos de dados
str(bd)
summary(bd)

# Variável Preditora

bd$income <- case_when(bd$income == ' <=50K' ~ 0,
               bd$income == ' >50K' ~ 1,
               bd$income == ' <=50K.' ~ 0,
               bd$income == ' >50K.' ~ 1,
               TRUE ~ 2)

# Gráficos
# Histograma
hist <- ggplot(bd, aes(x = age)) +
        geom_histogram(color = 'white', fill = 'aquamarine4', binwidth = 2) +
        theme(panel.background = element_blank()) +
        labs(title = 'Histograma Idade',
             x = 'Idade',
             y = 'Contagem') + 
        scale_x_continuous(breaks = c(seq(from = min(bd$age), 
                                          to = max(bd$age),
                                          by = 5)), 
                           limits = c(15, 80))
  
hist
# Pelo histograma vemos que claramente os dados não estão normalizados
# Nesse caso, as variáveis numéricas precisam ser normalizadas. 
# Como temos mais de uma, a técnica deve ser aplicada para todas.

# Análise Escolaridade
colunas <- ggplot(bd) +
           geom_bar(aes(x = fct_infreq(education), 
                        fill = as.factor(income))) +
           labs(x = element_blank(),
                y = 'Quantidade',
                title = ' Variável Income x Escolaridade') +
           theme(panel.background = element_blank(),
                 legend.title = element_text('Income'))
           

colunas + scale_fill_manual(values = c('azure4', 'aquamarine4'))

# Vemos que High School é a principal categoria
# O nível da escolaridade pode sim influenciar a renda, a maioria das pessoas om doutorado ganham mais de 50K

# Análise raça
colunas_raca <- ggplot(bd) +
  geom_bar(aes(x = fct_infreq(race), 
               fill = as.factor(income))) +
  labs(x = element_blank(),
       y = 'Quantidade',
       title = ' Variável Income x Raça') +
  theme(panel.background = element_blank())

colunas_raca + scale_fill_manual(values = c('deepskyblue', 'cyan4'))

# Outro ponto que chama atenção é a raça, onde brancos tendem a ganhar mais que as outras raças

# Análise sexo
colunas_sexo <- ggplot(bd) +
  geom_bar(aes(x = fct_infreq(sex), 
               fill = as.factor(income))) +
  labs(x = element_blank(),
       y = 'Quantidade',
       title = ' Variável Income x Raça') +
  theme(panel.background = element_blank())

colunas_sexo + scale_fill_manual(values = c('deepskyblue', 'cyan4'))

# Homens tendem a ter uma renda maior que mulheres. 
# As 3 variáveis analisadas tendem a ter uma importância considerável para o modelo.


# Classes variável target
round(prop.table(table(bd$income))*100,2)
# O dataset possui 76% com pessoas ganhando menos de 50K
# Temos 16% de pessoas ganhando mais de 50K

# O dataset, apesar de estar desbalanceado, possui um comportamento esperado.


# Valores NAs
sum(is.na(bd))
# Não existe valores NA, ou não classificados dessa maneira. 
# Vale a pena analisar se existe valores diferentes nos atributos, como caracteres especipais como !

sapply(X = bd, FUN = 'unique')

#workclass, occupation e native country possuem valores como ?

sum(ifelse(bd$workclass == ' ?', 1, 0)) #2.799 registros
sum(ifelse(bd$occupation == ' ?', 1, 0)) #2.809 registros
sum(ifelse(bd$native.country == ' ?', 1, 0)) #857 registros

round((sum(ifelse(bd$occupation == ' ?', 1, 0))/nrow(bd))*100,2)
# 5,75% dos dados estão com ? em occupation. 
# A decisão será melhor remover esses dados no pré-processamento




# Pré - Processamento ####
bd_modelo <- bd

# Remoção variável com mais registros inválidos
bd_modelo <- bd_modelo[bd_modelo$occupation != ' ?',]


dmy <- dummyVars(" ~ .", data = dat, fullRank = T)
dat_transformed <- data.frame(predict(dmy, newdata = dat))

glimpse(dat_transformed)

# https://www.pluralsight.com/guides/encoding-data-with-r

# Modelo de Classificação ####



# Resultados Finais ####


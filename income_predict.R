# Definindo diretório ####
setwd('C:/FCD/R/UCI/Income_Predict')
getwd()


# Introdução ####

# O dataset foi feito a partir de uma pesquisa nacional em 1994 nos E.U.A
# O objetivo da análise é prever quem pode ter uma renda > ou <= $50K
# Essa análise tem como objetivo retornar uma acurácia de 90%

# Dicionário de Dados

# fonte: https://archive.ics.uci.edu/ml/datasets/adult

# Carga dos datasets ####

bd1 <- read.csv('adult_train.csv') #32.561 registros
bd2 <- read.csv('adult_test.csv') # 16.281 registros
bd <- rbind(bd1, bd2) #48.842 registros

rm(bd1, bd2)
View(bd)

# Carga dos pacotes ####

library(ggplot2)
library(dplyr)
library(caret)
library(RColorBrewer)
library(forcats)
library(ROCR) 
library(e1071)
library(rpart)
library(randomForest)

# Analise Exploratória ####

#Tipos de dados
str(bd)
summary(bd)

# Variável Preditora

bd$income <- case_when(bd$income == ' <=50K' ~ '<=50K',
               bd$income == ' >50K' ~ '>50K',
               bd$income == ' <=50K.' ~ '<=50K',
               bd$income == ' >50K.' ~ '>50K',
               TRUE ~ 'NA')

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
                        fill = income)) +
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
               fill = income)) +
  labs(x = element_blank(),
       y = 'Quantidade',
       title = ' Variável Income x Raça') +
  theme(panel.background = element_blank())

colunas_raca + scale_fill_manual(values = c('deepskyblue', 'cyan4'))

# Outro ponto que chama atenção é a raça, onde brancos tendem a ganhar mais que as outras raças

# Análise sexo
colunas_sexo <- ggplot(bd) +
  geom_bar(aes(x = fct_infreq(sex), 
               fill = income)) +
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

# Label da variável target
bd_modelo['income'] <- case_when(bd_modelo$income == '<=50K' ~ 0,
                                bd_modelo$income == '>50K' ~ 1,
                                TRUE ~ 0)

# Remoção variável education.num
#Já existe uma variável que trata da escolaridade dos participantes da pesquisa
bd_modelo['education.num'] <- NULL
str(bd_modelo)

# Criação de variáveis dummy

bd_dmy <- bd_modelo[,-15]

dmy <- dummyVars(" ~ .", data = bd_dmy, fullRank = T)
dat_modelo <- data.frame(predict(dmy, newdata = bd_dmy))

View(dat_modelo)

bd_final <- dat_modelo
bd_final['income'] <- bd_modelo[,14]

#Usar csv para balancear classes com Python
# Motivos de muitos bugs com SMOTE em R
write.csv2(bd_final, 'BD_modelo.csv', row.names = FALSE)
nomes <- colnames(bd_final)

# https://www.pluralsight.com/guides/encoding-data-with-r

# Carga do dataset balanceado
df_modelo <- read.csv('df_final.csv') #69.222 registros
colnames(df_modelo) <- nomes

round(prop.table(table(df_modelo$income))*100,2)
# Dataset está balanceado

# Função para normalização dos dados
df_modelo[c('age','fnlwgt','capital.gain','capital.loss','hours.per.week')] <- 
    scale(
      df_modelo[c('age','fnlwgt','capital.gain','capital.loss','hours.per.week')])

# Divisão em Dados de treino e teste
amostra_dados <- sample(x = nrow(df_modelo),
                        size = 0.8 * nrow(df_modelo),
                        replace = FALSE)

# Dados de treino e teste
bd_treino <- df_modelo[amostra_dados,]
bd_teste <- df_modelo[-amostra_dados,]

# Remove a varíavel target para teste do modelo
bd_teste_ml <- bd_teste[,-97] #Usar para teste do modelo!

# Modelo de Classificação ####

# Modelo v1.0 - Regressão Logística
modelo_v1 <- glm(formula = income ~ ., data = bd_treino, family = 'binomial')

# Cálculo das probilidades de regressão
resultado_v1 <- predict(modelo_v1, newdata = bd_teste_ml, type = 'response') 

#Variável resposta com valores convertidos em binário
resultado_v1 <- ifelse(resultado_v1 > 0.5, 1, 0) 

Modelo_1 <- confusionMatrix(table(data = resultado_v1, reference = bd_teste$income))
Modelo_1

# Feature Selection
formula <- "income ~ ."
formula <- as.formula(formula)
control <- trainControl(method = "repeatedcv", number = 10, repeats = 2)
model <- train(formula, data = bd_treino, method = "glm", trControl = control)
importance <- varImp(model, scale = FALSE)

# Top20 Variáveis de maior importância
A <- importance$importance %>% arrange(desc(Overall)) %>% top_n(30) 
A

top_var <- c('income ~ education.HS.grad + relationship.Not.in.family + relationship.Unmarried +
             education.Some.college + relationship.Own.child + occupation.Craft.repair +
             occupation.Machine.op.inspct + relationship.Other.relative + occupation.Other.service +
             education.7th.8th + education.11th + occupation.Transport.moving +
             education.Assoc.voc + occupation.Farming.fishing + occupation.Handlers.cleaners +
             education.Assoc.acdm + education.9th + workclass.Self.emp.not.inc + workclass.State.gov +
             education.Bachelors + occupation.Sales + workclass.Private + capital.gain +
             hours.per.week + education.5th.6th + education.12th + workclass.Local.gov +
             education.1st.4th + age')
top_var <- as.formula(top_var)

# Modelo v2.0 - Regressão Logística
modelo_v2 <- glm(formula = top_var, data = bd_treino, family = 'binomial')

# Cálculo das probilidades de regressão
resultado_v2 <- predict(modelo_v2, newdata = bd_teste_ml, type = 'response') 

#Variável resposta com valores convertidos em binário
resultado_v2 <- ifelse(resultado_v2 > 0.5, 1, 0) 

Modelo_2 <- confusionMatrix(table(data = resultado_v2, reference = bd_teste$income))
Modelo_2


# Modelo v3.0 - Regressão Logística usando 10 variáveis
top_var2 <- c('income ~ education.HS.grad + relationship.Not.in.family + relationship.Unmarried +
             education.Some.college + relationship.Own.child + occupation.Craft.repair +
             occupation.Machine.op.inspct + relationship.Other.relative + occupation.Other.service +
             education.7th.8th + education.11th')
modelo_v3 <- glm(formula = top_var2, data = bd_treino, family = 'binomial')

# Cálculo das probilidades de regressão
resultado_v3 <- predict(modelo_v3, newdata = bd_teste_ml, type = 'response') 

#Variável resposta com valores convertidos em binário
resultado_v3 <- ifelse(resultado_v2 > 0.5, 1, 0) 

Modelo_3 <- confusionMatrix(table(data = resultado_v3, reference = bd_teste$income))
Modelo_3
Modelo_2
Modelo_1

# Com a análise das variáveis com maior importância, a melhor alternatica é filtrar as melhores no modelo final

# Resultados Finais ####


# Função para Plot ROC 
plot.roc.curve <- function(predictions, title.text){
  perf <- performance(predictions, "tpr", "fpr")
  plot(perf,col = "black",lty = 1, lwd = 2,
       main = title.text, cex.main = 0.6, cex.lab = 0.8,xaxs = "i", yaxs = "i")
  abline(0,1, col = "red")
  auc <- performance(predictions,"auc")
  auc <- unlist(slot(auc, "y.values"))
  auc <- round(auc,2)
  legend(0.4,0.4,legend = c(paste0("AUC: ",auc)), cex = 0.6, bty = "n", box.col = "white")
  
}

# Plot
par(mfrow = c(1, 2))
plot.roc.curve(previsoes_finais, title.text = "Curva ROC")

![money-finance-business-financial](https://user-images.githubusercontent.com/91103250/196821754-a06a67a3-8cce-4620-b652-b4f8cd4431a5.jpg)

# Análise Preditiva - Renda Anual
O objetivo desta análise preditiva é determinar se a renda de uma determinada pessoal é superior a US$ 50K/ano, com base em um questionário populacional contendo informações sobre educação e horas de trabalho, por exemplo. Dataset disponibilizado pelo UCI.

## Pesquisa de Renda E.U.A
A Pesquisa de Renda e Participação em Programas (SIPP) é uma pesquisa estatística realizada pelo E.U.A Census Bureau. O SIPP é projetado para fornecer informações precisas e abrangentes sobre a renda de indivíduos e famílias americanas e sua participação em programas de transferência de renda. 

Fonte do dataset: https://archive.ics.uci.edu/ml/datasets/adult

## Dicionário de Dados


| Atributo  | Descrição | Métrica |
| ------------- | ------------- | ------------- |
| age | Idade do entrevistado | Numérico  |
| workclass Cell  | Tipo de trabalho do entrevistado  |  Private, Self-emp-not-inc, Self-emp-inc, Federal-gov, Local-gov, State-gov, Without-pay, Never-worked  |
| fnlwgt  | Representa o peso da população que respondeu cada registro  | Numérico  |
| education  | Escolaridade do entrevistado  | Bachelors, Some-college, 11th, HS-grad, Prof-school, Assoc-acdm, Assoc-voc, 9th, 7th-8th, 12th, Masters, 1st-4th, 10th, Doctorate, 5th-6th, Preschool  |
| education-num  | Número escolaridade do entrevistado | Numérico  |
| marital-status  | Estado Civil do entrevistado | Married-civ-spouse, Divorced, Never-married, Separated, Widowed, Married-spouse-absent, Married-AF-spouse  |
| occupation  | Cargo do entrevistado  | Tech-support, Craft-repair, Other-service, Sales, Exec-managerial, Prof-specialty, Handlers-cleaners, Machine-op-inspct, Adm-clerical, Farming-fishing, - - Transport-moving, Priv-house-serv, Protective-serv, Armed-Forces  |
| relationship  | Relacionamento | Wife, Own-child, Husband, Not-in-family, Other-relative, Unmarried  |
| race  | Raça  | White, Asian-Pac-Islander, Amer-Indian-Eskimo, Other, Black  |
| sex  | Gênero | Female, Male  |
| capital-gain  | Ganho de capital  | Numérico  |
| capital-loss  | Perda de capital  | Numérico  |
| hours-per-week  | Horas trabalhadas por semana  | Numérico |
| native-country  | Nacionalidade  | United-States, Cambodia, England, Puerto-Rico, Canada, Germany, Outlying-US(Guam-USVI-etc), India, Japan, Greece, South, China, Cuba, Iran, Honduras, Philippines, Italy, Poland, Jamaica, Vietnam, Mexico, Portugal, Ireland, France, Dominican-Republic, Laos, Ecuador, Taiwan, Haiti, Columbia, Hungary, Guatemala, Nicaragua, Scotland, Thailand, Yugoslavia, El-Salvador, Trinadad&Tobago, Peru, Hong, Holand-Netherlands  |
| Income  | Classe da renda  | Duas classes com <= 50K e > 50K  |

Informações do Dataset
|   |  |
| ------------- | ------------- |
| Total de Registros  | 48.842  |
| Total de Atributos  | 15  |

#Calculation of Contamination Factor
#Script is dependent on packages: readxl, ggplot2, reshape2, plyr
library(ggplot2)

#Data import if not already done from before
path = "File Path to Publication_Data.xlsx" #Alternatively, moss_data from previous 'Code - Processing, Cleaning, and Summary Statistics.R' is the same
moss_data <- readxl::read_excel(path, sheet = "Moss Data")

#Data input is moss_data from Code - Processessing, Cleaning, and Summary Statistics
input <- moss_data[21:73]
elements <- names(moss_data)[21:73]
site_info = moss_data[,1:20]

Contamination_Factor = data.frame(matrix(ncol=length(input), nrow = 20))
colnames(Contamination_Factor) <- elements
row_names_sites <- moss_data[,1]
rownames(Contamination_Factor) <- row_names_sites

for (i in seq(20)){
  for (n in seq_along(input)){
    a = input[i,n]
    b = input[20,n]
    val = a / b
    Contamination_Factor[i,n] = val
  }
}

#Summary of Contamination Factors
row_names_summary_CF <- c('Mean','Max','Min')

summary_CF <- data.frame(matrix(ncol = length(elements), nrow = length(row_names_summary_CF)))
colnames(summary_CF) <- elements
rownames(summary_CF) <- row_names_summary_CF

table <-  Contamination_Factor[1:19,]
n = 0
for (i in table){
  n = n + 1
  vec = as.double(i)

  summary_CF[1,n] <- mean(vec)
  summary_CF[2,n] <- max(vec)
  summary_CF[3,n] <- min(vec)
}


#Add Site Location Data to Data Frame
#Join Site_Info with Numeric Moss data
#Merge with names
CF_data = cbind(data.frame(site_info), data.frame(Contamination_Factor))

#Export and save table of contamination factors and summary
write.csv(CF_data, file = "Path to Save to/Contamination_Factor.csv")
write.csv(summary_CF, file = "Path to Save to/Summary_Contamination_Factor.csv")

#Boxplots of elemental data
#Boxplots of summary statistics
pd1 = reshape2::melt(Contamination_Factor[1:19,1:25])
pd2 = reshape2::melt(Contamination_Factor[1:19,26:53])

is_outlier <- function(x) {
  return(x < quantile(x, 0.25) - 1.5 * IQR(x) | x > quantile(x, 0.75) + 1.5 * IQR(x))
}

pd1 = pd1[is.finite(pd1$value), ]
pd2 = pd2[is.finite(pd2$value), ]

elements_pd1 = unique(pd1$variable)
outliers_pd1 = c()
for(i in elements_pd1){
  temp = is_outlier(Contamination_Factor[1:19,i])
  for(i in 1:length(temp)){
    if(temp[i] == FALSE){
      temp[i] = ""}
    else if(temp[i] == TRUE){
      temp[i] = i}
  }
  outliers_pd1 = c(outliers_pd1,temp)
}

elements_pd2 = unique(pd2$variable)
outliers_pd2 = c()
for(i in elements_pd2){
  temp = is_outlier(Contamination_Factor[1:19,i])
  for(i in 1:length(temp)){
    if(temp[i] == FALSE){
      temp[i] = ""}
    else if(temp[i] == TRUE){
      temp[i] = i}
  }
  outliers_pd2 = c(outliers_pd2,temp)
}

for(i in 1:length(outliers_pd1)){
  if(outliers_pd1[i] == "1"){outliers_pd1[i] = "Site 2"}
  if(outliers_pd1[i] == "2"){outliers_pd1[i] = "Site 5"}
  if(outliers_pd1[i] == "3"){outliers_pd1[i] = "Site 7"}
  if(outliers_pd1[i] == "4"){outliers_pd1[i] = "Site 10"}
  if(outliers_pd1[i] == "5"){outliers_pd1[i] = "Site 11"}
  if(outliers_pd1[i] == "6"){outliers_pd1[i] = "Site 12"}
  if(outliers_pd1[i] == "7"){outliers_pd1[i] = "Site 13"}
  if(outliers_pd1[i] == "8"){outliers_pd1[i] = "Site 16"}
  if(outliers_pd1[i] == "9"){outliers_pd1[i] = "Site 17"}
  if(outliers_pd1[i] == "10"){outliers_pd1[i] = "Site 19"}
  if(outliers_pd1[i] == "11"){outliers_pd1[i] = "Site 20"}
  if(outliers_pd1[i] == "12"){outliers_pd1[i] = "Site 21"}
  if(outliers_pd1[i] == "13"){outliers_pd1[i] = "Site 22"}
  if(outliers_pd1[i] == "14"){outliers_pd1[i] = "Site 24"}
  if(outliers_pd1[i] == "15"){outliers_pd1[i] = "Site 25"}
  if(outliers_pd1[i] == "16"){outliers_pd1[i] = "Site 28"}
  if(outliers_pd1[i] == "17"){outliers_pd1[i] = "Site 29"}
  if(outliers_pd1[i] == "18"){outliers_pd1[i] = "Site 31"}
  if(outliers_pd1[i] == "19"){outliers_pd1[i] = "Site 32"}
}

for(i in 1:length(outliers_pd2)){
  if(outliers_pd2[i] == "1"){outliers_pd2[i] = "Site 2"}
  if(outliers_pd2[i] == "2"){outliers_pd2[i] = "Site 5"}
  if(outliers_pd2[i] == "3"){outliers_pd2[i] = "Site 7"}
  if(outliers_pd2[i] == "4"){outliers_pd2[i] = "Site 10"}
  if(outliers_pd2[i] == "5"){outliers_pd2[i] = "Site 11"}
  if(outliers_pd2[i] == "6"){outliers_pd2[i] = "Site 12"}
  if(outliers_pd2[i] == "7"){outliers_pd2[i] = "Site 13"}
  if(outliers_pd2[i] == "8"){outliers_pd2[i] = "Site 16"}
  if(outliers_pd2[i] == "9"){outliers_pd2[i] = "Site 17"}
  if(outliers_pd2[i] == "10"){outliers_pd2[i] = "Site 19"}
  if(outliers_pd2[i] == "11"){outliers_pd2[i] = "Site 20"}
  if(outliers_pd2[i] == "12"){outliers_pd2[i] = "Site 21"}
  if(outliers_pd2[i] == "13"){outliers_pd2[i] = "Site 22"}
  if(outliers_pd2[i] == "14"){outliers_pd2[i] = "Site 24"}
  if(outliers_pd2[i] == "15"){outliers_pd2[i] = "Site 25"}
  if(outliers_pd2[i] == "16"){outliers_pd2[i] = "Site 28"}
  if(outliers_pd2[i] == "17"){outliers_pd2[i] = "Site 29"}
  if(outliers_pd2[i] == "18"){outliers_pd2[i] = "Site 31"}
  if(outliers_pd2[i] == "19"){outliers_pd2[i] = "Site 32"}
}

if(length(outliers_pd1) == length(pd1$variable)){
  pd1['Outliers'] <- outliers_pd1
}
if(length(outliers_pd2) == length(pd2$variable)){
  pd2['Outliers'] <- outliers_pd2
}


Element_Boxplot_1 <- ggplot(pd1,aes(value, variable,fill = variable)) +
  geom_boxplot() +
  guides(fill="none") +
  ylab("") +
  xlab("Contamination Factor") + coord_flip() +
  geom_text(aes(label = pd1$Outliers), na.rm = TRUE, hjust = -0.3, cex=2) +
  ggtitle("Boxplot of Analyzed Elements 1 of 2")

Element_Boxplot_2 <- ggplot(pd2,aes(value, variable,fill = variable)) +
  geom_boxplot() +
  guides(fill="none") +
  ylab("") +
  xlab("Contamination Factor") + coord_flip() +
  geom_text(aes(label = pd2$Outliers), na.rm = TRUE, hjust = -0.3, cex=2) +
  ggtitle("Boxplot of Analyzed Elements 2 of 2")

ggsave("~Save Path/Element_Boxplot_1.tiff", Element_Boxplot_1,  dpi=300, units = "cm")
ggsave("~Save Path/Element_Boxplot_2.tiff", Element_Boxplot_2,  dpi=300, units = "cm")

#Table of outliers and percentages
#21/47 elements Site 11 is an outlier (44.7%)
total_outliers = plyr::count(c(outliers_pd1,outliers_pd2))
total_o = c()
for(i in 2:length(total_outliers$freq)){
  temp = sprintf("%s%%",100*round(total_outliers$freq[i]*19/sum(total_outliers$freq),2))
  total_o = c(total_o,temp)
}
total_outliers['Percent'] = c('',total_o)

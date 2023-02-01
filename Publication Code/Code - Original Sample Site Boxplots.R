#Boxplots of original data set
#Script is dependent on packages: ggplot2, readxl
library(ggplot2)
library(tidyr)

#Import Data
path = "File Path to Publication_Data.xlsx"
Org_data <- readxl::read_excel(path, sheet = "Original Data")

sites= c('1','2','2','2','5','6','7','7','7','10',
         '11','12','13','13','13','16','17','18','19','20',
         '21','22','22','24','25','25','25','28','29','29',
         '31','32','33')

level_o = c('1','2','5','6','7','10','11','12','13','16','17','18','19',
            '20','21','22','24','25','28','29','31','32','33')

sites_l <- factor(sites,level_o)

#Set element you want to examine; change in Line 16 as well
element_choice = "Ag"

ggplot(Org_data,aes(as.double(Ag),sites_l)) +
  geom_boxplot() + coord_flip() +
  geom_jitter(aes(colour = sites_l)) +
  geom_text(aes(label = as.character(`Site`)), na.rm = TRUE, hjust = -0.05, cex=4) +
  guides(fill="none",colour="none") +
  ylab("Site Locations") +
  xlab(sprintf("%s Concentration (mg/kg)", element_choice)) +
  ggtitle(sprintf("%s: Boxplot of all sample locations and grouped samples", element_choice))


#Boxplot based on Region 
region = c('1','Grave Lake Area','Grave Lake Area','Grave Lake Area','Grave Lake Area',
           '6','Grave Lake Area','Grave Lake Area','Grave Lake Area','Grave Lake Area',
           '11','West of Sparwood','West of Sparwood','West of Sparwood',
           'West of Sparwood','West of Sparwood','West of Sparwood',
           '18','South of Elkview','Alexander Creek',
           'Alexander Creek','Alexander Creek','Alexander Creek','Alexander Creek',
           'South of Elkview','South of Elkview','South of Elkview','South of Elkview',
           'South of Elkview','South of Elkview','South of Elkview',
           'Crowsnest','Fernie')

Box_Conc_Input <- data.frame(as.double(Org_data$V), region, sites) %>% na.omit()
colnames(Box_Conc_Input) <- c('Element','Region','Site')
element_choice = "V"
ggplot(Box_Conc_Input,aes(Box_Conc_Input$Element,Box_Conc_Input$Region)) +
  geom_boxplot() + coord_flip() +
  geom_jitter(aes(colour = Box_Conc_Input$Region)) +
  geom_text(aes(label = as.character(`Site`)), na.rm = TRUE, hjust = -0.05, cex=4) +
  guides(fill="none",colour="none") +
  ylab("Site Locations") +
  xlab(sprintf("%s Concentration (mg/kg)", element_choice)) +
  ggtitle(sprintf("%s: Boxplot of all sample locations and grouped samples", element_choice))




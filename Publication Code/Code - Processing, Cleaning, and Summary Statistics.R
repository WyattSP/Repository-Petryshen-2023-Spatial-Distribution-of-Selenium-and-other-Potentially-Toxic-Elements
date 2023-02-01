#Data Processing, Cleaning, and Summary Statistics
#Summary Statistics
#Script is dependent on packages: moments, readr, readxl, dplyr
library(moments)
library(readr)
library(dplyr)

#Import Excel Spreadsheet
path = "File Path to Publication_Data.xlsx"
Org_data <- readxl::read_excel(path, sheet = "Original Data")

#Sites with multiple samples - will be combined into composite samples
Comp_samples <- list(c(2,3,4),c(7,8,9),c(13,14,15),c(22,23),c(25,26,27),c(29,30))

#Collects rows with duplicate samples into a single list
store_comp <- list()
for (i in seq_along(Comp_samples)){
  temp <- c()
  for (n in seq_along(Comp_samples[[i]])){
    temp <- rbind(temp,Org_data[Org_data$Site == Comp_samples[[i]][n],])
  }
  store_comp <- append(store_comp,list(temp))
}

#Calculate and store summary data
elements <- names(Org_data)[21:73] #Should be 53 elements
row_names <- c('min','max','var','median','mean','SD','CV','Skewness','Kurtosis')

#Calculation of summary statistics for composite samples
summary_comp <- list()
for (j in store_comp){
  temp <- data.frame(matrix(ncol=length(elements), nrow = length(row_names)))
  colnames(temp) <- elements
  rownames(temp) <- row_names

  n = 0
  for (i in j[21:73]){
    n = n + 1
    vec = as.double(i)

    temp[1,n] <- min(vec)
    temp[2,n] <- max(vec)
    temp[3,n] <- var(vec)
    temp[4,n] <- median(vec)
    temp[5,n] <- mean(vec)
    temp[6,n] <- sd(vec)
    temp[7,n] <- sd(vec)/mean(vec)
    temp[8,n] <- skewness(vec)
    temp[9,n] <- kurtosis(vec)

  }
  summary_comp <- append(summary_comp,list(temp))
}

#Remove Rows with Na values from original data
#These could be deleted within the excel spreadsheet prior to import as well
trimmed_data <- Org_data[-c(1,6,18),]

#Remove rows that had composite samples
duplicate_to_remove = c(3,4,8,9,14,15,23,26,27,30)

for (i in duplicate_to_remove){
  k = which(trimmed_data$Site == i)
  trimmed_data = trimmed_data[-c(k),]
}

#Store Site Information
Site_Info = trimmed_data[,1:20]

#Change data in trimmed to double
Numeric_trimmed_moss = sapply(trimmed_data[,21:73], as.numeric)

#Join Site_Info with numeric_trimmed_moss data
#Merge with names
moss_data = cbind(data.frame(Site_Info), data.frame(Numeric_trimmed_moss))

#Replace sites with multiple samples as a average
#Composite samples sites to replace 2, 5, 9, 15, 17, 19

#Append Rows
#Unique Site 2; Replace 2 #Unique Site 5: Replace 7 #Unique Site 9; Replace 13 #Unique Site 15; Replace 22 #Unique Site 17; Replace 25 #Unique Site 19; Replace 29

#Site numbers to replace
replace_site <- c(2,7,13,22,25,29)

#Replace site with composite sample averages
c = 0
for (i in replace_site){
  c = c + 1
  k = which(moss_data$Site == i)
  moss_data[k,21:73] = as.numeric(summary_comp[[c]][5,])
}

#Cleaned Data; This is used as input for:
  #Code - Map Plots.R
  #Code - Contamination Factor.R
write.csv(moss_data, file = "Path to Save to/Cleaned Moss Data.csv", row.names =T)

#At this stage moss_data is ready for further analysis

#Summary statistics on all data, including averaged locations with multiple samples
moss_summary <- data.frame(matrix(ncol=length(elements), nrow = length(row_names)))
colnames(moss_summary) <- elements
rownames(moss_summary) <- row_names

n = 0
for (i in moss_data[21:73]){
  n = n + 1
  vec = as.double(i)

  moss_summary[1,n] <- min(vec)
  moss_summary[2,n] <- max(vec)
  moss_summary[3,n] <- var(vec)
  moss_summary[4,n] <- median(vec)
  moss_summary[5,n] <- mean(vec)
  moss_summary[6,n] <- sd(vec)
  moss_summary[7,n] <- sd(vec)/mean(vec)
  moss_summary[8,n] <- skewness(vec)
  moss_summary[9,n] <- kurtosis(vec)
}

#Insert values from local reference site in Fernie
#Site Number 33; Lat: -115.0601, Lat: 49.52666; Unique Site 22
fernie_refsite <- moss_data[20,21:73]
moss_summary_final <- moss_summary #Copy data into new dataframe
moss_summary_final <- moss_summary_final %>% add_row(fernie_refsite, .before = 3) #Insert new row
row.names(moss_summary_final)[row.names(moss_summary_final) == "...3"] <- "Background Value in Fernie (mg/kg)" #Change name

#Export summary statistics
write.csv(moss_summary_final, file = "Path to Save to/Summary_Statistics.csv", row.names =T)

#With site 11 removed
moss_data_no11 <- moss_data[-c(5),]

moss_summary_no11 <- data.frame(matrix(ncol=length(elements), nrow = length(row_names)))
colnames(moss_summary_no11) <- elements
rownames(moss_summary_no11) <- row_names

n = 0
for (i in moss_data_no11[21:73]){
  n = n + 1
  vec = as.double(i)

  moss_summary_no11[1,n] <- min(vec)
  moss_summary_no11[2,n] <- max(vec)
  moss_summary_no11[3,n] <- var(vec)
  moss_summary_no11[4,n] <- median(vec)
  moss_summary_no11[5,n] <- mean(vec)
  moss_summary_no11[6,n] <- sd(vec)
  moss_summary_no11[7,n] <- sd(vec)/mean(vec)
  moss_summary_no11[8,n] <- skewness(vec)
  moss_summary_no11[9,n] <- kurtosis(vec)
}

#Insert values from local reference site in Fernie
#Site Number 33; Lat: -115.0601, Lat: 49.52666; Unique Site 22
fernie_refsite <- moss_data_no11[19,21:73]
moss_summary_final_no11 <- moss_summary_no11 #Copy data into new dataframe
moss_summary_final_no11 <- moss_summary_final_no11 %>% add_row(fernie_refsite, .before = 3) #Insert new row
row.names(moss_summary_final_no11)[row.names(moss_summary_final_no11) == "...3"] <- "Background Value in Fernie (mg/kg)" #Change name

#Export summary statistics
write.csv(moss_summary_final_no11, file = "Path to Save to/Summary_Statistics_No_11.csv", row.names =T)


#####
#####
#####
#Tests for species differences in elemental compositions
#Line 193 and lower for all elements in a single for loop
#Line 171 to 192 to run individual elements and plot as a boxplot.
#Remove samples with NA's
non_averaged_data <- Org_data[-c(1,6,18),]
#Anova for Species versus Se
res.aov <- aov(Zn ~ non_averaged_data$`Species Tent`, data = non_averaged_data)
summary(res.aov)
plot(res.aov, 1) #Some outliers detected. Using Levene's test to test homogeneity of variances.
car::leveneTest(as.double(non_averaged_data$Se) ~ as.factor(non_averaged_data$`Species Tent`), data = non_averaged_data) #Results is non-significant
plot(res.aov, 2) #Normal Q-Q plot shows data is approximately normal.

#Boxplot for Se versus
element_choice = "Ni"
ggplot(non_averaged_data,aes(as.double(Ni),`Species Tent`)) +
  geom_boxplot() + coord_flip() +
  geom_jitter(aes(colour = non_averaged_data$Cent_Elkview)) +
  geom_text(aes(label = as.character(`Site`)), na.rm = TRUE, hjust = -0.05, cex=4) +
  guides(fill="none") +
  labs(colour="Distance (m)") +
  ylab("Site Locations") +
  xlab(sprintf("%s Concentration (mg/kg)", element_choice)) +
  ggtitle(sprintf("%s: Boxplot of Species versus Concentration", element_choice)) +
  scale_colour_gradient(low = "blue", high = "red")

#Calculate and store summary data
elements <- names(Org_data)[21:73] #Should be 53 elements
row_names_anova <- c('DF','Mean Sq','Sum Sq','F Value','Pr(>F)', 'Levene F Value', 'Levene Pr(>F)')

anova_species <- data.frame(matrix(ncol=length(elements), nrow = length(row_names_anova)))
colnames(anova_species) <- elements
rownames(anova_species) <- row_names_anova

n = 0
for (i in elements){
  n = n + 1
  a = non_averaged_data[i]
  temp = aov(as.numeric(a[[1]]) ~ non_averaged_data$`Species Tent`, data = non_averaged_data)
  levenetemp = car::leveneTest(as.numeric(a[[1]]) ~ as.factor(non_averaged_data$`Species Tent`), data = non_averaged_data)
  b = summary(temp)

  val = b[[1]][["Pr(>F)"]][1]
  val2 = levenetemp$`Pr(>F)`[1]

  anova_species[1,n] <- b[[1]][["Df"]][1]
  anova_species[2,n] <- b[[1]][["Mean Sq"]][1]
  anova_species[3,n] <- b[[1]][["Sum Sq"]][1]
  anova_species[4,n] <- b[[1]][["F value"]][1]
  anova_species[5,n] <- b[[1]][["Pr(>F)"]][1]
  anova_species[6,n] <- levenetemp$`F value`[1]
  anova_species[7,n] <- levenetemp$`Pr(>F)`[1]

  if(val < 0.05){
    print(sprintf("Anove %s", i))
  }
  if(val2 < 0.05){
    print(sprintf("Levene %s", i))
  }
}

#Pairwise t-test for Z
#P<0.05 for Hylocomium splendins to Pleurozium schreberi and Ptilium crista-castrensis.
pairwise.t.test(as.double(non_averaged_data$Zn),non_averaged_data$`Species Tent`)

####
####
####
#Linear models comparing moss elemental concentrations to sample weight collected

#For individual element
lm(non_averaged_data$Ni ~ non_averaged_data$`Wet Mass Pre Analysis (grams)`) %>% summary()

#Plots of concentrations to sample weight
element_choice = "Be"
non_averaged_data %>% as.data.frame %>%
  ggplot(aes(y = as.double(Be),x = `Wet Mass Pre Analysis (grams)`)) +
  geom_point() +
  geom_text(aes(label = as.character(`Site`)), na.rm = TRUE, hjust = -0.05, cex=4) +
  xlab("Sample Weight Collected") +
  ylab(sprintf("%s Concentration (mg/kg)", element_choice)) +
  ggtitle(sprintf("%s: Boxplot of Sample Weight Collected versus Concentration", element_choice)) +
  scale_colour_gradient(low = "blue", high = "red")

#For loop for all elements
row_names_weight <- c('Adjusted R-sq','t value','Pr(>|t|)')

lm_weight <- data.frame(matrix(ncol=length(elements), nrow = length(row_names_weight)))
colnames(lm_weight) <- elements
rownames(lm_weight) <- row_names_weight

n = 0
for (i in elements){
  n = n + 1
  a = non_averaged_data[i]
  temp = lm(as.numeric(a[[1]]) ~ non_averaged_data$`Wet Mass Pre Analysis (grams)`) %>% summary()

  val = temp$coefficients[8]

  lm_weight[1,n] <- temp$adj.r.squared
  lm_weight[2,n] <- temp$coefficients[6]
  lm_weight[3,n] <- temp$coefficients[8]

  if(val < 0.05){
    print(sprintf("Lm %s", i))
  }
}

#Elements with significant t-values; Adj R-sq, t value, Pr reported in brackets
#Be(0.14 2.36 0.03), Bi(0.15 2.51 0.02), Co(0.10 2.08 0.05),
#Cr(0.17 2.64 0.01), Ge(0.15 2.51 0.02), Hf(0.20 2.84 0.01),
#K(0.31 -3.73  0.00), Mg(0.23 -3.11  0.00), Nb(0.15 2.44 0.02),
#Ni(0.12 2.23 0.03), P(0.20 -2.84  0.01), S(0.18 -2.70  0.01),
#Sb(0.26 3.35 0.00), Te(0.12 2.22 0.03), V(0.14 2.40 0.02),
#Zr(0.16 2.57 0.02)

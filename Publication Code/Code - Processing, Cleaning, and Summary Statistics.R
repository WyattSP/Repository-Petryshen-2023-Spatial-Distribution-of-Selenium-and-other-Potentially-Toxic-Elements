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
#Boxplot for Se versus moss species
#Code to create Figure S3
non_averaged_data$`Species Tent`[non_averaged_data$`Species Tent`== "Hylocomium splendins"] <- "Hylocomium splendens" #Correction of spelling error
element_choice = "Se"
Species_plot = ggplot(non_averaged_data,aes(as.double(Se),`Species Tent`)) +
  geom_boxplot() + coord_flip() +
  geom_jitter(aes(colour = non_averaged_data$Cent_Elkview)) +
  geom_text(aes(label = as.character(`Site`)), na.rm = TRUE, hjust = -0.05, cex=4) +
  guides(fill="none") +
  labs(colour="Distance (m)") +
  ylab("") +
  xlab(sprintf("%s Concentration (mg/kg dw)", element_choice)) +
  ggtitle(sprintf("%s: Boxplot of concentration versus species", element_choice)) +
  scale_colour_gradient(low = "blue", high = "red")


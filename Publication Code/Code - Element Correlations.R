library("dplry")
library("ggpubr")

#Data import if not already done from before
path = "File Path to Publication_Data.xlsx" #Alternatively, CF_data from previous 'Code - Contamination Factor.R' is the same
CF_data <- read_excel(path, sheet = "Contamination Factor Data")

#Data with site 11 removed
corr_data <- CF_data[-c(5),21:73]

#Convert all rows to numeric and remove columns with NA values
corr_data <- mutate_all(corr_data, function(x) as.numeric(as.character(x)))
corr_data = corr_data[ , colSums(is.na(corr_data)) == 0]

x = apply(corr_data,2,function(x) cor.test(corr_data$Se, x,  method="pearson"))

row_names_corr = c("t", "p.value", 'cor')
corr_results <- data.frame(matrix(ncol=length(corr_data), nrow = length(row_names_corr)))
colnames(corr_results) <- names(corr_data)
rownames(corr_results) <- row_names_corr

count = 0
for(i in x){
  count = count + 1
  corr_results['t',count] = i[["statistic"]][["t"]]
  corr_results['p.value',count] =i[["p.value"]]
  corr_results['cor',count] =i[["estimate"]][["cor"]]
}

#Plot
#To view different elemnts change y
ggscatter(corr_data, x = "Se", y = "Ni",
          add = "reg.line", conf.int = TRUE,
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Se", ylab = "Ni")

#Pearson Correlation Charts
#Ag, Ge, Ni, U, V, and Zr
Ag_corr <- ggscatter(data_gam, x = "Se", y = "Ag",
          color = "black", size = 2,
          add = "reg.line",
          add.params = list(color = "black", fill = "lightgray"),
          conf.int = TRUE, cor.coef = TRUE,
          cor.method = "pearson",
          xlab = "Se", ylab = "Ag",
          label = new_labels,
          font.label = c(16, "plain", "black"), repel = TRUE)

Ge_corr <-ggscatter(data_gam, x = "Se", y = "Ge",
          color = "black", size = 2,
          add = "reg.line",
          add.params = list(color = "black", fill = "lightgray"),
          conf.int = TRUE, cor.coef = TRUE,
          cor.method = "pearson",
          xlab = "Se", ylab = "Ge",
          label = new_labels,
          font.label = c(16, "plain", "black"), repel = TRUE)

Ni_corr <- ggscatter(data_gam, x = "Se", y = "Ni",
          color = "black", size = 2,
          add = "reg.line",
          add.params = list(color = "black", fill = "lightgray"),
          conf.int = TRUE, cor.coef = TRUE,
          cor.method = "pearson",
          xlab = "Se", ylab = "Ni",
          label = new_labels,
          font.label = c(16, "plain", "black"), repel = TRUE)

U_corr <- ggscatter(data_gam, x = "Se", y = "U",
          color = "black", size = 2,
          add = "reg.line",
          add.params = list(color = "black", fill = "lightgray"),
          conf.int = TRUE, cor.coef = TRUE,
          cor.method = "pearson",
          xlab = "Se", ylab = "U",
          label = new_labels,
          font.label = c(16, "plain", "black"), repel = TRUE)

V_corr <- ggscatter(data_gam, x = "Se", y = "V",
          color = "black", size = 2,
          add = "reg.line",
          add.params = list(color = "black", fill = "lightgray"),
          conf.int = TRUE, cor.coef = TRUE,
          cor.method = "pearson",
          xlab = "Se", ylab = "V",
          label = new_labels,
          font.label = c(16, "plain", "black"), repel = TRUE)

Zr_corr <- ggscatter(data_gam, x = "Se", y = "Zr",
          color = "black", size = 2,
          add = "reg.line",
          add.params = list(color = "black", fill = "lightgray"),
          conf.int = TRUE, cor.coef = TRUE,
          cor.method = "pearson",
          xlab = "Se", ylab = "Zr",
          label = new_labels,
          font.label = c(16, "plain", "black"), repel = TRUE)

corr_facet_plot = ggarrange(Ag_corr, Ge_corr,
                            Ni_corr, U_corr,
                            V_corr,Zr_corr,
                     labels = c("a)", "b)", "c)", "d)", "e)", "f)"),
                     ncol = 2, nrow = 3)

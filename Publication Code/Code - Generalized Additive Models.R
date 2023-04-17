#Generalized Additive Model
#Script is dependent on packages: mgcv, ggplot2
library(mgcv)
library(ggplot2)

#Data import if not already done from before
path = "File Path to Publication_Data.xlsx" #Alternatively, CF_data from previous 'Code - Contamination Factor.R' is the same
CF_data <- read_excel(path, sheet = "Contamination Factor Data")

#Data with site 11 removed
data_gam <- CF_data[-c(5),]

#Generalized Additive Models for Distance from Centroids and Azimuth to Sample Sites from Mine Centroid
#Elkview Mine: log(Se) CFs dependent on Azimuth and Distance
model_E = gam(data_gam$Se ~  s(as.double(data_gam$Cent_Elkview)) +
                 s(as.double(data_gam$Elkview_Azimuth), bs = 'cc'), method = "REML",family = tw(link = "identity"))
plot_model_E = plot.gam(model_E,pages=1,residuals = FALSE)
par(mfrow=c(2,2), oma=c(0,0,2,0)) #Plot all diagnostic figures in a single window
gam.check(model_E)
summary(model_E)

#Line Creek Mine: log(Se) CFs dependent on Azimuth and Distance
model_L = gam(data_gam$Se ~  s(as.double(data_gam$Cent_Line_Creek)) +
                 s(as.double(data_gam$LineCreek_Azimuth)), method = "REML",family = tw(link = "identity"))
plot_model_L = plot.gam(model_L,pages=1,residuals = FALSE)
par(mfrow=c(2,2), oma=c(0,0,2,0)) #Plot all diagnostic figures in a single window
gam.check(model_L)
summary(model_L)

#AIC
AIC(model_E, model_L) #Model_L has a lower AIC so thus better explains our data

#Summary plots for individual models
#Change the element of interest in the below equation from the data.gam data frame
#Plot title needs to be changed on last plotting line

#If viewing plots withing R studio Plots viewer, press the zoom key for full screen. Otherwise plot components overlap.
#Summary plots for Elkview GAM
par(mfrow=c(2,2), oma=c(0,0,2,0))
plot.gam(model_E)
qq.gam(model_E,pch = 1)
plot(x = 0:1, y = 0:1, ann = F, bty = "n", type = "n", xaxt = "n", yaxt = "n") +
  text(x = 0.1, y = 1,  sprintf('Family: %s, Link: %s',summary(model_E)$family[1],summary(model_E)$family[2]), cex = 0.9, pos = 4) +
  text(x = 0.1, y = 0.95, 'Element ~ s(Cent_Elkview) + s(Elkview_Azimuth)', cex = 0.9, pos = 4) +
  text(x = 0.1, y = 0.85, sprintf('Deviance explained: %s%%', 100*round(summary(model_E)$dev.expl, 3)), cex = 0.9, pos = 4) +
  text(x = 0.1, y = 0.80, sprintf('R-squared: %s', round(summary(model_E)$r.sq, 3)), cex = 0.9, pos = 4) +
  text(x = 0.1, y = 0.70,
       sprintf('s(Cent_Elkview): edf = %s, Ref.df = %s, F = %s, p-value = %s',
               round(summary(model_E)$s.table[1], 3), round(summary(model_E)$s.table[3], 3),  round(summary(model_E)$s.table[5], 3),  round(summary(model_E)$s.table[7], 3)), cex = 0.9, pos = 4) +
  text(x = 0.1, y = 0.65,
       sprintf('s(Elkview_Azimuth): edf = %s, Ref.df = %s, F = %s, p-value = %s',
               round(summary(model_E)$s.table[2], 3), round(summary(model_E)$s.table[4], 3),  round(summary(model_E)$s.table[6], 3),  round(summary(model_E)$s.table[8], 3)), cex = 0.9, pos = 4) +
  text(x = 0.1, y = 0.55, sprintf('REML: %s', round(summary(model_E)$sp.criterion[1], 3)), cex = 0.9, pos = 4)
mtext("Se", line=-2, side=3, outer=TRUE, cex=2) #Need to change title for element of model
#End Plot

#Summary plots for Line Creek GAM
par(mfrow=c(2,2), oma=c(0,0,2,0))
plot.gam(model_L)
qq.gam(model_L,pch = 1)
plot(x = 0:1, y = 0:1, ann = F, bty = "n", type = "n", xaxt = "n", yaxt = "n") +
  text(x = 0.1, y = 1,  sprintf('Family: %s, Link: %s',summary(model_L)$family[1],summary(model_L)$family[2]), cex = 0.9, pos = 4) +
  text(x = 0.1, y = 0.95, 'Element ~ s(Cent_LineCreek) + s(LineCreek_Azimuth)', cex = 0.9, pos = 4) +
  text(x = 0.1, y = 0.85, sprintf('Deviance explained: %s%%', 100*round(summary(model_L)$dev.expl, 3)), cex = 0.9, pos = 4) +
  text(x = 0.1, y = 0.80, sprintf('R-squared: %s', round(summary(model_L)$r.sq, 3)), cex = 0.9, pos = 4) +
  text(x = 0.1, y = 0.70,
       sprintf('s(Cent_LineCreek): edf = %s, Ref.df = %s, F = %s, p-value = %s',
               round(summary(model_L)$s.table[1], 3), round(summary(model_L)$s.table[3], 3),  round(summary(model_L)$s.table[5], 3),  round(summary(model_L)$s.table[7], 3)), cex = 0.9, pos = 4) +
  text(x = 0.1, y = 0.65,
       sprintf('s(LineCreek_Azimuth): edf = %s, Ref.df = %s, F = %s, p-value = %s',
               round(summary(model_L)$s.table[2], 3), round(summary(model_L)$s.table[4], 3),  round(summary(model_L)$s.table[6], 3),  round(summary(model_L)$s.table[8], 3)), cex = 0.9, pos = 4) +
  text(x = 0.1, y = 0.55, sprintf('REML: %s', round(summary(model_L)$sp.criterion[1], 3)), cex = 0.9, pos = 4)
mtext("Se", line=-2, side=3, outer=TRUE, cex=2) #Need to change title for element of model
#End Plot

#Smoothing Parameter Plots
#Elview GAM Distance Smoothing Parameter
plot_model_E_Dist <- plot_model_E[[1]]
sm_df <- as.data.frame(plot_model_E_Dist[c("x", "se", "fit")])
data_df <- as.data.frame(plot_model_E_Dist[c("raw")])

E_plot_d = ggplot(sm_df, aes(x = x, y = fit)) +
  geom_rug(data = data_df, mapping = aes(x = raw, y = NULL),
           sides = "b") +
  geom_ribbon(data=sm_df,aes(ymin = fit - se, ymax = fit + se, y = NULL),
              alpha = 0.1, linetype = 2, fill = 'white', color = 'black') +
  geom_line() +
  labs(x = plot_model_E$xlab, y = plot_model_E$ylab) +
  ylab("s(Distance, 1.24)") + xlab("Distance") + theme(aspect.ratio=3/4,
                                                       panel.background = element_rect(fill = "white", colour = "grey50"))

#Elview GAM Azimuth Smoothing Parameter
plot_model_E_Azi <- plot_model_E[[2]]
sm_df <- as.data.frame(plot_model_E_Azi[c("x", "se", "fit")])
data_df <- as.data.frame(plot_model_E_Azi[c("raw")])

E_plot_a = ggplot(sm_df, aes(x = x, y = fit)) +
  geom_rug(data = data_df, mapping = aes(x = raw, y = NULL),
           sides = "b") +
  geom_ribbon(data=sm_df,aes(ymin = fit - se, ymax = fit + se, y = NULL),
              alpha = 0.1, linetype = 2, fill = 'white', color = 'black') +
  geom_line() +
  labs(x = plot_model_E$xlab, y = plot_model_E$ylab) +
  ylab("s(Distance, 3.22)") + xlab("Azimuth") + theme(aspect.ratio=3/4,
                                                      panel.background = element_rect(fill = "white", colour = "grey50"))

#Line Creek GAM Distance Smoothing Parameter
plot_model_L_Dist <- plot_model_L[[1]]
sm_df <- as.data.frame(plot_model_L_Dist[c("x", "se", "fit")])
data_df <- as.data.frame(plot_model_L_Dist[c("raw")])

L_plot_d =  ggplot(sm_df, aes(x = x, y = fit)) +
  geom_rug(data = data_df, mapping = aes(x = raw, y = NULL),
           sides = "b") +
  geom_ribbon(data=sm_df,aes(ymin = fit - se, ymax = fit + se, y = NULL),
              alpha = 0.1, linetype = 2, fill = 'white', color = 'black') +
  geom_line() +
  labs(x = plot_model_L$xlab, y = plot_model_L$ylab) +
  ylab("s(Distance, 3.86)") + xlab("Distance") + theme(aspect.ratio=3/4,
                                                       panel.background = element_rect(fill = "white", colour = "grey50"))

#Line Creek GAM Azimuth Smoothing Parameter
plot_model_L_Azi <- plot_model_L[[2]]
sm_df <- as.data.frame(plot_model_L_Azi[c("x", "se", "fit")])
data_df <- as.data.frame(plot_model_L_Azi[c("raw")])

L_plot_a =  ggplot(sm_df, aes(x = x, y = fit)) +
  geom_rug(data = data_df, mapping = aes(x = raw, y = NULL),
           sides = "b") +
  geom_ribbon(data=sm_df,aes(ymin = fit - se, ymax = fit + se, y = NULL),
              alpha = 0.1, linetype = 2, fill = 'white', color = 'black') +
  geom_line() +
  labs(x = plot_model_L$xlab, y = plot_model_L$ylab) +
  ylab("s(Distance, 4.02)") + xlab("Azimiuth") + theme(aspect.ratio=3/4,
                                                       panel.background = element_rect(fill = "white", colour = "grey50"))

#Facet plot of all smoothing parameters from the GAMs
library('ggpubr')
ggarrange(E_plot_d, E_plot_a,
          L_plot_d, L_plot_a,
          labels = c("a)", "b)", "c)", "d)"),
          ncol = 2, nrow = 2)


###Linear Regression Models contained within the Supporting Information
#Linear Model 1: Alexander Creek Drainage Se Contamination in relation to Line Creek Distance
#Input Data
in_linear <- data_gam[c(10,11,12,13,14,16),c("Site","Cent_Line_Creek","Cent_Elkview","Se")]
#Model
lm(in_linear$Se ~ in_linear$Cent_Line_Creek) %>% summary()

#Plot of Linear Model 1
LM_1_Plot = in_linear %>% as.data.frame %>%
  ggplot(aes(Se,as.double(Cent_Line_Creek))) +
  geom_point() + geom_smooth(method = 'lm') +
  scale_x_reverse() +
  scale_x_reverse() + labs(x = "Se CFs", y = "Distance from Line Creek Mine (m)") +
  annotate("text", x = 5.904255, y = 16488.27, label = "10",hjust=0,vjust=-0.2) + annotate("text", x = 4.095745, y = 18934.04, label = "11",hjust=0,vjust=-0.2) +
  annotate("text", x = 4.734043, y = 21103.77, label = "12",hjust=0,vjust=-0.2) + annotate("text", x = 2.170213, y = 26502.98, label = "13",hjust=0,vjust=-0.2) +
  annotate("text", x = 1.329787, y = 34050.03, label = "14",hjust=0,vjust=-0.2) + annotate("text", x = 1.531915, y = 33971.95, label = "16",hjust=0,vjust=-0.2)

#Linear Model 2: Alexander Creek Drainage Se Contamination in relation to Elkview Distance
lm(in_linear$Se ~ in_linear$Cent_Elkview) %>% summary()

#Plot of Linear Model 2
LM_2_Plot = in_linear %>% as.data.frame %>%
  ggplot(aes(Se,as.double(Cent_Elkview))) +
  geom_point() + geom_smooth(method = 'lm') +
  scale_x_reverse() +
  scale_x_reverse() + labs(x = "Se CFs", y = "Distance from Elkview Mine (m)") +
  annotate("text", x = 5.904255, y = 10760.553, label = "10",hjust=0,vjust=-0.2) + annotate("text", x = 4.095745, y = 9158.146, label = "11",hjust=0,vjust=-0.2) +
  annotate("text", x = 4.734043, y = 7566.238, label = "12",hjust=0,vjust=-0.2) + annotate("text", x = 2.170213, y = 8747.102, label = "13",hjust=0,vjust=-0.2) +
  annotate("text", x = 1.329787, y = 12711.132, label = "14",hjust=0,vjust=-0.2) + annotate("text", x = 1.531915, y = 13696.933, label = "16",hjust=0,vjust=-0.2)

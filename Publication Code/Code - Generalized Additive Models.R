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
model_E = gam(log(data_gam$Se) ~  s(as.double(data_gam$Cent_Elkview)) +
                 s(as.double(data_gam$Elkview_Azimuth), bs = 'cc'), method = "REML",family = tw(link = "log"))
plot_model_E = plot.gam(model_E,pages=1,residuals = TRUE)
par(mfrow=c(2,2), oma=c(0,0,2,0)) #Plot all diagnositic figures in a single window
gam.check(model_E)
summary(model_E)

#Line Creek Mine: log(Se) CFs dependent on Azimuth and Distance
model_L = gam(log(data_gam$Se) ~  s(as.double(data_gam$Cent_Line_Creek)) +
                 s(as.double(data_gam$LineCreek_Azimuth), bs = 'cc'), method = "REML",family = tw(link = "log"))
plot_model_L = plot.gam(model_L,pages=1,residuals = TRUE)
par(mfrow=c(2,2), oma=c(0,0,2,0)) #Plot all diagnositic figures in a single window
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
data_df <- as.data.frame(plot_model_E_Dist[c("raw", "p.resid")])

E_plot_d = ggplot(sm_df, aes(x = x, y = fit)) +
  geom_rug(data = data_df, mapping = aes(x = raw, y = NULL),
           sides = "b") +
  geom_point(data = data_df, mapping = aes(x = raw, y = p.resid)) +
  geom_ribbon(data=sm_df,aes(ymin = fit - se, ymax = fit + se, y = NULL),
              alpha = 0.1, linetype = 2, fill = 'white', color = 'black') +
  geom_line() +
  labs(x = plot_model_E$xlab, y = plot_model_E$ylab) +
  annotate("text", x = data_df$raw[1], y = data_df$p.resid[1], label = "1",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[2], y = data_df$p.resid[2], label = "2",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[3], y = data_df$p.resid[3], label = "3",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[4], y = data_df$p.resid[4], label = "4",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[5], y = data_df$p.resid[5], label = "5",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[6], y = data_df$p.resid[6], label = "6",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[7], y = data_df$p.resid[7], label = "7",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[8], y = data_df$p.resid[8], label = "8",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[9], y = data_df$p.resid[9], label = "9",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[10], y = data_df$p.resid[10], label = "10",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[11], y = data_df$p.resid[11], label = "11",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[12], y = data_df$p.resid[12], label = "12",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[13], y = data_df$p.resid[13], label = "13",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[14], y = data_df$p.resid[14], label = "14",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[15], y = data_df$p.resid[15], label = "15",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[16], y = data_df$p.resid[16], label = "16",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[17], y = data_df$p.resid[17], label = "17",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[18], y = data_df$p.resid[18], label = "18",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[19], y = data_df$p.resid[19], label = "19",vjust=-0.5,hjust=0.2) +
  ylab("s(Distance, 1.50)") + xlab("Distance") + theme(aspect.ratio=3/4,
                                                       panel.background = element_rect(fill = "white", colour = "grey50"))

#Elview GAM Azimuth Smoothing Parameter
plot_model_E_Azi <- plot_model_E[[2]]
sm_df <- as.data.frame(plot_model_E_Azi[c("x", "se", "fit")])
data_df <- as.data.frame(plot_model_E_Azi[c("raw", "p.resid")])

E_plot_a = ggplot(sm_df, aes(x = x, y = fit)) +
  geom_rug(data = data_df, mapping = aes(x = raw, y = NULL),
           sides = "b") +
  geom_point(data = data_df, mapping = aes(x = raw, y = p.resid)) +
  geom_ribbon(data=sm_df,aes(ymin = fit - se, ymax = fit + se, y = NULL),
              alpha = 0.1, linetype = 2, fill = 'white', color = 'black') +
  geom_line() +
  labs(x = plot_model_E$xlab, y = plot_model_E$ylab) +
  annotate("text", x = data_df$raw[1], y = data_df$p.resid[1], label = "1",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[2], y = data_df$p.resid[2], label = "2",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[3], y = data_df$p.resid[3], label = "3",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[4], y = data_df$p.resid[4], label = "4",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[5], y = data_df$p.resid[5], label = "5",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[6], y = data_df$p.resid[6], label = "6",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[7], y = data_df$p.resid[7], label = "7",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[8], y = data_df$p.resid[8], label = "8",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[9], y = data_df$p.resid[9], label = "9",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[10], y = data_df$p.resid[10], label = "10",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[11], y = data_df$p.resid[11], label = "11",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[12], y = data_df$p.resid[12], label = "12",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[13], y = data_df$p.resid[13], label = "13",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[14], y = data_df$p.resid[14], label = "14",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[15], y = data_df$p.resid[15], label = "15",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[16], y = data_df$p.resid[16], label = "16",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[17], y = data_df$p.resid[17], label = "17",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[18], y = data_df$p.resid[18], label = "18",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[19], y = data_df$p.resid[19], label = "19",vjust=-0.5,hjust=0.2) +
  ylab("s(Distance, 3.23)") + xlab("Azimuth") + theme(aspect.ratio=3/4,
                                                       panel.background = element_rect(fill = "white", colour = "grey50"))

#Line Creek GAM Distance Smoothing Parameter
plot_model_L_Dist <- plot_model_L[[1]]
sm_df <- as.data.frame(plot_model_L_Dist[c("x", "se", "fit")])
data_df <- as.data.frame(plot_model_L_Dist[c("raw", "p.resid")])

L_plot_d =  ggplot(sm_df, aes(x = x, y = fit)) +
  geom_rug(data = data_df, mapping = aes(x = raw, y = NULL),
           sides = "b") +
  geom_point(data = data_df, mapping = aes(x = raw, y = p.resid)) +
  geom_ribbon(data=sm_df,aes(ymin = fit - se, ymax = fit + se, y = NULL),
              alpha = 0.1, linetype = 2, fill = 'white', color = 'black') +
  geom_line() +
  labs(x = plot_model_L$xlab, y = plot_model_L$ylab) +
  annotate("text", x = data_df$raw[1], y = data_df$p.resid[1], label = "1",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[2], y = data_df$p.resid[2], label = "2",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[3], y = data_df$p.resid[3], label = "3",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[4], y = data_df$p.resid[4], label = "4",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[5], y = data_df$p.resid[5], label = "5",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[6], y = data_df$p.resid[6], label = "6",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[7], y = data_df$p.resid[7], label = "7",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[8], y = data_df$p.resid[8], label = "8",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[9], y = data_df$p.resid[9], label = "9",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[10], y = data_df$p.resid[10], label = "10",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[11], y = data_df$p.resid[11], label = "11",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[12], y = data_df$p.resid[12], label = "12",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[13], y = data_df$p.resid[13], label = "13",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[14], y = data_df$p.resid[14], label = "14",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[15], y = data_df$p.resid[15], label = "15",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[16], y = data_df$p.resid[16], label = "16",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[17], y = data_df$p.resid[17], label = "17",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[18], y = data_df$p.resid[18], label = "18",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[19], y = data_df$p.resid[19], label = "19",vjust=-0.5,hjust=0.2) +
  ylab("s(Distance, 3.00)") + xlab("Distance") + theme(aspect.ratio=3/4,
                                                       panel.background = element_rect(fill = "white", colour = "grey50"))

#Line Creek GAM Azimuth Smoothing Parameter
plot_model_L_Azi <- plot_model_L[[2]]
sm_df <- as.data.frame(plot_model_L_Azi[c("x", "se", "fit")])
data_df <- as.data.frame(plot_model_L_Azi[c("raw", "p.resid")])

L_plot_a =  ggplot(sm_df, aes(x = x, y = fit)) +
  geom_rug(data = data_df, mapping = aes(x = raw, y = NULL),
           sides = "b") +
  geom_point(data = data_df, mapping = aes(x = raw, y = p.resid)) +
  geom_ribbon(data=sm_df,aes(ymin = fit - se, ymax = fit + se, y = NULL),
              alpha = 0.1, linetype = 2, fill = 'white', color = 'black') +
  geom_line() +
  labs(x = plot_model_L$xlab, y = plot_model_L$ylab) +
  annotate("text", x = data_df$raw[1], y = data_df$p.resid[1], label = "1",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[2], y = data_df$p.resid[2], label = "2",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[3], y = data_df$p.resid[3], label = "3",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[4], y = data_df$p.resid[4], label = "4",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[5], y = data_df$p.resid[5], label = "5",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[6], y = data_df$p.resid[6], label = "6",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[7], y = data_df$p.resid[7], label = "7",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[8], y = data_df$p.resid[8], label = "8",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[9], y = data_df$p.resid[9], label = "9",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[10], y = data_df$p.resid[10], label = "10",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[11], y = data_df$p.resid[11], label = "11",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[12], y = data_df$p.resid[12], label = "12",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[13], y = data_df$p.resid[13], label = "13",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[14], y = data_df$p.resid[14], label = "14",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[15], y = data_df$p.resid[15], label = "15",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[16], y = data_df$p.resid[16], label = "16",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[17], y = data_df$p.resid[17], label = "17",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[18], y = data_df$p.resid[18], label = "18",vjust=-0.5,hjust=0.2) +
  annotate("text", x = data_df$raw[19], y = data_df$p.resid[19], label = "19",vjust=-0.5,hjust=0.2) +
  ylab("s(Distance, 3.35)") + xlab("Azimiuth") + theme(aspect.ratio=3/4,
                                                       panel.background = element_rect(fill = "white", colour = "grey50"))

#Facet plot of all smoothing parameters from the GAMs
ggarrange(E_plot_d, E_plot_a,
          L_plot_d, L_plot_a,
          labels = c("a)", "b)", "c)", "d)"),
          ncol = 2, nrow = 2)

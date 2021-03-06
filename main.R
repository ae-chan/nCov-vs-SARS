library(gdata)
library(ggplot2)
library(ggthemes)
setwd('Google Drive/Projects/nCov-vs-SARS')
nCov <- read.csv('data/nCov-deaths.csv')
SARS <- read.xls('data/sars_final.xlsx')

#nCov cleaning
nCov <- nCov[,-c(1,3,4)]
nCov <- nCov[nCov$Country.Region == "Mainland China",]
nCov <- nCov[,-c(1)]
nCov[is.na(nCov)] <- 0

#nCov 
nCov <- colSums(nCov)
nCov <- as.data.frame(nCov)
nCov <- cbind(rownames(nCov), nCov)
nCov[,1] <- as.Date(nCov[,1],c("X%m.%d"))
nCov <- aggregate(nCov[,2], by=list(nCov[,1]), data=nCov, FUN=mean)
names(nCov) <- c("t", "COVID19.Mortality")
nCov <- nCov[-c(1:3), ]
nCov$COVID19.Mortality <- ceiling(nCov$COVID19.Mortality)
rownames(nCov) <- c()

#SARS cleaning
SARS <- SARS[,-c(2,3,5)]
names(SARS) <- c("t", "SARS.Mortality")

#merge
diff <- nrow(SARS) - nrow(nCov)
nCov[nrow(nCov) + diff,] <- NA
nCov$t <- seq(0, length(nCov$t) - 1)
data <- cbind(nCov, SARS$SARS.Mortality)
names(data) <- c("day", "COVID19", "SARS")

#ggplot
plot <- ggplot(data = data, aes(x=day, y=value, colour=variable)) +
  geom_line(aes(y=COVID19 , colour="violet")) +
  geom_line(aes(y=SARS, colour="cyan")) +
  ggtitle("COVID vs SARS Mortality Comparison") +
  xlab("Number of days") +
  ylab("Death toll") +
  scale_color_discrete(labels = c("SARS globally (WHO)", "COVID in just China alone"))

plot + 
  theme_solarized(light=F) +
  theme(legend.title=element_blank()) +
  theme(plot.title = element_text(face="bold", hjust = 0.5, colour="white")) + 
  theme(axis.text = element_text(colour="white")) +
  theme(axis.title = element_text(colour="white", size=8)) +
  theme(legend.key = element_rect(fill="transparent")) + 
  theme(legend.position = "bottom") +
  theme(legend.text = element_text(colour="white")) +
  theme(plot.caption = element_text(colour="white"))
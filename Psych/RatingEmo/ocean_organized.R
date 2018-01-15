
OCEAN <- read.csv("D:/Thesis/Thesis_Code/Psych/RatingEmo/Average/OCEAN_S.csv")
#OCEAN <- read.csv("D:/Thesis/Thesis_Code/Psych/RatingEmo/Average/OCEAN_H.csv")
newocean <- OCEAN[order(OCEAN$Conv, OCEAN$Dyad),]
ocean2 <- cbind(newocean[1:80,1:7],newocean[81:160,2:7])
dim(ocean2)
str(ocean2)

colnames(ocean2) <-c("Dyad","Conv","Openness","Conscientiousness", "Extraversion", "Agreeableness","Neuroticism", 
                     "Conv2", "Openness2", "Conscientiousness2", "Extraversion2", "Agreeableness2","Neuroticism2")

Openness.t <-t.test(ocean2$Openness,ocean2$Openness2,paired=TRUE)
Openness.cor <- cor.test(ocean2$Openness,ocean2$Openness2, method = "pearson")

#Neuroticism.t <-t.test(ocean2$Neuroticism,ocean2$Neuroticism2,paired=TRUE)
#Neuroticism.cor <- cor.test(ocean2$Neuroticism,ocean2$Neuroticism2, method = "pearson")

boxplot(cbind(ocean2[,3:7],ocean2[,9:13]))
a <- cbind(ocean2[,3],ocean2[,9],ocean2[,4],ocean2[,10],ocean2[,5],ocean2[,11],ocean2[,6],ocean2[,12],ocean2[,7],ocean2[,13])

colnames(a) <-c("O1","O2","C1","C2","E1","E2","A1","A2","N1","N2")
boxplot(a)

plot(ocean2$Openness,ocean2$Openness2, xlab="Conv1",ylab="Conv2")
abline(lm(ocean2$Openness ~ ocean2$Openness2))

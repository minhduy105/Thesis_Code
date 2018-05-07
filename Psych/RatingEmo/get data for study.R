#include library
library(sm)

#read the data-- change it to match with the path

Path <- "D:/Thesis/Thesis_Code/Psych/RatingEmo/"

Rapport_Data <- read.csv(paste(Path,"personal trait data.csv", sep=""))
Vocal_rating <-read.csv(paste(Path,"vocalratingsfinaldata.csv", sep=""))


#-------------------------------adding the extra personal rating variable----------------------------------------#

hpa1_comb <- Rapport_Data$hpa1b2 + Rapport_Data$hpa1t6
hpa2_comb <- Rapport_Data$hpa2b2 + Rapport_Data$hpa2t6
ssa1_comb <- Rapport_Data$ssa1b2 + Rapport_Data$ssa1t6
ssa2_comb <- Rapport_Data$ssa2b2 + Rapport_Data$ssa2t6

add_rating <- cbind(hpa1_comb,hpa2_comb,ssa1_comb,ssa2_comb)
Rapport_Data <- cbind(Rapport_Data,add_rating)

outputss <- cbind(Rapport_Data$hdyad, Rapport_Data$ssa2t4, Rapport_Data$ssa2m2, Rapport_Data$ssa2b2,
                  Rapport_Data$ssa2b8, Rapport_Data$ssa2t6, Rapport_Data$ssa2b3, Rapport_Data$ssa2_comb)
colnames(outputss) <-c("Dyad","Effort", "Irritated", "Patient", "Interested", "Responsible", "Responsive",
                     "Pat_Resposoble")

Name = ".csv" 
write.csv(outputss,paste(Path,paste("/Output/ss_info",Name,sep=""),sep = ""))

outputhp <- cbind(Rapport_Data$hdyad, Rapport_Data$hpa2t4, Rapport_Data$hpa2m2, Rapport_Data$hpa2b2,
                  Rapport_Data$hpa2b8, Rapport_Data$hpa2t6, Rapport_Data$hpa2b3, Rapport_Data$hpa2_comb)
colnames(outputhp) <-c("Dyad", "Effort", "Irritated", "Patient", "Interested", "Responsible", "Responsive",
                       "Pat_Resposoble")
 
write.csv(outputhp,paste(Path,paste("/Output/hp_info",Name,sep=""),sep = ""))

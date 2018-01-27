#include library
library(sm)

#read the data-- change it to match with the path

Path <- "D:/Thesis/Thesis_Code/Psych/RatingEmo/"
Threshhold <-100

H_talk <- read.csv(paste(Path,"DiscriptiveData_5talks_H_5mins.csv", sep=""))
Rapport_Data <- read.csv(paste(Path,"rapport_data_simplified.csv", sep=""))


#delte useless column
H_talk$SectionStartTime <- NULL
H_talk$Start <- NULL
H_talk$End <-NULL


#select talkType == 2, which is typing
H_talk_Type <- H_talk[H_talk$TalkType == 2,]


#seperate it into different conversation
H_talk_Type_1 <- H_talk_Type[H_talk_Type$Cov == 1,]
H_talk_Type_2 <- H_talk_Type[H_talk_Type$Cov == 2,]


#select typing that is longer than 100 frames
H_talk_Type_1 <- H_talk_Type_1[H_talk_Type_1$Duration > Threshhold,]
H_talk_Type_2 <- H_talk_Type_2[H_talk_Type_2$Duration > Threshhold,]


#----------------------DYAD 1--------------------------------------------#
#calculat the overall of nocomp and no_face gaze
CompOnly_Overall_Time <- H_talk_Type_1$S_Monitor_Overall_Time + H_talk_Type_1$S_Keyboard_Overall_Time
NoFace_Overall_Time <- CompOnly_Overall_Time + H_talk_Type_1$S_Around_Overall_Time
BodyOnly_Overall_Time <- H_talk_Type_1$S_Monitor_Overall_Time + H_talk_Type_1$S_Face_Overall_Time
Extra_Gaze <- cbind(CompOnly_Overall_Time, NoFace_Overall_Time, BodyOnly_Overall_Time)
colnames(Extra_Gaze) <-c("S_CompOnly_Overall_Time","S_NoFace_Overall_Time", "S_BodyOnly_Overall_Time")
H_talk_Type_1 <- cbind(H_talk_Type_1,Extra_Gaze)

# aggregate/combined them together 
H_talk_Type_1_sum <- aggregate(H_talk_Type_1[, 4:101],list(H_talk_Type_1$Dyad),sum)

#get the total gaze actions in the whole dyad / total time of typing
Percent_Total <- H_talk_Type_1_sum[,4:7]/H_talk_Type_1_sum$Duration * 100.0
Percent_Total_Extra <- H_talk_Type_1_sum[,97:99]/H_talk_Type_1_sum$Duration * 100.0
Percent_Speak <- H_talk_Type_1_sum$S_Speaking_Overall_Time/H_talk_Type_1_sum$Duration * 100.0
Percent_Total <- cbind(Percent_Total,Percent_Total_Extra)
Percent_Total <- cbind(Percent_Total,Percent_Speak)
colnames(Percent_Total) <-c("S_Around_Per_Total", "S_Monitor_Per_Total", "S_Keyboard_Per_Total", 
                            "S_Face_Per_Total", "S_CompOnly_Per_Total", "S_NoFace_Per_Total",
                            "S_BodyOnly_Per_Total", "S_Speak_Per_Total")
H_talk_Type_1_sum <- cbind(H_talk_Type_1_sum,Percent_Total)


#----------------------DYAD 2--------------------------------------------#
#calculat the overall of nocomp and no_face gaze
CompOnly_Overall_Time <- H_talk_Type_2$S_Monitor_Overall_Time + H_talk_Type_2$S_Keyboard_Overall_Time
NoFace_Overall_Time <- CompOnly_Overall_Time + H_talk_Type_2$S_Around_Overall_Time
BodyOnly_Overall_Time <- H_talk_Type_2$S_Monitor_Overall_Time + H_talk_Type_2$S_Face_Overall_Time
Extra_Gaze <- cbind(CompOnly_Overall_Time, NoFace_Overall_Time, BodyOnly_Overall_Time)
colnames(Extra_Gaze) <-c("S_CompOnly_Overall_Time","S_NoFace_Overall_Time", "S_BodyOnly_Overall_Time")
H_talk_Type_2 <- cbind(H_talk_Type_2,Extra_Gaze)

# aggregate/combined them together 
H_talk_Type_2_sum <- aggregate(H_talk_Type_2[, 4:101],list(H_talk_Type_2$Dyad),sum)

#get the total gaze actions in the whole dyad / total time of typing
Percent_Total <- H_talk_Type_2_sum[,4:7]/H_talk_Type_2_sum$Duration * 100.0
Percent_Total_Extra <- H_talk_Type_2_sum[,97:99]/H_talk_Type_2_sum$Duration * 100.0
Percent_Speak <- H_talk_Type_2_sum$S_Speaking_Overall_Time/H_talk_Type_2_sum$Duration * 100.0
Percent_Total <- cbind(Percent_Total,Percent_Total_Extra)
Percent_Total <- cbind(Percent_Total,Percent_Speak)
colnames(Percent_Total) <-c("S_Around_Per_Total", "S_Monitor_Per_Total", "S_Keyboard_Per_Total", 
                            "S_Face_Per_Total", "S_CompOnly_Per_Total", "S_NoFace_Per_Total",
                            "S_BodyOnly_Per_Total", "S_Speak_Per_Total")
H_talk_Type_2_sum <- cbind(H_talk_Type_2_sum,Percent_Total)



#----------------------------------------Stat test------------------------------------------------------------------#


#---------------------------DYAD 1------------------------------------#
testData <- cbind(Rapport_Data$hdyad, Rapport_Data$htechint, Rapport_Data$hhogan, 
                  Rapport_Data$hboredom, Rapport_Data$hsdesirability, Rapport_Data$shogan, 
                  Rapport_Data$sboredom, Rapport_Data$ssdesirability, Rapport_Data$hpabad, 
                  Rapport_Data$hpabad2, Rapport_Data$hpagood, Rapport_Data$hpagood2, Rapport_Data$spabad, 
                  Rapport_Data$spabad2, Rapport_Data$spagood, Rapport_Data$spagood2, Rapport_Data$rapcomp2)
colnames(testData) <-c("dyad","techint","hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability",
                       "hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2")

combinedForSum <- merge(x=testData, y=H_talk_Type_1_sum, by.x='dyad', by.y='Group.1')

#3 dimension array row is the scale, column is the gaze, depth is stat result
# row: "hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability","hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2"
# column: around, monitor, keyboard, face, componly, no face
# depth: t-value, correlation, p-value
Result <- array(numeric(),c(15,8,3))
for (i in 3:17){
  for (j in 116:123){
    result <- cor.test(combinedForSum[,i],combinedForSum[,j], method = "pearson")
    Result[i-2,j-115,1] <-result$statistic #t-value  
    Result[i-2,j-115,2] <-result$estimate #corelation
    Result[i-2,j-115,3] <-result$p.value #p-value  
  }  
}
rownames(Result) <-c("hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability",
                     "hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2")
colnames (Result)<-c("around", "monitor", "keyboard", "face", "comp_only", "no_face","body_only","s_speak")
print (Result)
Sum_Overall <-Result

Name <-paste(Threshhold,"f.csv",sep="")
write.csv(Sum_Overall[,,1],paste(Path,paste("/Output/dyad1_total_per_tval_",Name,sep=""),sep = ""))
write.csv(Sum_Overall[,,2],paste(Path,paste("/Output/dyad1_total_per_cor_",Name,sep=""),sep = ""))
write.csv(Sum_Overall[,,3],paste(Path,paste("/Output/dyad1_total_per_pval_",Name,sep=""),sep = ""))



#----------------------------------DYAD 2---------------------------------#
testData <- cbind(Rapport_Data$hdyad, Rapport_Data$htechint, Rapport_Data$hhogan, 
                  Rapport_Data$hboredom, Rapport_Data$hsdesirability, Rapport_Data$shogan, 
                  Rapport_Data$sboredom, Rapport_Data$ssdesirability, Rapport_Data$hpabad, 
                  Rapport_Data$hpabad2, Rapport_Data$hpagood, Rapport_Data$hpagood2, Rapport_Data$spabad, 
                  Rapport_Data$spabad2, Rapport_Data$spagood, Rapport_Data$spagood2, Rapport_Data$rapcomp2)
colnames(testData) <-c("dyad","techint","hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability",
                       "hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2")

combinedForSum <- merge(x=testData, y=H_talk_Type_2_sum, by.x='dyad', by.y='Group.1')

#3 dimension array row is the scale, column is the gaze, depth is stat result
# row: "hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability","hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2"
# column: around, monitor, keyboard, face, componly, no face
# depth: t-value, correlation, p-value
Result <- array(numeric(),c(15,8,3))
for (i in 3:17){
  for (j in 116:123){
    result <- cor.test(combinedForSum[,i],combinedForSum[,j], method = "pearson")
    Result[i-2,j-115,1] <-result$statistic #t-value  
    Result[i-2,j-115,2] <-result$estimate #corelation
    Result[i-2,j-115,3] <-result$p.value #p-value  
  }  
}
rownames(Result) <-c("hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability",
                     "hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2")
colnames (Result)<-c("around", "monitor", "keyboard", "face", "comp_only", "no_face","body_only","s_speak")
print (Result)
Sum_Overall <-Result

Name <-paste(Threshhold,"f.csv",sep="")
write.csv(Sum_Overall[,,1],paste(Path,paste("/Output/dyad2_total_per_tval_",Name,sep=""),sep = ""))
write.csv(Sum_Overall[,,2],paste(Path,paste("/Output/dyad2_total_per_cor_",Name,sep=""),sep = ""))
write.csv(Sum_Overall[,,3],paste(Path,paste("/Output/dyad2_total_per_pval_",Name,sep=""),sep = ""))



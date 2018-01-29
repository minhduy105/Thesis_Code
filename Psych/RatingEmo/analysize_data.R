#include library
library(sm)

#read the data-- change it to match with the path

Path <- "D:/Thesis/Thesis_Code/Psych/RatingEmo/"
Threshhold <-480

H_talk <- read.csv(paste(Path,"DiscriptiveData_5talks_H_5mins.csv", sep=""))
Rapport_Data <- read.csv(paste(Path,"personal trait data.csv", sep=""))


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

#H_talk_Type_1_raw <- H_talk_Type_1[H_talk_Type_1$Duration > Threshhold,]
#H_talk_Type_2_raw <- H_talk_Type_2[H_talk_Type_2$Duration > Threshhold,]

#H_talk_Type_1_log <-log(H_talk_Type_1_raw[,4:98])
#H_talk_Type_1 <-cbind(H_talk_Type_1_raw[,1:3],H_talk_Type_1_log)

#H_talk_Type_2_log <-log(H_talk_Type_2_raw[,4:98])
#H_talk_Type_2 <-cbind(H_talk_Type_2_raw[,1:3],H_talk_Type_2_log)


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
H_talk_Type_1_mean <- aggregate(H_talk_Type_1[, 4:101],list(H_talk_Type_1$Dyad),mean)

Name <-paste(Threshhold,"f.csv",sep="")
write.csv(H_talk_Type_1_mean,paste(Path,paste("/Output/dyad1_data_mean_",Name,sep=""),sep = ""))


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
write.csv(H_talk_Type_1_sum,paste(Path,paste("/Output/dyad1_data_sum_",Name,sep=""),sep = ""))


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
H_talk_Type_2_mean <- aggregate(H_talk_Type_2[, 4:101],list(H_talk_Type_2$Dyad),mean)

Name <-paste(Threshhold,"f.csv",sep="")
write.csv(H_talk_Type_2_mean,paste(Path,paste("/Output/dyad2_data_mean_",Name,sep=""),sep = ""))


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
write.csv(H_talk_Type_2_sum,paste(Path,paste("/Output/dyad2_data_sum_",Name,sep=""),sep = ""))



#----------------------------------------Stat test------------------------------------------------------------------#


#---------------------------DYAD 1------------------------------------#


combinedForSum <- merge(x=Rapport_Data, y=H_talk_Type_1_sum, by.x='hdyad', by.y='Group.1')

#3 dimension array row is the scale, column is the gaze, depth is stat result
# row: "hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability","hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2"
# column: around, monitor, keyboard, face, componly, no face
# depth: t-value, correlation, p-value
Result <- array(numeric(),c(8,6,3))
for (i in 980:987){
  result <- cor.test(combinedForSum[,i],combinedForSum$hsa1t4, method = "pearson")
  Result[i-979,1,1] <-result$statistic #t-value  
  Result[i-979,1,2] <-result$estimate #corelation
  Result[i-979,1,3] <-result$p.value #p-value  
  
  result <- cor.test(combinedForSum[,i],combinedForSum$hsa1m2, method = "pearson")
  Result[i-979,2,1] <-result$statistic #t-value  
  Result[i-979,2,2] <-result$estimate #corelation
  Result[i-979,2,3] <-result$p.value #p-value  
  
  result <- cor.test(combinedForSum[,i],combinedForSum$hsa1b2, method = "pearson")
  Result[i-979,3,1] <-result$statistic #t-value  
  Result[i-979,3,2] <-result$estimate #corelation
  Result[i-979,3,3] <-result$p.value #p-value  
  
  result <- cor.test(combinedForSum[,i],combinedForSum$hsa1b8, method = "pearson")
  Result[i-979,4,1] <-result$statistic #t-value  
  Result[i-979,4,2] <-result$estimate #corelation
  Result[i-979,4,3] <-result$p.value #p-value  
  
  result <- cor.test(combinedForSum[,i],combinedForSum$hsa1t6, method = "pearson")
  Result[i-979,5,1] <-result$statistic #t-value  
  Result[i-979,5,2] <-result$estimate #corelation
  Result[i-979,5,3] <-result$p.value #p-value  
  
  result <- cor.test(combinedForSum[,i],combinedForSum$hsa1b3, method = "pearson")
  Result[i-979,6,1] <-result$statistic #t-value  
  Result[i-979,6,2] <-result$estimate #corelation
  Result[i-979,6,3] <-result$p.value #p-value  
}





colnames(Result) <-c("Effort", "Irritated", "Patient", "Interested", "Responsible", "Responsive")
rownames (Result)<-c("around", "monitor", "keyboard", "face", "comp_only", "no_face","body_only","s_speak")
print (Result)
Sum_Overall <-Result

Name <-paste(Threshhold,"f.csv",sep="")
write.csv(Sum_Overall[,,1],paste(Path,paste("/Output/dyad1_hs_total_per_tval_",Name,sep=""),sep = ""))
write.csv(Sum_Overall[,,2],paste(Path,paste("/Output/dyad1_hs_total_per_cor_",Name,sep=""),sep = ""))
write.csv(Sum_Overall[,,3],paste(Path,paste("/Output/dyad1_hs_total_per_pval_",Name,sep=""),sep = ""))



#----------------------------------DYAD 2---------------------------------#
combinedForSum <- merge(x=Rapport_Data, y=H_talk_Type_2_sum, by.x='hdyad', by.y='Group.1')

#3 dimension array row is the scale, column is the gaze, depth is stat result
# row: "hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability","hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2"
# column: around, monitor, keyboard, face, componly, no face
# depth: t-value, correlation, p-value
Result <- array(numeric(),c(8,6,3))
for (i in 980:987){
  result <- cor.test(combinedForSum[,i],combinedForSum$hsa2t4, method = "pearson")
  Result[i-979,1,1] <-result$statistic #t-value  
  Result[i-979,1,2] <-result$estimate #corelation
  Result[i-979,1,3] <-result$p.value #p-value  
  
  result <- cor.test(combinedForSum[,i],combinedForSum$hsa2m2, method = "pearson")
  Result[i-979,2,1] <-result$statistic #t-value  
  Result[i-979,2,2] <-result$estimate #corelation
  Result[i-979,2,3] <-result$p.value #p-value  
  
  result <- cor.test(combinedForSum[,i],combinedForSum$hsa2b2, method = "pearson")
  Result[i-979,3,1] <-result$statistic #t-value  
  Result[i-979,3,2] <-result$estimate #corelation
  Result[i-979,3,3] <-result$p.value #p-value  
  
  result <- cor.test(combinedForSum[,i],combinedForSum$hsa2b8, method = "pearson")
  Result[i-979,4,1] <-result$statistic #t-value  
  Result[i-979,4,2] <-result$estimate #corelation
  Result[i-979,4,3] <-result$p.value #p-value  
  
  result <- cor.test(combinedForSum[,i],combinedForSum$hsa2t6, method = "pearson")
  Result[i-979,5,1] <-result$statistic #t-value  
  Result[i-979,5,2] <-result$estimate #corelation
  Result[i-979,5,3] <-result$p.value #p-value  
  
  result <- cor.test(combinedForSum[,i],combinedForSum$hsa2b3, method = "pearson")
  Result[i-979,6,1] <-result$statistic #t-value  
  Result[i-979,6,2] <-result$estimate #corelation
  Result[i-979,6,3] <-result$p.value #p-value  
  
}

colnames(Result) <-c("Effort", "Irritated", "Patient", "Interested", "Responsible", "Responsive")
rownames (Result)<-c("around", "monitor", "keyboard", "face", "comp_only", "no_face","body_only","s_speak")
print (Result)
Sum_Overall <-Result

Name <-paste(Threshhold,"f.csv",sep="")
write.csv(Sum_Overall[,,1],paste(Path,paste("/Output/dyad2_hs_total_per_tval_",Name,sep=""),sep = ""))
write.csv(Sum_Overall[,,2],paste(Path,paste("/Output/dyad2_hs_total_per_cor_",Name,sep=""),sep = ""))
write.csv(Sum_Overall[,,3],paste(Path,paste("/Output/dyad2_hs_total_per_pval_",Name,sep=""),sep = ""))

#face_gaze <- t.test(H_talk_Type_1_sum$S_Face_Per_Total,H_talk_Type_2_sum$S_Face_Per_Total)
#around_gaze <- t.test(H_talk_Type_1_sum$S_Around_Per_Total,H_talk_Type_2_sum$S_Around_Per_Total)
#comn_gaze <- t.test(H_talk_Type_1_sum$S_CompOnly_Per_Total,H_talk_Type_2_sum$S_CompOnly_Per_Total)
#body_gaze <- t.test(H_talk_Type_1_sum$S_BodyOnly_Per_Total,H_talk_Type_2_sum$S_BodyOnly_Per_Total)

#face_gaze_cor <- cor.test(H_talk_Type_1_sum$S_Face_Per_Total,H_talk_Type_2_sum$S_Face_Per_Total, method = "pearson")
#around_gaze_cor <- cor.test(H_talk_Type_1_sum$S_Around_Per_Total,H_talk_Type_2_sum$S_Around_Per_Total, method = "pearson")
#comn_gaze_cor <- cor.test(H_talk_Type_1_sum$S_CompOnly_Per_Total,H_talk_Type_2_sum$S_CompOnly_Per_Total, method = "pearson")
#body_gaze_cor <- cor.test(H_talk_Type_1_sum$S_BodyOnly_Per_Total,H_talk_Type_2_sum$S_BodyOnly_Per_Total, method = "pearson")
#include library
library(sm)

#read the data-- change it to match with the path

Path <- "D:/Thesis/Thesis_Code/Psych/RatingEmo/"
Threshhold <-150

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



#-------------------------------adding the extra personal rating variable----------------------------------------#

hpa1_comb <- Rapport_Data$hpa1b2 + Rapport_Data$hpa1t6
hpa2_comb <- Rapport_Data$hpa2b2 + Rapport_Data$hpa2t6
ssa1_comb <- Rapport_Data$ssa1b2 + Rapport_Data$ssa1t6
ssa2_comb <- Rapport_Data$ssa2b2 + Rapport_Data$ssa2t6

add_rating <- cbind(hpa1_comb,hpa2_comb,ssa1_comb,ssa2_comb)
Rapport_Data <- cbind(Rapport_Data,add_rating)



#----------------------------------------Stat test------------------------------------------------------------------#


#---------------------------DYAD 1------------------------------------#


combinedForSum <- merge(x=Rapport_Data, y=H_talk_Type_1_sum, by.x='hdyad', by.y='Group.1')

Result <- array(numeric(),c(3,7))
result <- cor.test(combinedForSum$hpa1t4,combinedForSum$ssa1t4, method = "pearson")
Result[1,1] <-result$statistic #t-value  
Result[2,1] <-result$estimate #corelation
Result[3,1] <-result$p.value #p-value  
  
result <- cor.test(combinedForSum$hpa1m2,combinedForSum$ssa1m2, method = "pearson")
Result[1,2] <-result$statistic #t-value  
Result[2,2] <-result$estimate #corelation
Result[3,2] <-result$p.value #p-value  

result <- cor.test(combinedForSum$hpa1b2,combinedForSum$ssa1b2, method = "pearson")
Result[1,3] <-result$statistic #t-value  
Result[2,3] <-result$estimate #corelation
Result[3,3] <-result$p.value #p-value  

result <- cor.test(combinedForSum$hpa1b8,combinedForSum$ssa1b8, method = "pearson")
Result[1,4] <-result$statistic #t-value  
Result[2,4] <-result$estimate #corelation
Result[3,4] <-result$p.value #p-value  

result <- cor.test(combinedForSum$hpa1t6,combinedForSum$ssa1t6, method = "pearson")
Result[1,5] <-result$statistic #t-value  
Result[2,5] <-result$estimate #corelation
Result[3,5] <-result$p.value #p-value  

result <- cor.test(combinedForSum$hpa1b3,combinedForSum$ssa1b3, method = "pearson")
Result[1,6] <-result$statistic #t-value  
Result[2,6] <-result$estimate #corelation
Result[3,6] <-result$p.value #p-value  
  

result <- cor.test(combinedForSum$hpa1_comb,combinedForSum$ssa1_comb, method = "pearson")
Result[1,7] <-result$statistic #t-value  
Result[2,7] <-result$estimate #corelation
Result[3,7] <-result$p.value #p-value  

colnames(Result) <-c("Effort", "Irritated", "Patient", "Interested", "Responsible", "Responsive", "Pat_Resposoble")
rownames (Result)<-c("tval", "cor", "pval")
print (Result)
Sum_Overall <-Result

Name <-paste(Threshhold,"f.csv",sep="")
write.csv(Sum_Overall,paste(Path,paste("/Output/dyad1_hp_cor_ss",Name,sep=""),sep = ""))




#----------------------------------DYAD 2---------------------------------#
combinedForSum <- merge(x=Rapport_Data, y=H_talk_Type_2_sum, by.x='hdyad', by.y='Group.1')

#3 dimension array row is the scale, column is the gaze, depth is stat result
# row: "hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability","hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2"
# column: around, monitor, keyboard, face, componly, no face
# depth: t-value, correlation, p-value
Result <- array(numeric(),c(3,7))
result <- cor.test(combinedForSum$hpa2t4,combinedForSum$ssa2t4, method = "pearson")
Result[1,1] <-result$statistic #t-value  
Result[2,1] <-result$estimate #corelation
Result[3,1] <-result$p.value #p-value  

result <- cor.test(combinedForSum$hpa2m2,combinedForSum$ssa2m2, method = "pearson")
Result[1,2] <-result$statistic #t-value  
Result[2,2] <-result$estimate #corelation
Result[3,2] <-result$p.value #p-value  

result <- cor.test(combinedForSum$hpa2b2,combinedForSum$ssa2b2, method = "pearson")
Result[1,3] <-result$statistic #t-value  
Result[2,3] <-result$estimate #corelation
Result[3,3] <-result$p.value #p-value  

result <- cor.test(combinedForSum$hpa2b8,combinedForSum$ssa2b8, method = "pearson")
Result[1,4] <-result$statistic #t-value  
Result[2,4] <-result$estimate #corelation
Result[3,4] <-result$p.value #p-value  

result <- cor.test(combinedForSum$hpa2t6,combinedForSum$ssa2t6, method = "pearson")
Result[1,5] <-result$statistic #t-value  
Result[2,5] <-result$estimate #corelation
Result[3,5] <-result$p.value #p-value  

result <- cor.test(combinedForSum$hpa2b3,combinedForSum$ssa2b3, method = "pearson")
Result[1,6] <-result$statistic #t-value  
Result[2,6] <-result$estimate #corelation
Result[3,6] <-result$p.value #p-value  


result <- cor.test(combinedForSum$hpa2_comb,combinedForSum$ssa2_comb, method = "pearson")
Result[1,7] <-result$statistic #t-value  
Result[2,7] <-result$estimate #corelation
Result[3,7] <-result$p.value #p-value  


colnames(Result) <-c("Effort", "Irritated", "Patient", "Interested", "Responsible", "Responsive", "Pat_Resposoble")
rownames (Result)<-c("tval", "cor", "pval")
print (Result)
Sum_Overall <-Result

Name <-paste(Threshhold,"f.csv",sep="")
write.csv(Sum_Overall,paste(Path,paste("/Output/dyad2_hp_cor_ss",Name,sep=""),sep = ""))

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

face_gaze <- t.test(H_talk_Type_1_sum$S_Face_Per_Total,H_talk_Type_2_sum$S_Face_Per_Total,paired=TRUE)
around_gaze <- t.test(H_talk_Type_1_sum$S_Around_Per_Total,H_talk_Type_2_sum$S_Around_Per_Total,paired=TRUE)
monitor_gaze <- t.test(H_talk_Type_1_sum$S_Monitor_Per_Total,H_talk_Type_2_sum$S_Monitor_Per_Total,paired=TRUE)
keyboard_gaze <- t.test(H_talk_Type_1_sum$S_Keyboard_Per_Total,H_talk_Type_2_sum$S_Keyboard_Per_Total,paired=TRUE)
comn_gaze <- t.test(H_talk_Type_1_sum$S_CompOnly_Per_Total,H_talk_Type_2_sum$S_CompOnly_Per_Total,paired=TRUE)
body_gaze <- t.test(H_talk_Type_1_sum$S_BodyOnly_Per_Total,H_talk_Type_2_sum$S_BodyOnly_Per_Total,paired=TRUE)


face_gaze_cor <- cor.test(H_talk_Type_1_sum$S_Face_Per_Total,H_talk_Type_2_sum$S_Face_Per_Total, method = "pearson")
around_gaze_cor <- cor.test(H_talk_Type_1_sum$S_Around_Per_Total,H_talk_Type_2_sum$S_Around_Per_Total, method = "pearson")
monitor_gaze_cor <- cor.test(H_talk_Type_1_sum$S_Monitor_Per_Total,H_talk_Type_2_sum$S_Monitor_Per_Total, method = "pearson")
keyboard_gaze_cor <- cor.test(H_talk_Type_1_sum$S_Keyboard_Per_Total,H_talk_Type_2_sum$S_Keyboard_Per_Total, method = "pearson")
comn_gaze_cor <- cor.test(H_talk_Type_1_sum$S_CompOnly_Per_Total,H_talk_Type_2_sum$S_CompOnly_Per_Total, method = "pearson")
body_gaze_cor <- cor.test(H_talk_Type_1_sum$S_BodyOnly_Per_Total,H_talk_Type_2_sum$S_BodyOnly_Per_Total, method = "pearson")


hp_4 <- t.test(Rapport_Data$hpa1b8,Rapport_Data$hpa2b8,paired=TRUE)
ss_4 <- t.test(Rapport_Data$ssa1b8,Rapport_Data$ssa2b8,paired=TRUE)

hp_5 <- t.test(Rapport_Data$hpa1t6,Rapport_Data$hpa2t6,paired=TRUE)
ss_5 <- t.test(Rapport_Data$ssa1t6,Rapport_Data$ssa2t6,paired=TRUE)

hp_4_cor <- cor.test(Rapport_Data$hpa1b8,Rapport_Data$hpa2b8, method = "pearson")
ss_4_cor <- cor.test(Rapport_Data$ssa1b8,Rapport_Data$ssa2b8, method = "pearson")

hp_5_cor <- cor.test(Rapport_Data$hpa1t6,Rapport_Data$hpa2t6, method = "pearson")
ss_5_cor <- cor.test(Rapport_Data$ssa1t6,Rapport_Data$ssa2t6, method = "pearson")

par(mfrow=c(2,2))
plot(Rapport_Data$hpa1b8,Rapport_Data$hpa2b8, 
     xlab='Keyboard', ylab='Remote Control',main="AAC Users Partner Rating: Interest")
plot(Rapport_Data$ssa1b8,Rapport_Data$ssa2b8, 
     xlab='Keyboard', ylab='Remote Control',main="Normal Speaker Self Rating: Interest")
plot(Rapport_Data$hpa1t6,Rapport_Data$hpa2t6, 
     xlab='Keyboard', ylab='Remote Control',main="AAC Users Partner Rating: Reponsible")
plot(Rapport_Data$ssa1t6,Rapport_Data$ssa2t6, 
     xlab='Keyboard', ylab='Remote Control',main="Normal Speaker Self Rating: Reponsible")
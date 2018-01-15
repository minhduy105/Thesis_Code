#include library
library(sm)

#read the data-- change it to match with the path
H_talk <- read.csv("D:/Thesis/Thesis_Code/Psych/RatingEmo/DiscriptiveData_5talks_H_5mins.csv")
Rapport_Data <- read.csv("D:/Thesis/Thesis_Code/Psych/RatingEmo/rapport_data_simplified.csv")


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
H_talk_Type_2 <- H_talk_Type_2[H_talk_Type_2$Duration > 100,]

#calculate the gaze percent of (around, monitor, keyboard, and face) and add it into the file
GazePercent <- H_talk_Type_2[,6:9]/H_talk_Type_2$Duration * 100.0
colnames(GazePercent) <-c("S_Percent_Around","S_Percent_MOnitor","S_Percent_Keyboard","S_Percent_Face")
H_talk_Type_2 <-cbind(H_talk_Type_2,GazePercent)

#calculat the overall of nocomp and no_face gaze
CompOnly_Overall_Time <- H_talk_Type_2$S_Monitor_Overall_Time + H_talk_Type_2$S_Keyboard_Overall_Time
NoFace_Overall_Time <- CompOnly_Overall_Time + H_talk_Type_2$S_Around_Overall_Time
CompOnly_Percent <- CompOnly_Overall_Time/H_talk_Type_2$Duration *100.0
NoFace_Percent <- NoFace_Overall_Time/H_talk_Type_2$Duration *100.0
Extra_Gaze <- cbind(CompOnly_Overall_Time,NoFace_Overall_Time,CompOnly_Percent,NoFace_Percent)
colnames(Extra_Gaze) <-c("S_CompOnly_Overall_Time","S_NoFace_Overall_Time","S_CompOnly_Percent","S_NoFace_Percent")
H_talk_Type_2 <- cbind(H_talk_Type_2,Extra_Gaze)

# aggregate/combined them together 
H_talk_Type_2_mean <- aggregate(H_talk_Type_2[, 4:100],list(H_talk_Type_2$Dyad),mean)
H_talk_Type_2_sum <- aggregate(H_talk_Type_2[, 4:100],list(H_talk_Type_2$Dyad),sum)
H_talk_Type_2_max <- aggregate(H_talk_Type_2[, 4:100],list(H_talk_Type_2$Dyad),max)
H_talk_Type_2_min <- aggregate(H_talk_Type_2[, 4:100],list(H_talk_Type_2$Dyad),min)




#-----------------Draw Density Map-----------------------------#
#Run each section one at a time 

#------Mean of Mean----------------------#
#individual map
Mean_Around_Mean <- density(H_talk_Type_2_mean$S_Around_Mean) # returns the density data 
plot(Mean_Around_Mean,main = "Mean of Around Mean")

Mean_Monitor_Mean <- density(H_talk_Type_2_mean$S_Monitor_Mean) # returns the density data 
plot(Mean_Monitor_Mean,main = "Mean of Monitor Mean")

Mean_Keyboard_Mean <- density(H_talk_Type_2_mean$S_Keyboard_Mean) # returns the density data 
plot(Mean_Keyboard_Mean,main = "Mean of Keyboard Mean")

Mean_Face_Mean <- density(H_talk_Type_2_mean$S_Face_Mean) # returns the density data 
plot(Mean_Face_Mean,main = "Mean of Face Mean")

Mean_CompOnly_Mean <- density(H_talk_Type_2_mean$S_CompOnly_Mean) # returns the density data 
plot(Mean_CompOnly_Mean,main = "Mean of CompOnly Mean")

Mean_NoFace_Mean <- density(H_talk_Type_2_mean$S_NoFace_Mean) # returns the density data 
plot(Mean_NoFace_Mean,main = "Mean of NoFace Mean")


#combined all 4 graph: around, monitor, keyboard, face
xlim <- range(H_talk_Type_2_mean$S_Around_Mean,H_talk_Type_2_mean$S_Monitor_Mean,
              H_talk_Type_2_mean$S_Keyboard_Mean,H_talk_Type_2_mean$S_Face_Mean)
ylim <- range(Mean_Around_Mean$y, Mean_Monitor_Mean$y, Mean_Keyboard_Mean$y, Mean_Face_Mean$y)
plot(Mean_Around_Mean$x, Mean_Around_Mean$y, col = 'blue', lwd = 2, lty=1, type = "l", 
     xlim = xlim, ylim = ylim,xlab = "Frames",ylab = "Density")
lines(Mean_Monitor_Mean$x, Mean_Monitor_Mean$y, col = 'red', lwd = 2, lty=3)
lines(Mean_Keyboard_Mean$x, Mean_Keyboard_Mean$y, col = 'green', lwd = 2, lty=4)
lines(Mean_Face_Mean$x, Mean_Face_Mean$y, col = 'purple', lwd = 2, lty=5)

legend(x="topright", 
       legend=c("Mean of Around Mean", "Mean of Monitor Mean","Mean of Keyboard Mean", "Mean of Face Mean"),
       col=c("blue","red","green","purple"), lwd=1, lty=c(1,3,4,5), 
       pch=c(NA,NA)) 


#combined all 6 graph: around, monitor, keyboard, face, componly, no face
xlim <- range(H_talk_Type_2_mean$S_Around_Mean,H_talk_Type_2_mean$S_Monitor_Mean,
              H_talk_Type_2_mean$S_Keyboard_Mean,H_talk_Type_2_mean$S_Face_Mean,
              H_talk_Type_2_mean$S_CompOnly_Mean,H_talk_Type_2_mean$S_NoFace_Mean)
ylim <- range(Mean_Around_Mean$y, Mean_Monitor_Mean$y, Mean_Keyboard_Mean$y, 
              Mean_Face_Mean$y, Mean_CompOnly_Mean$y, Mean_NoFace_Mean$y)
plot(Mean_Around_Mean$x, Mean_Around_Mean$y, col = 'blue', lwd = 2, lty=1, type = "l", 
     xlim = xlim, ylim = ylim,xlab = "Frames",ylab = "Density")
lines(Mean_Monitor_Mean$x, Mean_Monitor_Mean$y, col = 'red', lwd = 2, lty=2)
lines(Mean_Keyboard_Mean$x, Mean_Keyboard_Mean$y, col = 'green', lwd = 2, lty=3)
lines(Mean_Face_Mean$x, Mean_Face_Mean$y, col = 'purple', lwd = 2, lty=4)
lines(Mean_CompOnly_Mean$x, Mean_CompOnly_Mean$y, col = 'black', lwd = 2, lty=5)
lines(Mean_NoFace_Mean$x, Mean_NoFace_Mean$y, col = 'yellow', lwd = 2, lty=6)
legend(x="topright", 
       legend=c("Mean of Around Mean", "Mean of Monitor Mean","Mean of Keyboard Mean",
                "Mean of Face Mean", "Mean of CompOnly Mean", "Mean of NoFace Mean"),
       col=c("blue","red","green","purple","black","yellow"), lwd=1, lty=c(1,2,3,4,5,6), 
       pch=c(NA,NA)) 

#------Mean of Percent----------------------#

#individual map
Mean_Around_Percent <- density(H_talk_Type_2_mean$S_Percent_Around) # returns the density data 
plot(Mean_Around_Percent,main = "Mean of Around Percent")

Mean_Monitor_Percent <- density(H_talk_Type_2_mean$S_Percent_MOnitor) # returns the density data 
plot(Mean_Monitor_Percent,main = "Mean of Monitor Percent")

Mean_Keyboard_Percent <- density(H_talk_Type_2_mean$S_Percent_Keyboard) # returns the density data 
plot(Mean_Keyboard_Percent,main = "Mean of Keyboard Percent")

Mean_Face_Percent <- density(H_talk_Type_2_mean$S_Percent_Face) # returns the density data 
plot(Mean_Face_Percent,main = "Mean of Face Percent")

Mean_CompOnly_Percent <- density(H_talk_Type_2_mean$S_CompOnly_Percent) # returns the density data 
plot(Mean_CompOnly_Percent,main = "Mean of CompOnly Percent")

Mean_NoFace_Percent <- density(H_talk_Type_2_mean$S_NoFace_Percent) # returns the density data 
plot(Mean_NoFace_Percent,main = "Mean of NoFace Percent")


#combined all 4 graph: around, monitor, keyboard, face
xlim <- range(H_talk_Type_2_mean$S_Percent_Around,H_talk_Type_2_mean$S_Percent_MOnitor,
              H_talk_Type_2_mean$S_Percent_Keyboard,H_talk_Type_2_mean$S_Percent_Face)
ylim <- range(Mean_Around_Percent$y, Mean_Monitor_Percent$y, Mean_Keyboard_Percent$y, Mean_Face_Percent$y)
plot(Mean_Around_Percent$x, Mean_Around_Percent$y, col = 'blue', lwd = 2, lty=1, type = "l", 
     xlim = xlim, ylim = ylim,xlab = "Percent",ylab = "Density")
lines(Mean_Monitor_Percent$x, Mean_Monitor_Percent$y, col = 'red', lwd = 2, lty=3)
lines(Mean_Keyboard_Percent$x, Mean_Keyboard_Percent$y, col = 'green', lwd = 2, lty=4)
lines(Mean_Face_Percent$x, Mean_Face_Percent$y, col = 'purple', lwd = 2, lty=5)

legend(x="topright", 
       legend=c("Mean of Around Percent", "Mean of Monitor Percent","Mean of Keyboard Percent", "Mean of Face Percent"),
       col=c("blue","red","green","purple"), lwd=1, lty=c(1,3,4,5), 
       pch=c(NA,NA)) 

#combined all 6 graph: around, monitor, keyboard, face, componly, no face
xlim <- range(H_talk_Type_2_mean$S_Percent_Around,H_talk_Type_2_mean$S_Percent_MOnitor,
              H_talk_Type_2_mean$S_Percent_Keyboard,H_talk_Type_2_mean$S_Percent_Face,
              H_talk_Type_2_mean$S_CompOnly_Percent,H_talk_Type_2_mean$S_NoFace_Percent)
ylim <- range(Mean_Around_Percent$y, Mean_Monitor_Percent$y, Mean_Keyboard_Percent$y, 
              Mean_Face_Percent$y, Mean_CompOnly_Percent$y, Mean_NoFace_Percent$y)
plot(Mean_Around_Percent$x, Mean_Around_Percent$y, col = 'blue', lwd = 2, lty=1, type = "l", 
     xlim = xlim, ylim = ylim,xlab = "Percent",ylab = "Density")
lines(Mean_Monitor_Percent$x, Mean_Monitor_Percent$y, col = 'red', lwd = 2, lty=2)
lines(Mean_Keyboard_Percent$x, Mean_Keyboard_Percent$y, col = 'green', lwd = 2, lty=3)
lines(Mean_Face_Percent$x, Mean_Face_Percent$y, col = 'purple', lwd = 2, lty=4)
lines(Mean_CompOnly_Percent$x, Mean_CompOnly_Percent$y, col = 'black', lwd = 2, lty=5)
lines(Mean_NoFace_Percent$x, Mean_NoFace_Percent$y, col = 'yellow', lwd = 2, lty=6)
legend(x="topright", 
       legend=c("Mean of Around Percent", "Mean of Monitor Percent","Mean of Keyboard Percent",
                "Mean of Face Percent", "Mean of CompOnly Percent", "Mean of NoFace Percent"),
       col=c("blue","red","green","purple","black","yellow"), lwd=1, lty=c(1,2,3,4,5,6), 
       pch=c(NA,NA)) 



#------Sum of Overall----------------------#
#individual map
Sum_Around_All <- density(H_talk_Type_2_sum$S_Around_Overall_Time) # returns the density data 
plot(Sum_Around_All,main = "Sum of Around All")

Sum_Monitor_All <- density(H_talk_Type_2_sum$S_Monitor_Overall_Time) # returns the density data 
plot(Sum_Monitor_All,main = "Sum of Monitor All")

Sum_Keyboard_All <- density(H_talk_Type_2_sum$S_Keyboard_Overall_Time) # returns the density data 
plot(Sum_Keyboard_All,main = "Sum of Keyboard All")

Sum_Face_All <- density(H_talk_Type_2_sum$S_Face_Overall_Time) # returns the density data 
plot(Sum_Face_All,main = "Sum of Face All")

Sum_CompOnly_All <- density(H_talk_Type_2_sum$S_CompOnly_Overall_Time) # returns the density data 
plot(Sum_CompOnly_All,main = "Sum of CompOnly All")

Sum_NoFace_All <- density(H_talk_Type_2_sum$S_NoFace_Overall_Time) # returns the density data 
plot(Sum_NoFace_All,main = "Sum of NoFace All")


#combined all 4 graph: around, monitor, keyboard, face
xlim <- range(H_talk_Type_2_sum$S_Around_Overall_Time,H_talk_Type_2_sum$S_Monitor_Overall_Time,
              H_talk_Type_2_sum$S_Keyboard_Overall_Time,H_talk_Type_2_sum$S_Face_Overall_Time)
ylim <- range(Sum_Around_All$y, Sum_Monitor_All$y, Sum_Keyboard_All$y, Sum_Face_All$y)
plot(Sum_Around_All$x, Sum_Around_All$y, col = 'blue', lwd = 2, lty=1, type = "l", 
     xlim = xlim, ylim = ylim,xlab = "Frames",ylab = "Density")
lines(Sum_Monitor_All$x, Sum_Monitor_All$y, col = 'red', lwd = 2, lty=3)
lines(Sum_Keyboard_All$x, Sum_Keyboard_All$y, col = 'green', lwd = 2, lty=4)
lines(Sum_Face_All$x, Sum_Face_All$y, col = 'purple', lwd = 2, lty=5)

legend(x="topright", 
       legend=c("Sum of Around All", "Sum of Monitor All","Sum of Keyboard All", "Sum of Face All"),
       col=c("blue","red","green","purple"), lwd=1, lty=c(1,3,4,5), 
       pch=c(NA,NA)) 


#combined all 6 graph: around, monitor, keyboard, face, componly, no face
xlim <- range(H_talk_Type_2_sum$S_Around_Overall_Time,H_talk_Type_2_sum$S_Monitor_Overall_Time,
              H_talk_Type_2_sum$S_Keyboard_Overall_Time,H_talk_Type_2_sum$S_Face_Overall_Time,
              H_talk_Type_2_sum$S_CompOnly_Overall_Time,H_talk_Type_2_sum$S_NoFace_Overall_Time)
ylim <- range(Sum_Around_All$y, Sum_Monitor_All$y, Sum_Keyboard_All$y, 
              Sum_Face_All$y, Sum_CompOnly_All$y, Sum_NoFace_All$y)
plot(Sum_Around_All$x, Sum_Around_All$y, col = 'blue', lwd = 2, lty=1, type = "l", 
     xlim = xlim, ylim = ylim,xlab = "Frames",ylab = "Density")
lines(Sum_Monitor_All$x, Sum_Monitor_All$y, col = 'red', lwd = 2, lty=2)
lines(Sum_Keyboard_All$x, Sum_Keyboard_All$y, col = 'green', lwd = 2, lty=3)
lines(Sum_Face_All$x, Sum_Face_All$y, col = 'purple', lwd = 2, lty=4)
lines(Sum_CompOnly_All$x, Sum_CompOnly_All$y, col = 'black', lwd = 2, lty=5)
lines(Sum_NoFace_All$x, Sum_NoFace_All$y, col = 'yellow', lwd = 2, lty=6)
legend(x="topright", 
       legend=c("Sum of Around All", "Sum of Monitor All","Sum of Keyboard All",
                "Sum of Face All", "Sum of CompOnly All", "Sum of NoFace All"),
       col=c("blue","red","green","purple","black","yellow"), lwd=1, lty=c(1,2,3,4,5,6), 
       pch=c(NA,NA)) 



#-----------Stat test-------#

testData <- cbind(Rapport_Data$hdyad,Rapport_Data$htechint,
                  Rapport_Data$hhogan,Rapport_Data$hboredom,Rapport_Data$hsdesirability,
                  Rapport_Data$shogan,Rapport_Data$sboredom,Rapport_Data$ssdesirability,
                  Rapport_Data$hpabad,Rapport_Data$hpabad2,Rapport_Data$hpagood,Rapport_Data$hpagood2,
                  Rapport_Data$spabad,Rapport_Data$spabad2,Rapport_Data$spagood,Rapport_Data$spagood2,
                  Rapport_Data$rapcomp2)
colnames(testData) <-c("dyad","techint","hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability",
                       "hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2")

#---Sum of Overall and all of the above 
combinedForSum <- merge(x=testData, y=H_talk_Type_2_sum, by.x='dyad', by.y='Group.1')

#3 dimension array row is the scale, column is the gaze, depth is stat result
# row: "hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability","hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2"
# column: around, monitor, keyboard, face, componly, no face
# depth: t-value, correlation, p-value
Result <- array(numeric(),c(15,6,3))
for (i in 3:17){
  for (j in 20:23){
    result <- cor.test(combinedForSum[,i],combinedForSum[,j], method = "pearson")
    Result[i-2,j-19,1] <-result$statistic #t-value  
    Result[i-2,j-19,2] <-result$estimate #corelation
    Result[i-2,j-19,3] <-result$p.value #p-value  
  }
  result <- cor.test(combinedForSum[,i],combinedForSum$S_CompOnly_Overall_Time, method = "pearson")
  Result[i-2,5,1] <-result$statistic #t-value  
  Result[i-2,5,2] <-result$estimate #corelation
  Result[i-2,5,3] <-result$p.value #p-value  

  result <- cor.test(combinedForSum[,i],combinedForSum$S_NoFace_Overall_Time, method = "pearson")
  Result[i-2,6,1] <-result$statistic #t-value  
  Result[i-2,6,2] <-result$estimate #corelation
  Result[i-2,6,3] <-result$p.value #p-value  

}
print (Result)
Sum_Overall <-Result


#---Mean of Percent and all of the above 
combinedForMean <- merge(x=testData, y=H_talk_Type_2_mean, by.x='dyad', by.y='Group.1')

#3 dimension array row is the scale, column is the gaze, depth is stat result
# row: "hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability","hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2"
# column: around, monitor, keyboard, face, componly, no face
# depth: t-value, correlation, p-value
Result <- array(numeric(),c(15,6,3))
for (i in 3:17){
  for (j in 107:110){
    result <- cor.test(combinedForMean[,i],combinedForMean[,j], method = "pearson")
    Result[i-2,j-106,1] <-result$statistic #t-value  
    Result[i-2,j-106,2] <-result$estimate #corelation
    Result[i-2,j-106,3] <-result$p.value #p-value  
  }
  result <- cor.test(combinedForMean[,i],combinedForMean$S_CompOnly_Percent, method = "pearson")
  Result[i-2,5,1] <-result$statistic #t-value  
  Result[i-2,5,2] <-result$estimate #corelation
  Result[i-2,5,3] <-result$p.value #p-value  
  
  result <- cor.test(combinedForMean[,i],combinedForMean$S_NoFace_Percent, method = "pearson")
  Result[i-2,6,1] <-result$statistic #t-value  
  Result[i-2,6,2] <-result$estimate #corelation
  Result[i-2,6,3] <-result$p.value #p-value  

}
print (Result)
Mean_Percent <-Result


#---Mean of Mean and all of the above 
combinedForMean <- merge(x=testData, y=H_talk_Type_2_mean, by.x='dyad', by.y='Group.1')

#3 dimension array row is the scale, column is the gaze, depth is stat result
# row: "hhogan","hboredom","hsdesirability","shogan","sboredom","ssdesirability","hpabad","hpabad2","hpagood","hpagood2","spabad","spabad2","spagood","spagood2","rapcomp2"
# column: around, monitor, keyboard, face,  no face, componly ################## different #######
# depth: t-value, correlation, p-value
Result <- array(numeric(),c(15,6,3))
for (i in 3:17){
  for (j in 24:29){
    result <- cor.test(combinedForMean[,i],combinedForMean[,j], method = "pearson")
    Result[i-2,j-23,1] <-result$statistic #t-value  
    Result[i-2,j-23,2] <-result$estimate #corelation
    Result[i-2,j-23,3] <-result$p.value #p-value  
  }
}
print (Result)
Mean_Mean <-Result


#####-----STOP HERE------#####



# compare the density together to test if they are similar to each other and draw the map again
group.index <- rep(1:6, c(length(H_talk_Type_2_mean$S_Around_Mean), length(H_talk_Type_2_mean$S_Monitor_Mean), 
                          length(H_talk_Type_2_mean$S_Keyboard_Mean),length(H_talk_Type_2_mean$S_Face_Mean),
                          length(H_talk_Type_2_mean$S_CompOnly_Mean),length(H_talk_Type_2_mean$S_NoFace_Mean)))
mean_of_mean <- sm.density.compare(c(H_talk_Type_2_mean$S_Around_Mean,H_talk_Type_2_mean$S_Monitor_Mean,
                                     H_talk_Type_2_mean$S_Keyboard_Mean,H_talk_Type_2_mean$S_Face_Mean,
                                     H_talk_Type_2_mean$S_CompOnly_Mean,H_talk_Type_2_mean$S_NoFace_Mean),
                                   group = group.index, model = "equal")



# compare the density together to test if they are similar to each other and draw the map again
group.index <- rep(1:6, c(length(H_talk_Type_2_mean$S_Around_Mean), length(H_talk_Type_2_mean$S_Monitor_Mean), 
                          length(H_talk_Type_2_mean$S_Keyboard_Mean),length(H_talk_Type_2_mean$S_Face_Mean),
                          length(H_talk_Type_2_mean$S_CompOnly_Mean),length(H_talk_Type_2_mean$S_NoFace_Mean)))
mean_of_mean <- sm.density.compare(c(H_talk_Type_2_mean$S_Around_Mean,H_talk_Type_2_mean$S_Monitor_Mean,
                                     H_talk_Type_2_mean$S_Keyboard_Mean,H_talk_Type_2_mean$S_Face_Mean,
                                     H_talk_Type_2_mean$S_CompOnly_Mean,H_talk_Type_2_mean$S_NoFace_Mean),
                                   group = group.index, model = "equal")



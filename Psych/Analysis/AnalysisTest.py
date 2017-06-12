import numpy as np
import AnalysisToolForSingleSet as ATS
import AnalysisToolForMultSets as AMS
import copy
from os import listdir, walk
from os.path import isfile, join, splitext
import csv
from scipy import stats

##will fo later
def KSTest(data, GoT):
	(x,y) = data.shape
	if GoT == 0: #0 is gaze
		KSD = np.zeros((6))
		KSp = np.zeros((6))
	else:
		KSD = np.zeros((7))
		KSp = np.zeros((7))
	i = 0
	while i < KSD.size - 2:
		setOfAction = countAction(data,[i+1])
		(KSD,KSp) = updateMeanMedSDFre(KSD,KSp,i,setOfAction)
		i= i+1 
	if GoT == 0:
		setOfAction = countAction(data,[1,2,3]) #no-face
		(KSD,KSp) = updateMeanMedSDFre(KSD,KSp,4,setOfAction)
		setOfAction = countAction(data,[2,3]) #comp time
		(KSD,KSp) = updateMeanMedSDFre(KSD,KSp,5,setOfAction)
	else:
		setOfAction = countAction(data,[3,4]) #sound
		(KSD,KSp) = updateMeanMedSDFre(KSD,KSp,5,setOfAction)
		setOfAction = countAction(data,[1,2,5]) #no sound
		(KSD,KSp) = updateMeanMedSDFre(KSD,KSp,6,setOfAction)
	return (KSD,KSp)

def TTestPaired(data, checkIndex, groupCompaired,startIndex,endIndex):
	x = len(data)
	group1 = []
	group2 = []
	(num1, num2) = groupCompaired

	i = 0
	while i < x:
		if data[i][checkIndex] == num1: 
			group1.append(data[i])
		elif data[i][checkIndex] == num2:
			group2.append(data[i])
		i = i + 1

	group1 = np.asarray(group1)
	group2 = np.asarray(group2)

	result = ()
	i = startIndex
	while i < endIndex:
		test1 = group1[:,i]
		test2 = group2[:,i]
		(t,p) = stats.ttest_rel(test1,test2)
		result = result + (np.mean(test1),np.mean(test2),t,p)
		i = i + 1
	result = np.asarray(result)
	
	return (result)
if __name__ == "__main__":

	Start = 0
	End = 9000
	SpeakType = ["NoSound_","Sound_"]
	GazeType = ["Around_","Monitor_","Keyboard_","Face_","NoFace_","CompOnly_"]
	Character = ["Mean","Median","PopularSD","Frequency","Max","Min"]
	inpath = "Input/"
	nameFiles = np.loadtxt("NameFileTest.txt", dtype = 'S')

	ori = ATS.getDiscriptiveData(inpath, Start, End, nameFiles, False)
	TTestPaired(ori, 1,(1,2),2,10)

	# GoT = 0
	# nameOutput1 = "Output/CombinedTwoLayer/DiscriptiveData_Gaze_Sound_5mins.csv"
	# title1 = getTitle(GoT,GazeType,SpeakType,Character)
	# ori1 = AMS.getDiscriptiveTwoTalkWithWidth(inpath, Start,End, nameFiles,False,9000,GoT)
	# ATS.printResult(ori1,title1,nameOutput1)	

	# nameOutput2 = "Output/CombinedTwoLayer/DiscriptiveData_Gaze_Sound_100secs.csv"
	# title2 = getTitle(GoT,GazeType,SpeakType,Character)
	# ori2 = AMS.getDiscriptiveTwoTalkWithWidth(inpath, Start,End, nameFiles,False,3000,GoT)
	# ATS.printResult(ori2,title2,nameOutput2)	

	# GoT = 1
	# nameOutput3 = "Output/CombinedTwoLayer/DiscriptiveData_Sound_Gaze_5mins.csv"
	# title3 = getTitle(GoT,GazeType,SpeakType,Character)
	# ori3 = AMS.getDiscriptiveTwoTalkWithWidth(inpath, Start,End, nameFiles,False,9000,GoT)
	# ATS.printResult(ori3,title3,nameOutput3)	

	# nameOutput4 = "Output/CombinedTwoLayer/DiscriptiveData_Sound_Gaze_100secs.csv"
	# title4 = getTitle(GoT,GazeType,SpeakType,Character)
	# ori4 = AMS.getDiscriptiveTwoTalkWithWidth(inpath, Start,End, nameFiles,False,3000,GoT)
	# ATS.printResult(ori4,title4,nameOutput4)	




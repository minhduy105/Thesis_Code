import numpy as np
import AnalysisToolForSingleSet as ATS
import AnalysisToolForMultSets as AMS
import copy

def getTitle(GoT,GazeType,SpeakType,Character):
	i = 0
	if GoT == 0:
		title = ["Dyad","Cov","SectionStartTime","GazeID","Start","End","Duration","GazeType"]
		while i < 2:
			title.append("S+H_" + SpeakType[i] + "Overall_Time")
			i = i + 1 
		for j in Character:
			for i in SpeakType:
				title.append("S+H_" + i + j)	
		
	else: 
		title = ["Dyad","Cov","SectionStartTime","SoundID","Start","End","Duration","SoundType"]

		while i < 4:
			title.append("S_"+GazeType[i] + "Overall_Time")
			i = i + 1 
		for j in Character:
			for i in GazeType:
				title.append("S_" + i + j)	
	
	return title	

if __name__ == "__main__":

	Start = 0
	End = 9000
	SpeakType = ["NoSound_","Sound_"]
	GazeType = ["Around_","Monitor_","Keyboard_","Face_","NoFace_","CompOnly_","BodyOnly_"]
	Character = ["Mean","Median","PopularSD","Frequency","Max","Min"]
	inpath = "Input/"
	nameFiles = np.loadtxt("NameFile.txt", dtype = 'S')


	GoT = 0
	nameOutput1 = "Output/CombinedTwoLayer/DiscriptiveData_Gaze_Sound_5mins.csv"
	title1 = getTitle(GoT,GazeType,SpeakType,Character)
	ori1 = AMS.getDiscriptiveTwoTalkWithWidth(inpath, Start,End, nameFiles,False,9000,GoT)
	ATS.printResult(ori1,title1,nameOutput1)	

	nameOutput2 = "Output/CombinedTwoLayer/DiscriptiveData_Gaze_Sound_100secs.csv"
	title2 = getTitle(GoT,GazeType,SpeakType,Character)
	ori2 = AMS.getDiscriptiveTwoTalkWithWidth(inpath, Start,End, nameFiles,False,3000,GoT)
	ATS.printResult(ori2,title2,nameOutput2)	

	GoT = 1
	nameOutput3 = "Output/CombinedTwoLayer/DiscriptiveData_Sound_Gaze_5mins.csv"
	title3 = getTitle(GoT,GazeType,SpeakType,Character)
	ori3 = AMS.getDiscriptiveTwoTalkWithWidth(inpath, Start,End, nameFiles,False,9000,GoT)
	ATS.printResult(ori3,title3,nameOutput3)	

	nameOutput4 = "Output/CombinedTwoLayer/DiscriptiveData_Sound_Gaze_100secs.csv"
	title4 = getTitle(GoT,GazeType,SpeakType,Character)
	ori4 = AMS.getDiscriptiveTwoTalkWithWidth(inpath, Start,End, nameFiles,False,3000,GoT)
	ATS.printResult(ori4,title4,nameOutput4)	



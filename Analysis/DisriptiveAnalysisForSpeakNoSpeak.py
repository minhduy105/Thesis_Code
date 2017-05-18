import numpy as np
import AnalysisToolForSingleSet as ATS
import AnalysisToolForMultSets as AMS
import copy

def getTitle(Title,GazeType,SpeakType,PersonTile,Character):
	title = copy.deepcopy(Title)
	i = 0
	while i < 4:
		title.append("S_"+GazeType[i] + "Overall_Time")
		i = i + 1 
	for j in Character:
		for i in GazeType:
			title.append("S_" + i + j)	

	z = PersonTile		
	i = 0
	while i < 5:
		title.append( z +SpeakType[i] + "Overall_Time")
		i = i + 1 
	for j in Character:
		for i in SpeakType:
			title.append(z + i + j)	
	return title	

if __name__ == "__main__":

	Start = 0
	End = 50
	SpeakType = ["NoSpeak_","Typing_","Speaking_","SSS_","Hovering_","Sound_","NoSound_"]
	GazeType = ["Around_","Monitor_","Keyboard_","Face_","NoFace_","CompOnly_"]
	Character = ["Mean","Median","PopularSD","Frequency","Max","Min"]
	inpath = "Input/"
	nameFiles = np.loadtxt("NameFileTest.txt", dtype = 'S')
	title = ["Dyad","Cov","SectionStartTime","TalkID","Start","End","Duration","TalkType"]

	# TalkType = (1,2,3,4,5)
	# Person = "H"
	# PersonTile = "S_"

	ori1 = AMS.getDiscriptiveTwoTalkWithWidth(inpath, Start,End, nameFiles,False, 20)


	# nameOutput1 = "Output/CombinedOneLayer/Talk/DiscriptiveData_5talks_H_5mins.csv"
	# title1 = getTitle(title,GazeType,SpeakType,PersonTile,Character)
	# ori1 = AMS.getDiscriptiveTalkWithWidth(inpath, Start,End, nameFiles,False, 9000,TalkType,Person)
	# ATS.printResult(ori1,title1,nameOutput1)	

	# nameOutput2 = "Output/CombinedOneLayer/Talk/DiscriptiveData_5talks_H_100sec.csv"
	# title2 =  getTitle(title,GazeType,SpeakType,PersonTile,Character)
	# ori2 = AMS.getDiscriptiveTalkWithWidth(inpath, Start, End, nameFiles, False,3000,TalkType,Person)
	# ATS.printResult(ori2,title2,nameOutput2)	

	# Person = "S"
	# PersonTile = "H_"

	# nameOutput3 = "Output/CombinedOneLayer/Talk/DiscriptiveData_S_5mins.csv"
	# title3 = getTitle(title,GazeType,SpeakType,PersonTile,Character)
	# ori3 = AMS.getDiscriptiveTalkWithWidth(inpath, Start,End, nameFiles,False, 9000,TalkType,Person)
	# ATS.printResult(ori3,title3,nameOutput3)	

	# nameOutput4 = "Output/CombinedOneLayer/Talk/DiscriptiveData_S_100sec.csv"
	# title4 =  getTitle(title,GazeType,SpeakType,PersonTile,Character)
	# ori4 = AMS.getDiscriptiveTalkWithWidth(inpath, Start, End, nameFiles, False,3000,TalkType,Person)
	# ATS.printResult(ori4,title4,nameOutput4)	


	# TalkType = (6,7)
	# Person = "H"
	# PersonTile = "S_"

	# nameOutput5 = "Output/CombinedOneLayer/Talk/DiscriptiveData_2talks_H_5mins.csv"
	# title5 = getTitle(title,GazeType,SpeakType,PersonTile,Character)
	# ori5 = AMS.getDiscriptiveTalkWithWidth(inpath, Start,End, nameFiles,False, 9000,TalkType,Person)
	# ATS.printResult(ori5,title5,nameOutput5)	

	# nameOutput6 = "Output/CombinedOneLayer/Talk/DiscriptiveData_2talks_H_100sec.csv"
	# title6 =  getTitle(title,GazeType,SpeakType,PersonTile,Character)
	# ori6 = AMS.getDiscriptiveTalkWithWidth(inpath, Start, End, nameFiles, False,3000,TalkType,Person)
	# ATS.printResult(ori6,title6,nameOutput6)	

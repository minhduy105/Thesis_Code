import numpy as np
import AnalysisToolForSingleSet as ATS
import AnalysisToolForMultSets as AMS
import copy

def getTitle(Title,SpeakType,Person,Character):
	title = copy.deepcopy(Title)	
	i = 0
	for z in Person:
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
	End = 9000
	SpeakType = ["NoSpeak_","Typing_","Speaking_","SSS_","Hovering_","Sound_","NoSound_"]
	Person = ["H_","S_"]
	Character = ["Mean","Median","PopularSD","Frequency","Max","Min"]
	inpath = "Input/"
	nameFiles = np.loadtxt("NameFile.txt", dtype = 'S')
	title = ["Dyad","Cov","SectionStartTime","GazeID","Start","End","Duration","GazeType"]

	GazeType = (1,2,3,4)

	nameOutput1 = "Output/CombinedOneLayer/Gaze/DiscriptiveData_4gazes_5mins.csv"
	title1 = getTitle(title,SpeakType,Person,Character)
	ori1 = AMS.getDiscriptiveGazeWithWidth(inpath, Start, End, nameFiles, False,9000,GazeType)
	ATS.printResult(ori1,title1,nameOutput1)	

	nameOutput2 = "Output/CombinedOneLayer/Gaze/DiscriptiveData_4gazes_100sec.csv"
	title2 = getTitle(title,SpeakType,Person,Character)
	ori2 = AMS.getDiscriptiveGazeWithWidth(inpath, Start, End, nameFiles, False,3000,GazeType)
	ATS.printResult(ori2,title2,nameOutput2)	

	GazeType = (4,5)

	nameOutput3 = "Output/CombinedOneLayer/Gaze/DiscriptiveData_2gazes_5mins.csv"
	title3 = getTitle(title,SpeakType,Person,Character)
	ori3 = AMS.getDiscriptiveGazeWithWidth(inpath, Start, End, nameFiles, False,9000,GazeType)
	ATS.printResult(ori3,title3,nameOutput3)	

	nameOutput4 = "Output/CombinedOneLayer/Gaze/DiscriptiveData_2gazes_100sec.csv"
	title4 = getTitle(title,SpeakType,Person,Character)
	ori4 = AMS.getDiscriptiveGazeWithWidth(inpath, Start, End, nameFiles, False,3000,GazeType)
	ATS.printResult(ori4,title4,nameOutput4)	

	GazeType = (1,4,5)

	nameOutput5 = "Output/CombinedOneLayer/Gaze/DiscriptiveData_3gazes_5mins.csv"
	title5 = getTitle(title,SpeakType,Person,Character)
	ori5 = AMS.getDiscriptiveGazeWithWidth(inpath, Start, End, nameFiles, False,9000,GazeType)
	ATS.printResult(ori5,title5,nameOutput5)	

	nameOutput6 = "Output/CombinedOneLayer/Gaze/DiscriptiveData_3gazes_100sec.csv"
	title6 = getTitle(title,SpeakType,Person,Character)
	ori6 = AMS.getDiscriptiveGazeWithWidth(inpath, Start, End, nameFiles, False,3000,GazeType)
	ATS.printResult(ori6,title6,nameOutput6)	

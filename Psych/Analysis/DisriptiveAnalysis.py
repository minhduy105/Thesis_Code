import numpy as np
import AnalysisToolForSingleSet as AT
import copy

def getTitle(Title,GazeType,SpeakType,Person,Character):
	title = copy.deepcopy(Title)
	i = 0
	while i < 4:
		title.append("S_"+GazeType[i] + "Overall_Time")
		i = i + 1 
	for j in Character:
		for i in GazeType:
			title.append("S_" + i + j)	

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
	GazeType = ["Around_","Monitor_","Keyboard_","Face_","NoFace_","CompOnly_","BodyOnly_"]
	SpeakType = ["NoSpeak_","Typing_","Speaking_","SSS_","Hovering_","Sound_","NoSound_"]
	Person = ["H_","S_"]
	Character = ["Mean","Median","PopularSD","Frequency","Max","Min"]
	inpath = "Input/"
	nameFiles = np.loadtxt("NameFile.txt", dtype = 'S')
	print nameFiles

	title1 = ["Dyad","Cov"]
	nameOutput1 = "Output/DiscriptiveData_5mins.csv"
	title1 = getTitle(title1,GazeType,SpeakType,Person,Character)
	ori1 = AT.getDiscriptiveData(inpath, Start, End, nameFiles, False)
	AT.printResult(ori1,title1,nameOutput1)	

	title2 = ["Dyad","Cov","StartFrame"]
	nameOutput2 = "Output/DiscriptiveData_100secs.csv"
	title2 = getTitle(title2,GazeType,SpeakType,Person,Character)
	ori2 = AT.getDiscriptiveDataWithWidth(inpath, Start, End, nameFiles, False,3000)
	AT.printResult(ori2,title2,nameOutput2)
	
	title3 = ["Dyad","Cov","StartFrame"]
	nameOutput3 = "Output/DiscriptiveData_60secs.csv"
	title3 = getTitle(title3,GazeType,SpeakType,Person,Character)
	ori3 = AT.getDiscriptiveDataWithWidth(inpath, Start, End, nameFiles, False,1800)
	AT.printResult(ori3,title3,nameOutput3)

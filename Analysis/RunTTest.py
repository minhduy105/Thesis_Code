import numpy as np
import AnalysisToolForSingleSet as AST
import AnalysisTest as ST
import copy
import csv
def addMeanTP(title,name):
	i = 0
	title.append(name + "_Mean_Con1")
	title.append(name + "_Mean_Con2")
	title.append(name + "_T")
	title.append(name + "_p") 
	return title

def getTitle(GazeType,SpeakType,Person,Character):
	title = []
	i = 0
	while i < 4:
		name = "S_"+GazeType[i] + "Overall_Time"
		title = addMeanTP(title,name)
		i = i + 1 
	for j in Character:
		for i in GazeType:
			name = "S_" + i + j
			title = addMeanTP(title,name)

	for z in Person:
		i = 0
		while i < 5:
			name = z +SpeakType[i] + "Overall_Time"
			title = addMeanTP(title,name)

			i = i + 1 
		for j in Character:
			for i in SpeakType:
				name = z + i + j
				title = addMeanTP(title,name)	
	return title	

if __name__ == "__main__":
	Start = 0
	End = 9000
	GazeType = ["Around_","Monitor_","Keyboard_","Face_","NoFace_","CompOnly_"]
	SpeakType = ["NoSpeak_","Typing_","Speaking_","SSS_","Hovering_","Sound_","NoSound_"]
	Person = ["H_","S_"]
	Character = ["Mean","Median","PopularSD","Frequency","Max","Min"]
	inpath = "Input/"
	nameFiles = np.loadtxt("NameFile.txt", dtype = 'S')
	print nameFiles


	nameOutput1 = "Output/TTestData_5mins.csv"
	title1 = getTitle(GazeType,SpeakType,Person,Character)
	ori1 = AST.getDiscriptiveData(inpath, Start, End, nameFiles, False)

	checkIndex = 1
	groupCompaired = (1,2)
	startIndex = 2 
	endIndex = len(ori1[0])

	result1 = ST.TTestPaired(ori1,checkIndex, groupCompaired,startIndex,endIndex).tolist()


	data = []
	data.append(title1)
	data.append(result1)

	with open(nameOutput1, "wb") as t:
		writer = csv.writer(t)
		writer.writerows(data)


	# title2 = ["Dyad","Cov","StartFrame"]
	# nameOutput2 = "Output/DiscriptiveData_100secs.csv"
	# title2 = getTitle(title2,GazeType,SpeakType,Person,Character)
	# ori2 = AT.getDiscriptiveDataWithWidth(inpath, Start, End, nameFiles, False,3000)
	# AT.printResult(ori2,title2,nameOutput2)
	
	# title3 = ["Dyad","Cov","StartFrame"]
	# nameOutput3 = "Output/DiscriptiveData_60secs.csv"
	# title3 = getTitle(title3,GazeType,SpeakType,Person,Character)
	# ori3 = AT.getDiscriptiveDataWithWidth(inpath, Start, End, nameFiles, False,1800)
	# AT.printResult(ori3,title3,nameOutput3)

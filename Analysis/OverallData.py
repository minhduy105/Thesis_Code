import numpy as np
import AnalysisTool as AT

if __name__ == "__main__":
	# should have more varriable REMEMBER: DON'T CHANGE THIS CODE FIRST, CHANGE THE CODE FOR CONVERTING DATA FROM SRT TO SVN FIRST IF YOU DECIDE TO COMBINING CATEGORIES
	
	Start = 0
	End = 9000
	inpath = "Input/"
	nameFiles = np.loadtxt("NameFile.txt", dtype = 'S')
	print nameFiles

	title = ["Dyad","Cov","Time","Gaze","Talking Hawking", "Talking Shake"]
	
	ori1 = AT.getOverallResult(inpath, Start, End, nameFiles, False)
	name = "Output/OverallData_EndTime_5min.csv"
	AT.printResult(ori1,title,name)

	ori1 = AT.getOverallResult(inpath, Start, End, nameFiles, True)
	name = "Output/OverallData_EndTime_Actual.csv"
	AT.printResult(ori1,title,name)



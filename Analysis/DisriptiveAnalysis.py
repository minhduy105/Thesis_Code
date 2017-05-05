import numpy as np
import AnalysisTool as AT

if __name__ == "__main__":
	
	Start = 0
	End = 200
	inpath = "Input/"
	nameFiles = np.loadtxt("NameFile.txt", dtype = 'S')
	print nameFiles

	title = ["Dyad","Cov","Time","Gaze","Talking Hawking", "Talking Shake"]
	
	ori1 = AT.getDiscriptiveData(inpath, Start, End, nameFiles, False)


	name = "Output/OverallData_EndTime_5min.csv"



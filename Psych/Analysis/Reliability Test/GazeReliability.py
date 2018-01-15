import AnalysisToolForSingleSet as AT
import CoderAgreement as CA

if __name__ == "__main__":
	inpath = "InRe/Gaze/" #double slash because codec is difference
	Start = 0
	End = 9000
	GoTSize = 4

	ori = CA.getReliability(inpath,Start,End,GoTSize)	
	title = ["Dyad","Cov","Coder","Time","Gaze"]
	name = "Output/Reliability_Data_Gaze_5min.csv"
	AT.printResult(ori,title,name)

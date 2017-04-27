import AnalysisTool as AT
import CoderAgreement as CA

if __name__ == "__main__":
	inpath = "InRe/Talking/Hawking/" #double slash because codec is difference
	Start = 0
	End = 9000
	GoTSize = 5

	ori = CA.getReliability(inpath,Start,End,GoTSize)	
	title = ["Dyad","Cov","Coder","Time","talking"]
	name = "Output/Reliability_Data_Talking_Hawking_5min.csv"
	AT.printResult(ori,title,name)

	inpath = "InRe/Talking/Shake/" #double slash because codec is difference

	ori = CA.getReliability(inpath,Start,End,GoTSize)	
	name = "Output/Reliability_Data_Talking_Shakespear_5min.csv"
	AT.printResult(ori,title,name)

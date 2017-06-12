import convertXML as XTR #XML to RAW

if __name__ == "__main__":
	inpath = "Data/Talking/XML/" #double slash because codec is difference
	outpath1 = "Data/Talking/CSV/Simple/"
	outpath2 = "Data/Talking/CSV/Expand/"
	codeID = 1 #gaze
	splitNum = 17
	XTR.ReadXMLFile(inpath,outpath1,outpath2,codeID,splitNum)



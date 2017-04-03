import convertXML as XTR #XML to RAW

if __name__ == "__main__":
	inpath = "Data/Gaze/XML/" #double slash because codec is difference
	outpath1 = "Data/Gaze/CSV/Simple/"
	outpath2 = "Data/Gaze/CSV/Expand/"
	codeID = 0 #gaze
	splitNum = 14
	XTR.ReadXMLFile(inpath,outpath1,outpath2,codeID,splitNum)



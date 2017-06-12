import convertXML as XTR


if __name__ == "__main__":
	inpath = "DataRe/Talking/XML/" #double slash because codec is difference
	outpath1 = "DataRe/Talking/CSV/"
	outpath2 = outpath1
	codeID = 1 #gaze
	splitNum = 17

	# FOR GAZE
	# inpath = "DataRe/Gaze/XML/" #double slash because codec is difference
	# outpath1 = "DataRe/Gaze/CSV/"
	# outpath2 = outpath1
	# codeID = 0 #gaze
	# splitNum = 14

	XTR.ReadXMLFile(inpath,outpath1,outpath2,codeID,splitNum, Acc = True)	

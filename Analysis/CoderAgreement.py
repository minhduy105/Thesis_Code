import numpy as np
from os import listdir, walk
from os.path import isfile, join, splitext
import AnalysisTool as AT

def getCoderName(data):
	coderName = "99"
	if "AS" in data:
		coderName = "00"
	elif "HH" in data:
		coderName = "01"
	elif "LC" in data:
		coderName = "02"
	elif "MC" in data:
		coderName = "03"
	elif "RS" in data:
		coderName = "04"
	elif "UN" in data:
		coderName = "05"
	elif "SB" in data:
		coderName = "06"
	elif "AF" in data:
		coderName = "07"
	elif "HH" in data:
		coderName = "08"
	elif "MS" in data:
		coderName = "09"
	elif "WI" in data:
		coderName = "10"
	return coderName

def bestOfCoderTag(BoC, data, coder, End):
	for row in data:
		if coder == 0 or coder == 9:
			BoC[int(row[0])][int(row[1])-1] += 1.2
		elif coder == 1 or coder == 10:
			BoC[int(row[0])][int(row[1])-1] +=1.1
		else:
			BoC[int(row[0])][int(row[1])-1] += 1
	return BoC

def getBestOfCoderTag (BoC, End):
	data = np.zeros((End,1))
	i = 0
	while i < End:
		data[i] = BoC[i].argmax() + 1
		i += 1
	return data	

def getDyadCovCoderInfor(dyad,conv,coder,End):
	beg = np.ones((End, 3))
	dot_value = np.asarray([[dyad,0,0],[0,conv,0],[0,0,coder]])
	beg = np.dot(beg,dot_value)
	time = np.arange(End).reshape([End,1])
	beg = np.c_[beg,time]
	return beg

def getReliability(inpath,Start,End,GoTSize):
	BoC = np.zeros((End,GoTSize),dtype = np.float64) #best of coder
	ori = []

	for i in ["52","65","79"]:
		for j in ["C1" ,"C2"]:
			for root, dirs, files in walk(inpath):
				BoC = np.zeros((End,GoTSize),dtype = np.float64) #best of coder		
				for file in files:
					if file.endswith(".csv"):
						if i in file and j in file:
							print (file)
							nameOutput = file 
							data = np.genfromtxt( join(root, file), dtype = np.float64, delimiter=',')
							dyad = int(splitext(file)[0][2:4])
							conv = int(splitext(file)[0][6:7])
							coder = int(getCoderName(splitext(file)[0][15:17]))
							beg = getDyadCovCoderInfor(dyad,conv,coder,End) #beg is begining
							
							data = AT.shortenData(data,Start,End)
							combData = AT.combineData(beg,data,End) 
							ori.extend(combData)
							BoC = bestOfCoderTag(BoC, data, coder,End)
						
				data = getBestOfCoderTag(BoC,End)
				beg = getDyadCovCoderInfor(dyad,conv,105,End)
				combData = np.c_[beg,data]
				ori.extend(combData)

				time = np.arange(End).reshape([End,1])
				output = np.c_[time,data]
				np.savetxt(nameOutput + "_combined.csv", output, fmt='%1.3f',delimiter=',' )
	return ori	


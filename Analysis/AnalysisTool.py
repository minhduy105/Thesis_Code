import numpy as np
from os import listdir, walk
from os.path import isfile, join, splitext
import csv


def shortenData (data, start, end): #shorten the data and at the start and end point 
	i = 0 
	(x,y) = data.shape
	checkS = True
	result = []
	while i < x and data[i][0] < end:
		if data[i][0] >= start and data[i][0] < end : 
			result.append(data[i])
		i = i + 1
	if i < end:
		while i < end:
			result.append([i,data[x-1][1]])
			i = i + 1	
	return np.array(result) 


def combineData(data1,data2,End): #use merge sort 
	result = np.c_[data1,data2[:,1]]
	return result


def printResult(data,title,name):
	data.reverse()
	data.append(title)
	data.reverse()
	with open(name, "wb") as t:
		writer = csv.writer(t)
		writer.writerows(data)

# when DynEnd is True, the End value is dynamic and changing
def getOverallResult(inpath, Start, End, nameFiles, DynEnd):
	ori = []

	for nameFile in nameFiles:
		for i in [1,2]:
			dataTH = np.genfromtxt( inpath + "D" + nameFile + "_C" + str(i) + "_TALKING_H_exp.csv", dtype = np.float64, delimiter=',')
			dataTS = np.genfromtxt( inpath + "D" + nameFile + "_C" + str(i) + "_TALKING_S_exp.csv", dtype = np.float64, delimiter=',')
			dataG = np.genfromtxt( inpath + "D" + nameFile + "_C" + str(i) + "_GAZE_S_exp.csv", dtype = np.float64, delimiter=',')

			dataTH = dataTH.astype(int) # convert from float to int
			dataTS = dataTS.astype(int)
			dataG = dataG.astype(int)

			if DynEnd: #using dynamic ending 
				(yTH, xTH) = (dataTH.shape)
				(yTS, xTS) = (dataTS.shape)
				(yG, xG) = (dataG.shape)
				End = np.amin(np.asarray([yTH,yTS,yG])) #get the actual end time

			beg = np.ones((End, 2))
			dot_value = np.asarray([[int(nameFile),0],[0,i]])
			beg = np.dot(beg,dot_value)

			time = np.arange(End).reshape([End,1])
			beg = np.c_[beg,time]

			dataTH = shortenData(dataTH,Start,End)
			dataTS = shortenData(dataTS,Start,End)
			dataG = shortenData(dataG,Start,End)

			dataG = combineData(beg,dataG,End)
			dataGTH  = combineData(dataG,dataTH,End)
			dataGTHS  = combineData(dataGTH,dataTS,End)
			ori.extend(dataGTHS)

	return ori

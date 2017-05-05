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

#index is for conversation 1 or 2
def readInput(inpath, nameFile, index):
	dataTH = np.genfromtxt( inpath + "D" + nameFile + "_C" + str(index) + "_TALKING_H_exp.csv", dtype = np.float64, delimiter=',')
	dataTS = np.genfromtxt( inpath + "D" + nameFile + "_C" + str(index) + "_TALKING_S_exp.csv", dtype = np.float64, delimiter=',')
	dataG = np.genfromtxt( inpath + "D" + nameFile + "_C" + str(index) + "_GAZE_S_exp.csv", dtype = np.float64, delimiter=',')

	dataTH = dataTH.astype(int) # convert from float to int
	dataTS = dataTS.astype(int)
	dataG = dataG.astype(int)
	return (dataTH, dataTS, dataG)


# when DynEnd is True, the End value is dynamic and changing
def getOverallResult(inpath, Start, End, nameFiles, DynEnd):
	ori = []

	for nameFile in nameFiles:
		for i in [1,2]:
			(dataTH, dataTS, dataG) = readInput(inpath, nameFile,i)

			if DynEnd: #using dynamic ending 
				(yTH, xTH) = (dataTH.shape)
				(yTS, xTS) = (dataTS.shape)
				(yG, xG) = (dataG.shape)
				End = np.amin(np.asarray([yTH,yTS,yG])) #get the actual end time

			#creating the dayd number, 
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

#using the shorten data
def getTotalAction(data, GoT):
	(x,y) = data.shape
	if GoT == 0: #0 is gaze
		cout = np.zeros((4))
	else:
		cout = np.zeros((5))
	i = 0
	while i < x:
		cout[data[i][1]-1] = cout[data[i][1]-1] + 1
		i= i+1
	return cout


def countAction(data, actionArr):
	(x,y) = data.shape
	count = 0
	out = []
	i = 0 
	check = False # stop the function to continue adding elements
	while i < x:
		if data[i][1] in actionArr:
			count = count + 1
			check = True
			if i == x-1:#adding the last element
				out.append(count)
		elif check and data[i][1] not in actionArr:
			out.append(count)
			count = 0
			check = False
		i = i + 1
	return out

# added sound/no-sound and no-face/comp-time
def getMean(data, GoT):
	(x,y) = data.shape
	if GoT == 0: #0 is gaze
		cout = np.zeros((6))
	else:
		cout = np.zeros((7))
	i = 0
	while i < cout.size - 2 :
		cout[i] = np.mean(countAction(data,[i+1])) 			
		i= i+1 
	if GoT == 0:
		cout[4] = np.mean(countAction(data,[1,2,3]))
		cout[5] = np.mean(countAction(data,[2,3]))
	else:
		cout[5] = np.mean(countAction(data,[3,4]))
		cout[6] = np.mean(countAction(data,[1,2,5]))
	return cout

	
# added sound/no-sound and no-face/comp-time
def getSD(data,GoT):
	return 

# added sound/no-sound and no-face/comp-time
def getFrequency(data,GoT): #which is size of countAction
	return 

# do KS test 


def getDiscriptiveData(inpath, Start,End, nameFiles, DynEnd):
	ori = []
	print len(nameFiles)
	for nameFile in nameFiles:
		for i in [1,2]:
			(dataTH, dataTS, dataG) = readInput(inpath, nameFile,i)

			if DynEnd: #using dynamic ending 
				(yTH, xTH) = (dataTH.shape)
				(yTS, xTS) = (dataTS.shape)
				(yG, xG) = (dataG.shape)
				End = np.amin(np.asarray([yTH,yTS,yG])) #get the actual end time

			dataTH = shortenData(dataTH,Start,End)
			dataTS = shortenData(dataTS,Start,End)
			dataG = shortenData(dataG,Start,End)
			
			#get the percentage in 2 decimals 		
			TotalAct = np.around((getTotalAction(dataG, 0)*100.0/(End-Start)), decimals = 2)
			TotalMean = getMean(dataG, 0)
	
import numpy as np
import AnalysisToolForSingleSet as ATS
import AnalysisToolForMultSets as ATM
from os import listdir, walk
from os.path import isfile, join, splitext
import csv
from scipy import stats


def countTalking(data):
	turn = 0 
	speak = [3,4]
	(x,y) = data.shape
	count = 0
	wait = 0
	out = []
	i = 0 

	while i < x:
		if data[i][1] in speak:
			turn = 1 
			if wait > 0:
				count = count + wait
				wait = 0 
			count = count + 1
			if i == x-1:#adding the last element
				out.append(count)
		else: 
			if turn == 1: 
				wait = wait + 1 
		if count > 0 and data[i][2] in speak and data[i][1] not in speak:
			turn = 0
			out.append(count)
			count = 0
			wait = 0
		i = i + 1

	return out

def countTalkingWithWaitMoreThan3Second(data):
	turn = 0 
	addToList = False
	speak = [3,4]
	(x,y) = data.shape
	count = 0
	wait = 0
	out = []
	i = 0 
	while i < x:
		if data[i][1] in speak:
			turn = 1 
			if wait > 0:
				count = count + wait
				if wait > 90:
					addToList = True
				wait = 0 
			count = count + 1
			if i == x-1:#adding the last element
				if addToList:
					out.append(count)
		else: 
			if turn == 1: 
				wait = wait + 1 
		if count > 0 and data[i][2] in speak and data[i][1] not in speak:
			turn = 0
			if addToList:
				out.append(count)
				addToList = False
			count = 0
			wait = 0
		i = i + 1
	return out

# added sound/no-sound and no-face/comp-time
def updateMeanMedSDFreMaxMin (desData,setOfAction):
	#calculate the mean, median, std, and frequency of the set of actions
	(mean,median,std,fre,maxi,mini) = desData
	if setOfAction:
		mean = np.mean(setOfAction) 
		# in case the data is non parametric
		median = np.median(setOfAction)		
		#using sample sd 	
		#std[index] = np.std(setOfAction,ddof=1) 
		
		#using population sd
		std = np.std(setOfAction)
		fre = len(setOfAction)
		maxi = np.amax(setOfAction)
		mini = np.amin(setOfAction)
	return (mean,median,std,fre,maxi,mini)

def getMeanMedSDFreMaxMin(data,funct):
	#get the mean median sd and frequency in the set of data
	(x,y) = data.shape
	mean = 0.0
	median = 0.0
	std = 0.0
	fre = 0.0
	maxi = 0.0
	mini = 0.0

	desData = (mean,median,std,fre,maxi,mini)
	setOfAction = funct(data)
	desData = updateMeanMedSDFreMaxMin(desData,setOfAction)
	
	return desData


def readInput(inpath, nameFile, index):
	#read the input from a file
	#index is for conversation 1 or 2
	dataTH = np.genfromtxt( inpath + "D" + nameFile + "_C" + str(index) + "_TALKING_H_exp.csv", dtype = np.float64, delimiter=',')
	dataTS = np.genfromtxt( inpath + "D" + nameFile + "_C" + str(index) + "_TALKING_S_exp.csv", dtype = np.float64, delimiter=',')

	dataTH = dataTH.astype(int) # convert from float to int
	dataTS = dataTS.astype(int)
	return (dataTH, dataTS)


def updateDiscriptiveData(ori,data):
	#update the discriptive information
	#2D array data with frame and type of actions
	countMethod = [countTalking,countTalkingWithWaitMoreThan3Second]
	for f in countMethod:
		(TotalMean,TotalMedian,TotalSD,TotalFre,TotalMax,TotalMin) = getMeanMedSDFreMaxMin(data,f)
		ori.append(TotalMean)
		ori.append(TotalMedian)
		ori.append(TotalSD)
		ori.append(TotalFre)
		ori.append(TotalMax)
		ori.append(TotalMin)
	return ori

def getDiscriptiveData(inpath, Start,End, nameFiles, DynEnd):
	#get discription information of the data
	ori = []
	for nameFile in nameFiles:
		print (nameFile)
		for i in [1,2]:
			data = []
			data.append(int(nameFile))
			data.append(i)

			(dataTH, dataTS) = readInput(inpath, nameFile,i)
			if DynEnd: #using dynamic ending 
				(yTH, xTH) = (dataTH.shape)
				(yTS, xTS) = (dataTS.shape)
				End = np.amin(np.asarray([yTH,yTS])) #get the actual end time

			dataTH = ATS.shortenData(dataTH,Start,End)
			dataTS = ATS.shortenData(dataTS,Start,End)

			data = updateDiscriptiveData(data,ATS.combineData(dataTS,dataTH,End)) #update Shakespeare talking
			data = updateDiscriptiveData(data,ATS.combineData(dataTH,dataTS,End)) #update Shakespeare talking

			data = ATS.updateDiscriptiveData(data,dataTS,1) #update Shakespear talking
			data = ATS.updateDiscriptiveData(data,dataTH,1) #update Hawking talking
			ori.append(data)
	return ori

def getDiscriptiveDataWithWidth(inpath, Start,End, nameFiles, DynEnd, Width):
	#get discription information of the data
	#width mean how long do you want to check the characteristics

	ori = []
	for nameFile in nameFiles:
		print (nameFile)
		for i in [1,2]:
			
			(dataTHroot, dataTSroot) = readInput(inpath, nameFile,i)
			if DynEnd: #using dynamic ending 
				(yTH, xTH) = (dataTHroot.shape)
				(yTS, xTS) = (dataTSroot.shape)
				End = np.amin(np.asarray([yTH,yTS])) #get the actual end time
			dataTHroot = ATS.shortenData(dataTHroot,Start,End)
			dataTSroot = ATS.shortenData(dataTSroot,Start,End)
									
			j = 0

			print dataTHroot
			print dataTSroot
			while j < End:		
				data = []
				data.append(int(nameFile))
				data.append(i)
				data.append(j)
				
				startSub = j
				if j+Width > End:
					endSub = End 
				else:
					endSub = j+Width

				dataTH = ATS.shortenData(dataTHroot,startSub,endSub)
				dataTS = ATS.shortenData(dataTSroot,startSub,endSub)

				data = updateDiscriptiveData(data,ATS.combineData(dataTS,dataTH,End)) #update Shakespeare talking
				data = updateDiscriptiveData(data,ATS.combineData(dataTH,dataTS,End)) #update Shakespeare talking

				data = ATS.updateDiscriptiveData(data,dataTS,1) #update Shakespear talking
				data = ATS.updateDiscriptiveData(data,dataTH,1) #update Hawking talking				ori.append(data)
				
				j = j + Width
	return ori



if __name__ == "__main__":

	Start = 0
	End = 300
	inpath = "Input/"
	nameFiles = np.loadtxt("NameFile.txt", dtype = 'S')
	ori1 =  getDiscriptiveData(inpath, Start,End, nameFiles, False)
#	ori1 =  getDiscriptiveDataWithWidth(inpath, Start,End, nameFiles, False,50)
	print (ori1)
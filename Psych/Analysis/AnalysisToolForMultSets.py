import AnalysisToolForSingleSet as ATS
import numpy as np
from os import listdir, walk
from os.path import isfile, join, splitext
import csv
from scipy import stats



def formatOneCollumnOfData(dataGTHS,GoT,Type):
	#format the data for special case such as no-face, comp time, sound, no-sound
	if GoT ==0: #0 is gaze
		if 5 in Type: #no-face
			dataGTHS[:,1] = np.where(dataGTHS[:,1] == 1 ,5, dataGTHS[:,1] )
			dataGTHS[:,1] = np.where(dataGTHS[:,1] == 2 ,5, dataGTHS[:,1] )
			dataGTHS[:,1] = np.where(dataGTHS[:,1] == 3 ,5, dataGTHS[:,1] )
		if 6 in Type: #comp time
			dataGTHS[:,1] = np.where(dataGTHS[:,1] == 2 ,6, dataGTHS[:,1] )
			dataGTHS[:,1] = np.where(dataGTHS[:,1] == 3 ,6, dataGTHS[:,1] )
		if 7 in Type: #for body
			dataGTHS[:, 1] = np.where(dataGTHS[:, 1] == 3, 7, dataGTHS[:, 1])
			dataGTHS[:, 1] = np.where(dataGTHS[:, 1] == 4, 7, dataGTHS[:, 1])
	else:
		if 6 in Type: #sound
			dataGTHS[:,1] = np.where(dataGTHS[:,1] == 3 ,6, dataGTHS[:,1] )
			dataGTHS[:,1] = np.where(dataGTHS[:,1] == 4 ,6, dataGTHS[:,1] )
		if 7 in Type: #no-sound
			dataGTHS[:,1] = np.where(dataGTHS[:,1] == 1 ,7, dataGTHS[:,1] )
			dataGTHS[:,1] = np.where(dataGTHS[:,1] == 2 ,7, dataGTHS[:,1] )
			dataGTHS[:,1] = np.where(dataGTHS[:,1] == 5 ,7, dataGTHS[:,1] )
	return dataGTHS

def updateDiscriptiveData(ori,data,GoT,nameFile,dyad,section):
	start = 0
	end = 0
	i = 0
	(x,y) = data.shape

	####test###
	# data[x-7][2] = 2
	# data[x-6][2] = 2
	# data[x-5][2] = 2

	count = 0
	while i < x:
		if i == x-1 or data[i+1][1] != data[start][1] :
			end = i
			line = []
			line.append(int(nameFile))
			line.append(dyad)
			line.append(section)
			line.append(count)
			line.append(data[start][0])
			#"end-1" is because to prevent out of bound for "end = x"
			#+1 at the is because we want to take into acount of the last number. Ex, from 0 to 20, there is 21 #
			line.append(data[end][0])  
			line.append(end-start+1)
			line.append(data[start][1])
			
			#get the actions of either gaze or talk of the line action		
			action1 = data[start:end+1,[0,2]]
			action2 = data[start:end+1,[0,3]]

			if GoT == 0:
				line = ATS.updateDiscriptiveData(line,action1,1)
			else:
				line = ATS.updateDiscriptiveData(line,action1,0)
			line = ATS.updateDiscriptiveData(line,action2,1)
			start = end + 1
			count = count + 1
			ori.append(line)
		i = i + 1

	return ori

def getDiscriptiveGazeWithWidth(inpath, Start,End, nameFiles, DynEnd, Width,GazeType):
	#get discription information of the data
	#width mean how long do you want to check the characteristics
	#DynEnd dynamic ending
	#GazeType 
	ori = []
	for nameFile in nameFiles:
		print (nameFile)
		for i in [1,2]:
			print (i)
			(dataTHroot, dataTSroot, dataGroot) = ATS.readInput(inpath, nameFile,i)
			if DynEnd: #using dynamic ending 
				(yTH, xTH) = (dataTHroot.shape)
				(yTS, xTS) = (dataTSroot.shape)
				(yG, xG) = (dataGroot.shape)
				End = np.amin(np.asarray([yTH,yTS,yG])) #get the actual end time
			dataTHroot = ATS.shortenData(dataTHroot,Start,End)
			dataTSroot = ATS.shortenData(dataTSroot,Start,End)
			dataGroot = ATS.shortenData(dataGroot,Start,End)			
			
			j = 0
			while j < End:		
			
				startSub = j
				if j+Width > End:
					endSub = End 
				else:
					endSub = j+Width

				dataTH = ATS.shortenData(dataTHroot,startSub,endSub)
				dataTS = ATS.shortenData(dataTSroot,startSub,endSub)
				dataG = ATS.shortenData(dataGroot,startSub,endSub)
				dataGTH  = ATS.combineData(dataG,dataTH,endSub)
				dataGTHS  = ATS.combineData(dataGTH,dataTS,endSub)
				
				#print (dataGTHS)
				dataGTHS = formatOneCollumnOfData(dataGTHS,0,GazeType)
				ori = updateDiscriptiveData(ori,dataGTHS,0,nameFile,i,j)

				j = j + Width
	# for i in ori:
	# 	print (i)
	return ori

def getDiscriptiveTalkWithWidth(inpath, Start,End, nameFiles, DynEnd, Width,TalkType,Person):
	#get discription information of the data
	#width mean how long do you want to check the characteristics
	#DynEnd dynamic ending
	#GazeType 
	ori = []
	for nameFile in nameFiles:
		print (nameFile)
		for i in [1,2]:
			print (i)
			(dataTHroot, dataTSroot, dataGroot) = ATS.readInput(inpath, nameFile,i)
			if DynEnd: #using dynamic ending 
				(yTH, xTH) = (dataTHroot.shape)
				(yTS, xTS) = (dataTSroot.shape)
				(yG, xG) = (dataGroot.shape)
				End = np.amin(np.asarray([yTH,yTS,yG])) #get the actual end time
			dataTHroot = ATS.shortenData(dataTHroot,Start,End)
			dataTSroot = ATS.shortenData(dataTSroot,Start,End)
			dataGroot = ATS.shortenData(dataGroot,Start,End)
			j = 0

			while j < End:		
				startSub = j
				if j+ Width > End:
					endSub = End 
				else:
					endSub = j+Width

				dataTH = ATS.shortenData(dataTHroot,startSub,endSub)
				dataTS = ATS.shortenData(dataTSroot,startSub,endSub)
				dataG = ATS.shortenData(dataGroot,startSub,endSub)
				if Person == 'H': 
					dataGTH  = ATS.combineData(dataTH,dataG,endSub)
					dataGTHS  = ATS.combineData(dataGTH,dataTS,endSub)
				else:
					dataGTS  = ATS.combineData(dataTS,dataG,endSub)
					dataGTHS  = ATS.combineData(dataGTS,dataTH,endSub)
				#print (dataGTHS)
				dataGTHS = formatOneCollumnOfData(dataGTHS,1,TalkType)
				ori = updateDiscriptiveData(ori,dataGTHS,1,nameFile,i,j)

				j = j + Width
	# for i in ori:
	# 	print (i)
	return ori


#this one combined H and S talking together to make it sound (3) or no sound (1) 
def combinedTwoTalkTogether(dataTH,dataTS): 
	(x,y) = dataTH.shape 
	talkHS = np.ones((x,1),dtype = np.int)

	talkHS[:,0] = np.where(dataTH[:,1] == 3,3, talkHS[:,0])
	talkHS[:,0] = np.where(dataTH[:,1] == 4,3, talkHS[:,0])
	talkHS[:,0] = np.where(dataTS[:,1] == 3,3, talkHS[:,0])
	talkHS[:,0] = np.where(dataTS[:,1] == 4,3, talkHS[:,0])

	talkHS = np.concatenate(((dataTH[:,0]).reshape((x,1)), talkHS), axis=1)
	
	return talkHS

def getDiscriptiveTwoTalkWithWidth(inpath, Start,End, nameFiles, DynEnd, Width,GoT):
	#get discription information of the data
	#width mean how long do you want to check the characteristics
	#DynEnd dynamic ending

	ori = []
	for nameFile in nameFiles:
		print (nameFile)
		for i in [1,2]:
			print (i)
			(dataTHroot, dataTSroot, dataGroot) = ATS.readInput(inpath, nameFile,i)
			if DynEnd: #using dynamic ending 
				(yTH, xTH) = (dataTHroot.shape)
				(yTS, xTS) = (dataTSroot.shape)
				(yG, xG) = (dataGroot.shape)
				End = np.amin(np.asarray([yTH,yTS,yG])) #get the actual end time
			dataTHroot = ATS.shortenData(dataTHroot,Start,End)
			dataTSroot = ATS.shortenData(dataTSroot,Start,End)
			dataGroot = ATS.shortenData(dataGroot,Start,End)
			dataTHSroot = combinedTwoTalkTogether(dataTHroot,dataTSroot)
			j = 0

			while j < End:		
				startSub = j
				if j+Width > End:
					endSub = End 
				else:
					endSub = j+Width

				dataG = ATS.shortenData(dataGroot,startSub,endSub)
				dataTHS = ATS.shortenData(dataTHSroot,startSub,endSub)

				if GoT == 0:
					dataGTHS  = ATS.combineData(dataG,dataTHS,endSub)
				else:
					dataGTHS  = ATS.combineData(dataTHS,dataG,endSub)
				
				ori = updateDiscriptiveDataForBothTalks(ori,dataGTHS,GoT,nameFile,i,j)
				
				j = j + Width

	return ori

def updateDiscriptiveDataForBothTalks(ori,data,GoT,nameFile,dyad,section):
	#
	start = 0
	end = 0
	i = 0
	(x,y) = data.shape


	count = 0
	while i < x:
		# let i == x-1 first because it will check this first and skip the second one if it reach the end
		# you i+1 because we are counting forward
		if i == x-1 or data[i+1][1] != data[start][1] :
			end = i
			line = []
			line.append(int(nameFile))
			line.append(dyad)
			line.append(section)
			line.append(count)
			line.append(data[start][0])
			#"end-1" is because to prevent out of bound for "end = x"
			#+1 at the is because we want to take into acount of the last number. Ex, from 0 to 20, there is 21 #
			line.append(data[end][0])  
			line.append(end-start+1)
			line.append(data[start][1])
			
			#get the actions of either gaze or talk of the line action		
			gazeAction = data[start:end+1,[0,2]]
			if GoT == 0:
				line = updateDiscriptiveDataSound(line,gazeAction)
			else :
				line = ATS.updateDiscriptiveData(line,gazeAction,0)	
			count = count + 1
			start = end +1
			ori.append(line)
			
		i = i + 1
	
	# for i in ori:
	# 	print (i)	
	return ori


def getMeanMedSDFreMaxMinSound(data):
	#create special for only sound no sound
	#get the mean median sd and frequency in the set of data
	(x,y) = data.shape
	mean = np.zeros((2))
	median = np.zeros((2))
	std = np.zeros((2))
	fre = np.zeros((2))
	maxi = np.zeros((2))
	mini = np.zeros((2))
	
	desData = (mean,median,std,fre,maxi,mini)

	setOfAction = ATS.countAction(data,[1])
	desData = ATS.updateMeanMedSDFreMaxMin(desData,0,setOfAction)
	setOfAction = ATS.countAction(data,[3])
	desData = ATS.updateMeanMedSDFreMaxMin(desData,1,setOfAction)
	return desData


def updateDiscriptiveDataSound(ori,data):
	#create special for only sound no sound
	TotalAct = getTotalActionSound(data)
	(TotalMean,TotalMedian,TotalSD,TotalFre,TotalMax,TotalMin) = getMeanMedSDFreMaxMinSound(data)
	ori.extend(TotalAct)
	ori.extend(TotalMean)
	ori.extend(TotalMedian)
	ori.extend(TotalSD)
	ori.extend(TotalFre)
	ori.extend(TotalMax)
	ori.extend(TotalMin)
	return ori

def getTotalActionSound(data):
	#create special for only sound no sound
	#count the total time of actions in the data
	#using the shorten data
	(x,y) = data.shape
	cout = np.zeros((2))
	
	i = 0
	while i < x:
		if data[i][1] == 1:
			cout[0] = cout[0]+1
		else:
			cout[1] = cout[1]+1
		i= i+1
	return cout

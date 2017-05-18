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

	# if not ori:
	# 	count = 0
	# else:
	# 	count = len(ori)

	count = 0
	while i < x:
		if data[i][1] != data[start][1] or i == x-1:
			if i == x-1:
				end = x 
			else:
				end = i 
			line = []
			line.append(int(nameFile))
			line.append(dyad)
			line.append(section)
			line.append(count)
			line.append(data[start][0])
			#"end-1" is because to prevent out of bound for "end = x"
			#+1 at the is because we want to take into acount of the last number. Ex, from 0 to 20, there is 21 #
			line.append(data[end-1][0]+1)  
			line.append(end-start)
			line.append(data[start][1])
			
			#get the actions of either gaze or talk of the line action		
			action1 = data[start:end,[0,2]]
			action2 = data[start:end,[0,3]]

			if GoT == 0:
				line = ATS.updateDiscriptiveData(line,action1,1)
			else:
				line = ATS.updateDiscriptiveData(line,action1,0)
			line = ATS.updateDiscriptiveData(line,action2,1)
			start = end
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
			(dataTH, dataTS, dataG) = ATS.readInput(inpath, nameFile,i)
			if DynEnd: #using dynamic ending 
				(yTH, xTH) = (dataTH.shape)
				(yTS, xTS) = (dataTS.shape)
				(yG, xG) = (dataG.shape)
				End = np.amin(np.asarray([yTH,yTS,yG])) #get the actual end time
			dataTH = ATS.shortenData(dataTH,Start,End)
			dataTS = ATS.shortenData(dataTS,Start,End)
			dataG = ATS.shortenData(dataG,Start,End)			
			
			j = 0
			while j < End:		
			
				startSub = j
				if j+Width > End:
					endSub = End 
				else:
					endSub = j+Width

				dataTH = ATS.shortenData(dataTH,startSub,endSub)
				dataTS = ATS.shortenData(dataTS,startSub,endSub)
				dataG = ATS.shortenData(dataG,startSub,endSub)
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
			(dataTH, dataTS, dataG) = ATS.readInput(inpath, nameFile,i)
			if DynEnd: #using dynamic ending 
				(yTH, xTH) = (dataTH.shape)
				(yTS, xTS) = (dataTS.shape)
				(yG, xG) = (dataG.shape)
				End = np.amin(np.asarray([yTH,yTS,yG])) #get the actual end time
			dataTH = ATS.shortenData(dataTH,Start,End)
			dataTS = ATS.shortenData(dataTS,Start,End)
			dataG = ATS.shortenData(dataG,Start,End)
			j = 0

			while j < End:		
				startSub = j
				if j+Width > End:
					endSub = End 
				else:
					endSub = j+Width

				dataTH = ATS.shortenData(dataTH,startSub,endSub)
				dataTS = ATS.shortenData(dataTS,startSub,endSub)
				dataG = ATS.shortenData(dataG,startSub,endSub)
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


def combinedTwoTalkTogether(dataTH,dataTS):
	(x,y) = dataTH.shape 
	talkHS = np.zeros((x,1))

	#testing#
	dataTS [5][1] = 4
	dataTH [5][1] = 3

	dataTS [7][1] = 3
	dataTH [9][1] = 4


	talkHS[:,0] = np.where(dataTH[:,1] == 3,1, talkHS[:,0])
	talkHS[:,0] = np.where(dataTH[:,1] == 4,1, talkHS[:,0])
	talkHS[:,0] = np.where(dataTS[:,1] == 3,1, talkHS[:,0])
	talkHS[:,0] = np.where(dataTS[:,1] == 4,1, talkHS[:,0])

	print("TH")
	print(dataTH)
	print("TS")
	print(dataTS)
	talkHS = np.concatenate(((dataTH[:,0]).reshape((x,1)), talkHS), axis=1)
	print ("Result")
	print (talkHS)
	return

def getDiscriptiveTwoTalkWithWidth(inpath, Start,End, nameFiles, DynEnd, Width):
	#get discription information of the data
	#width mean how long do you want to check the characteristics
	#DynEnd dynamic ending
	#GazeType 
	ori = []
	for nameFile in nameFiles:
		print (nameFile)
		for i in [1,2]:
			print (i)
			(dataTH, dataTS, dataG) = ATS.readInput(inpath, nameFile,i)
			if DynEnd: #using dynamic ending 
				(yTH, xTH) = (dataTH.shape)
				(yTS, xTS) = (dataTS.shape)
				(yG, xG) = (dataG.shape)
				End = np.amin(np.asarray([yTH,yTS,yG])) #get the actual end time
			dataTH = ATS.shortenData(dataTH,Start,End)
			dataTS = ATS.shortenData(dataTS,Start,End)
			dataG = ATS.shortenData(dataG,Start,End)
			combinedTwoTalkTogether(dataTH,dataTS)
			j = 0

	# 		while j < End:		
	# 			startSub = j
	# 			if j+Width > End:
	# 				endSub = End 
	# 			else:
	# 				endSub = j+Width

	# 			dataTH = ATS.shortenData(dataTH,startSub,endSub)
	# 			dataTS = ATS.shortenData(dataTS,startSub,endSub)
	# 			dataG = ATS.shortenData(dataG,startSub,endSub)
	# 			if Person == 'H': 
	# 				dataGTH  = ATS.combineData(dataTH,dataG,endSub)
	# 				dataGTHS  = ATS.combineData(dataGTH,dataTS,endSub)
	# 			else:
	# 				dataGTS  = ATS.combineData(dataTS,dataG,endSub)
	# 				dataGTHS  = ATS.combineData(dataGTS,dataTH,endSub)
	# 			#print (dataGTHS)
	# 			dataGTHS = formatOneCollumnOfData(dataGTHS,1,TalkType)
	# 			ori = updateDiscriptiveData(ori,dataGTHS,1,nameFile,i,j)

	# 			j = j + Width
	# # for i in ori:
	# 	print (i)
	return ori


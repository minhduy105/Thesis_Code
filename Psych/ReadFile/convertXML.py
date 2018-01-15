import xml.etree.ElementTree as ET
import numpy as np
from os import listdir, walk
from os.path import isfile, join, splitext, dirname

def TagToNum(name,codeID):
	if codeID == 0: #gaze 
		if name.lower()[0] == "a":
			return 1
		elif name.lower()[0] == "m":
			return 2
		elif name.lower()[0] == "k":
			return 3
		elif name.lower()[0] == "f":
			return 4
		else:
			return 1000000000
	else:
		if name.lower()[0:2] == "no" :
			return 1
		elif name.lower()[0:2] == "ty":
			return 2
		elif name.lower()[0:2] == "sp":
			return 3
		elif name.lower()[0:2] == "ss":
			return 4
		elif  name.lower()[0:2] == "ho":
			return 5
		else:
			return 1000000000

def getFrame(time):
	out = time.split(':')
	result = (int(out[0])*60*60*30)  + (int(out[1])*60*30) + (int(out[2])*30) + int(out[3])  
	return result

def HmmToFrame(data,codeID):
	result = []
	for i in data:
		result.append([getFrame(i[0]),getFrame(i[1]),TagToNum(i[2],codeID)])
		if TagToNum(i[2],codeID) > 900000:
			print ("wrong label")
			print (i[0])
			raise ValueError

	result = np.array(result)
	
	print ("OLD: start: " + str (result[0][0]) + " - end: " + str (result[0][1]))
	start = result[0][0] 
	result[:,0] -=start
	result[:,1] -=start
	print ("NEW: start: " + str (result[0][0]) + " - end: " + str (result[0][1]))
	
	return result

def Expand(inData):
	result = [] 
	(x,y) = inData.shape	
	i = 0
	j = 0
	val = -1000
	while i < inData[x-1][0]: #i is counting 
		if i == inData[j][0]: #j is for going through the array
			val = inData[j][2]
			if j == x-1:
				break
			else:
				j = j + 1
		if 	i > inData[j][0]:
			print ("Critical error in the XML_to_raw code at (for sub in tree) statement, please check near frame: " + 	str(inData[j-1][0]))
			raise ValueError 
			break
		result.append([i,val])
		i = i + 1	

	while i < inData[x-1][1]:
		result.append([i,inData[x-1][2]])	
		i = i + 1 

	result = np.array(result)
	
	return result

def checkInput(data):
	tree = ET.parse(data)
	root = tree.getroot()

	result = [] # go through like a tree with sub is the next leaf
	for child in root:
		if "body" in child.tag:  
			for sub1 in child:
				for sub2 in sub1:
					start = sub2.get("begin")
					end = sub2.get("end")
					tag = ''
					for sub3 in sub2:
						if "span" in sub3.tag:
							tag = sub3.text.strip()  
					result.append([start,end,tag])

	for i in result: #checking error
		if i[2] is '':
			check = False
			print ("Error (Empty input) at: " +  i[0])
	
	return result	

def ReadXMLFile (inpath,outpath1,outpath2,codeID,splitNum): 
	checkall = True # for checking the whole dataset
	try:	
		for root, dirs, files in walk(inpath):
			for file in files:
				if file.endswith(".xml"):
					check = True
					output = checkInput(join(root, file)) #, outpath + splitext(file)[0][0:14].upper() + "_raw.csv") 
					if not output:
						check = False
						checkall = False
						print (join(root, file))
					if check :
						print(file) 
						
						print (dirname(join(root, file)))

						data = HmmToFrame(output,codeID)
						exp = Expand(data)

						np.savetxt(outpath1 + splitext(file)[0][0:splitNum].upper() + "_sim.csv", data, fmt='%1.3f',delimiter=',' )
						np.savetxt(outpath2 + splitext(file)[0][0:splitNum].upper() + "_exp.csv", exp, fmt='%1.3f',delimiter=',' )

						print ("Good job, mate !!!!!!!!!!!!!!!!!!!!!!\n")		
					else:
						print ("Error at File" + file )


	except ValueError:
		check = False

	if check:	
		print ("\n Enjoy your sweet DATA  !!!!!!!!!!!!!")

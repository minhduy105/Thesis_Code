import numpy as np
import pandas as pd
import scipy.stats as st
import csv

def readInput(line,size,end):
    if len(line) > end:
        if line[end-size:end] != '  ':
            return int(line[end-size:end])
    return -1000

def printResult(info,title,name):
    info.reverse()
    info.append(title)
    info.reverse()
    with open(name, "w") as t:
        writer = csv.writer(t)
        writer.writerows(info)

np.set_printoptions(threshold=np.nan)

all = []
for i in range(11):
    all.append([])
col = []
filename = "Introversion"
title = ["Distant","Aloof","Unsociable","Introverted","Antisocial"]
#read the data, ignore the self-rating in this case, delete or modify the if statement to get the data
with open(filename+".txt") as f:
    for line in f:
        if len(line) > 13:
            col.append(int(line[0:3]))
            col.append(int(line[4:6]))
            col.append(int(line[7:8]))
            col.append(int(line[9:10]))
            col.append(int(line[11:12]))
            col.append(int(line[13:15]))
            col.append(readInput(line,2,18))
            col.append(readInput(line,2,21))
            col.append(readInput(line,2,24))
            col.append(readInput(line,2,27))
            col.append(readInput(line,2,30))

            if col[3] != 0: # ignore self-rating, delete it if you want self rating
                all[col[0]-501].append(col)


            col = []

#sort the date
all = np.asarray(all)
for i in range (11):
    s = all[i]
    idx = np.lexsort((s[:,4],s[:,1],s[:,3]))
    all[i] = s[idx]

#average rating based on person
(z,y,x) = (all.shape)
personTol = np.zeros((2,y,5))
personCnt = np.zeros((2,y,5))
for i in range (z):
    if all[i][int(y/2)][3] == 2: #use y/2 to prevent input error
        idz = 1
    else:
        idz = 0
    for k in range(y):
        for j in range(6,z):
            if all[i][k][j] > 0:
                personTol[idz][k][j-6] = personTol[idz][k][j-6] +  all[i][k][j]
                personCnt[idz][k][j-6] = personCnt[idz][k][j-6] + 1.0

personAve = personTol/personCnt

name = "Average\\"+filename+"_S.csv"
printResult(personAve[0].tolist(),title,name)
name = "Average\\"+filename+"_H.csv"
printResult(personAve[1].tolist(),title,name)



print (st.pearsonr ((personAve[1,:,0]),(personAve[1,:,1])))

#calculate correlation and p
# calculate correlation and p
(z, y, x) = (personAve.shape)
cor = np.zeros((z, x, x))
pval = np.zeros((z, x, x))

for i in range(z):


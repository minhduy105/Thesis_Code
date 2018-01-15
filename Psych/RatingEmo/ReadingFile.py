import numpy as np
import pandas as pd
import scipy.stats as st
import csv

def readInput(line,size,end):
    if len(line) > end:
        if line[end-size:end] != '  ' and line[end-size:end] != '\t\t':
            return int(line[end-size:end])
    return -1000

def printResult(info,title,name):
    info.reverse()
    info.append(title)
    info.reverse()
    with open(name, "w") as t:
        writer = csv.writer(t,lineterminator='\n')
        writer.writerows(info)

np.set_printoptions(threshold=np.nan)

all = []
for i in range(11):
    all.append([])
col = []
# filename = "Introversion"
# title1 = ["Dyad","Conv","Distant","Aloof","Unsociable","Introverted","Antisocial"]
# title2 = ["Distant","Aloof","Unsociable","Introverted","Antisocial"]

# filename = "Meek"
# title1 = ["Dyad","Conv","Timid","Yielding","Awkward","Shy","Meek"]
# title2 = ["Timid","Yielding","Awkward","Shy","Meek"]

filename = "OCEAN"
title1 = ["Dyad","Conv","Openness","Conscientiousness","Extraversion","Agreeableness","Neuroticism"]
title2 = ["Openness","Conscientiousness","Extraversion","Agreeableness","Neuroticism"]


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

            #this is for the
            # col.append(readInput(line,2,18))
            # col.append(readInput(line,2,21))
            # col.append(readInput(line,2,24))
            # col.append(readInput(line,2,27))
            # col.append(readInput(line,2,30))

            col.append(readInput(line,2,22))
            col.append(readInput(line,2,25))
            col.append(readInput(line,2,28))
            col.append(readInput(line,2,31))
            col.append(readInput(line,2,34))

            if col[3] != 0: # ignore self-rating, delete it if you want self rating
                all[col[0]-501].append(col)


            col = []

#sort the date baased on H/S/selfreport, dyad, and conv
helper = []#delete empty coder
for i in all:
    if i:
        helper.append(i)

all = np.asarray(helper)
for i in range (len(helper)):
    s = all[i]
    idx = np.lexsort((s[:,4],s[:,1],s[:,3]))
    all[i] = s[idx]

#average rating based on person
(z,y,x) = (all.shape)
personTol = np.zeros((2,y,5))
personCnt = np.zeros((2,y,5))
for i in range (z):
    if all[i][int(y/2)][3] == 2: #use y/2 to prevent input error on H or S
        idz = 1 #H is 1
    else:
        idz = 0 #S is 0
    for k in range(y):
        for j in range(6,x):
            if all[i][k][j] > 0:
                personTol[idz][k][j-6] = personTol[idz][k][j-6] +  all[i][k][j]
                personCnt[idz][k][j-6] = personCnt[idz][k][j-6] + 1.0

personAve = personTol/personCnt

SAve = np.concatenate((all[1,:,[1,4]].transpose(),personAve[0]),axis=1)
HAve = np.concatenate((all[1,:,[1,4]].transpose(),personAve[1]),axis=1)

name = "Average\\"+filename+"_S.csv"
printResult(SAve.tolist(),title1,name)
name = "Average\\"+filename+"_H.csv"
printResult(HAve.tolist(),title1,name)


#calculate correlation and p
(z, y, x) = (personAve.shape)

cor = np.zeros((z, x, x))
pval = np.zeros((z, x, x))
for i in range(z):
    for k in range (x):
        for j in range(x):
            (peacor,pvalue) = st.pearsonr ((personAve[i,:,k]),(personAve[i,:,j]))
            cor[i][k][j] = peacor
            pval[i][k][j] = pvalue

name = "Correlation\\"+filename+"_cor_S.csv"
printResult(cor[0].tolist(),title2,name)
name = "Correlation\\"+filename+"_cor_H.csv"
printResult(cor[1].tolist(),title2,name)

name = "Correlation\\"+filename+"_pval_S.csv"
printResult(pval[0].tolist(),title2,name)
name = "Correlation\\"+filename+"_pval_H.csv"
printResult(pval[1].tolist(),title2,name)


combPersonAve = np.concatenate((personAve[0],personAve[1]),axis=0)
cor = np.zeros(( x, x))
pval = np.zeros(( x, x))

for k in range (x):
    for j in range(x):
        (peacor,pvalue) = st.pearsonr ((combPersonAve[:,k]),(combPersonAve[:,j]))
        cor[k][j] = peacor
        pval[k][j] = pvalue
name = "Correlation\\"+filename+"_cor.csv"
printResult(cor.tolist(),title2,name)

name = "Correlation\\"+filename+"_pval.csv"
printResult(pval.tolist(),title2,name)


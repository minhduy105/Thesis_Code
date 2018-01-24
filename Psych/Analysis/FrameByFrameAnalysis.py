import numpy as np
import AnalysisToolForSingleSet as ATS
import copy


def getDescript (low, high):


def getDiscriptiveWithWidth(inpath, Start, End, nameFiles, DynEnd, Width, GazeType):
    # get discription information of the data
    # width mean how long do you want to check the characteristics
    # DynEnd dynamic ending
    # GazeType
    ori = []
    for nameFile in nameFiles:
        print (nameFile)
        for i in [1, 2]:
            print (i)
            (dataTHroot, dataTSroot, dataGroot) = ATS.readInput(inpath, nameFile, i)
            if DynEnd:  # using dynamic ending
                (yTH, xTH) = (dataTHroot.shape)
                (yTS, xTS) = (dataTSroot.shape)
                (yG, xG) = (dataGroot.shape)
                End = np.amin(np.asarray([yTH, yTS, yG]))  # get the actual end time
            dataTHroot = ATS.shortenData(dataTHroot, Start, End)
            dataTSroot = ATS.shortenData(dataTSroot, Start, End)
            dataGroot = ATS.shortenData(dataGroot, Start, End)

            j = 0
            while j < End:

                startSub = j
                if j + Width > End:
                    endSub = End
                else:
                    endSub = j + Width

                dataTH = ATS.shortenData(dataTHroot, startSub, endSub)
                dataTS = ATS.shortenData(dataTSroot, startSub, endSub)
                dataG = ATS.shortenData(dataGroot, startSub, endSub)
                dataGTH = ATS.combineData(dataG, dataTH, endSub)
                dataGTHS = ATS.combineData(dataGTH, dataTS, endSub)


                # print (dataGTHS)



                j = j + Width
    # for i in ori:
    # 	print (i)
    return ori

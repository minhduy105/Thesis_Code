import pandas as pd
import math
import numpy as np


def CalculateTimeForNormal(data_df):
    col_num = data_df.shape[1]
    normal_time = data_df.copy(deep = True)
    i = 1
    while i < col_num:
        normal_time.iloc[:,i] = normal_time.iloc[:,i] /30.0
        i = i + 3

    i = 2
    while i < col_num:
        normal_time.iloc[:,i] = normal_time.iloc[:,i] /30.0
        i = i + 3
    return normal_time

#
# def CalculateTimeForLog(data_df):
#     log_time = data_df.copy(deep=True)
#     col_num = data_df.shape[1]
#     row_num = data_df.shape[0]
#     i = 1
#     while i < col_num:
#         log_time.iloc[:, i] = np.log(((log_time.iloc[:, i] / 30.0 * 1000.0) +1.0))
#         i = i + 3
#
#     i = 2
#     while i < col_num:
#         j = 0
#         while j < row_num:
#             if log_time.iloc[j, i+1] < 0.0001:
#                 log_time.iloc[j, i] = 0.0
#             else:
#                 log_time.iloc[j, i] = log_time.iloc[j, i-1] / log_time.iloc[j, i+1]
#             j = j + 1
#         i = i + 3
#     return log_time


def CalculateTimeForLog(data_df):
    log_time = data_df.copy(deep=True)
    col_num = data_df.shape[1]
    row_num = data_df.shape[0]

    mul = 1.0

    i = 2
    while i < col_num:
        j = 0
        while j < row_num:
            if log_time.iloc[j, i+1] < 0.0001:
                log_time.iloc[j, i] = 0.0
            else:
                log_time.iloc[j, i] = np.log(((log_time.iloc[j, i-1] / 30.0 * mul / log_time.iloc[j, i+1]) +1.0))
            j = j + 1
        i = i + 3

    i = 1
    while i < col_num:
        log_time.iloc[:, i] = np.log(((log_time.iloc[:, i] / 30.0 * mul) +1.0))
        i = i + 3

    return log_time


def FindDiff(data_df, Char, Gaze):

    for i in Char:
        for k in Gaze:
            a = i + k + "1_0s"
            b = i + k + "1_200s"
            c = i + k + "2_0s"
            d = i + k + "2_200s"

            e = "Dif" + i + k + "_1S_1E"
            data_df[e] = np.absolute(data_df[a] - data_df[b])

            f = "Dif" + i + k +"_2S_2E"
            data_df[f] = np.absolute(data_df[c] - data_df[d])

            g = "Dif" + i + k +"_1S_2S"
            data_df[g] = np.absolute(data_df[a] - data_df[c])

            h = "Dif" + i + k + "_1E_2E"
            data_df[h] = np.absolute(data_df[b] - data_df[d])

            l = "Dif" + i + k + "_1E_2S"
            data_df[l] = np.absolute(data_df[b] - data_df[c])

    return data_df

def FindThreeLargest(data_df, Char, Gaze):

    for i in Char:
        for k in Gaze:

            e = "Diff" + i + k + "_1_0s_1_200s"
            help = data_df.nlargest(3,e)
            print (help.iloc[:,0:1])

            f = "Diff" + i + k +"_2_0s_2_200s"
            help = data_df.nlargest(3, e)
            print (help.iloc[:, 0:1])

            g = "Diff" + i + k +"_1_0s_2_0s"
            help = data_df.nlargest(3, e)
            print (help.iloc[:, 0:1])


            h = "Diff" + i + k + "_1_200s_2_200s"
            help = data_df.nlargest(3, e)
            print (help.iloc[:, 0:1])


if __name__ == "__main__":
    data_df = pd.read_csv("SummaryGaze.csv")
    print (data_df)
    col_num = data_df.shape[1]
    normal_time = CalculateTimeForNormal(data_df)
    log_time = CalculateTimeForLog(data_df)

    normal_time.to_csv("NormalTime.csv")
    log_time.to_csv("LogTime.csv")

    Gaze = ["Around","Face"]
    Char = ["TotalDuration","MeanDuration"]


    normal_time =  FindDiff(normal_time, Char, Gaze)
    log_time =  FindDiff(log_time, Char, Gaze)


    normal_time.to_csv("NormalTimeDiff.csv")
    log_time.to_csv("LogTimeDiff.csv")

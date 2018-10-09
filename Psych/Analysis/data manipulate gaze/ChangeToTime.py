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

    i = 2
    while i < col_num:
        j = 0
        while j < row_num:
            if log_time.iloc[j, i+1] < 0.0001:
                log_time.iloc[j, i] = 0.0
            else:
                log_time.iloc[j, i] = np.log(((log_time.iloc[j, i-1] / 30.0 * 1000.0 / log_time.iloc[j, i+1]) +1.0))
            j = j + 1
        i = i + 3

    i = 1
    while i < col_num:
        log_time.iloc[:, i] = np.log(((log_time.iloc[:, i] / 30.0 * 1000.0) +1.0))
        i = i + 3

    return log_time




if __name__ == "__main__":
    data_df = pd.read_csv("Summary.csv")
    print (data_df)
    col_num = data_df.shape[1]
    normal_time = CalculateTimeForNormal(data_df)
    log_time = CalculateTimeForLog(data_df)

    normal_time.to_csv("NormalTime.csv")
    log_time.to_csv("LogTime.csv")

    Gaze = ["Around","Face"]
    Char = ["TotalDuration","MeanDuration"]

    for i in Char:
        for k in Gaze:
            a = i + k + "Log1_0s"
            b = i + k + "Log1_200s"
            c = i + k + "Log2_0s"
            d = i + k + "Log2_200s"

            e = "Diff" + i + k + "_1_0s_1_200s"
            log_time[e] = np.absolute(log_time[a] - log_time[b])

            f = "Diff" + i + k +"_2_0s_2_200s"
            log_time[f] = np.absolute(log_time[c] - log_time[d])

            g = "Diff" + i + k +"_1_0s_2_0s"
            log_time[g] = np.absolute(log_time[a] - log_time[c])

            h = "Diff" + i + k + "_1_200s_2_200s"
            log_time[h] = np.absolute(log_time[b] - log_time[d])

            l = "Diff" + i + k + "_1_200s_2_0s"
            log_time[l] = np.absolute(log_time[b] - log_time[c])

    for i in Char:
        for k in Gaze:

            e = "Diff" + i + k + "_1_0s_1_200s"
            print (e)
            help = log_time.nlargest(3,e)
            print (help.iloc[:,0:1])

            f = "Diff" + i + k +"_2_0s_2_200s"
            print (f)
            help = log_time.nlargest(3, e)
            print (help.iloc[:, 0:1])

            g = "Diff" + i + k +"_1_0s_2_0s"
            print (g)
            help = log_time.nlargest(3, e)
            print (help.iloc[:, 0:1])


            h = "Diff" + i + k + "_1_200s_2_200s"
            print (h)
            help = log_time.nlargest(3, e)
            print (help.iloc[:, 0:1])
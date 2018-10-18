import pandas as pd
import numpy as np


if __name__ == "__main__":
    data_df = pd.read_csv("PersonalTraitData.csv")
    col_num = data_df.shape
    print(col_num)

    for i in ['1','2']:
        for j in ['h','s']:
            for k in ['2','5','6','7','8','10','13','16','18']:
                q = 'Re_'+ j + 'ia'+ i + 'r' + k
                item = j + 'ia'+ i + 'r' + k
                data_df[q] = 8 - data_df[item]

    for i in ['1','2']:
        for j in ['h','s']:
            aver = 'Aver_'+j + 'ia'+ i
            first = j + 'ia'+ i + 'r1'
            items = []
            for k in ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18']:
                if k in ['2','5','6','7','8','10','13','16','18']:
                    item = 'Re_'+ j + 'ia'+ i + 'r' + k
                else:
                    item = j + 'ia'+ i + 'r' + k
                items.append(item)
            data_df[aver] = data_df[items].mean(axis=1)
            print(data_df[aver])

    data_df.to_csv("PersonalWithRapport.csv")


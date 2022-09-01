import pandas as pd
import numpy as np

data = pd.read_csv("swimming_pool_one_column.csv",comment='#',sep=";",header=None,)
heat = data[0].tolist()
#for i in range(len(heat)):
 #   heat[i] = heat[i]*1000
time = [3600*i for i in range(8760)]
full_data = np.stack([time, heat], axis=1)

np.savetxt('power.txt', full_data, delimiter="\t",fmt='%f')
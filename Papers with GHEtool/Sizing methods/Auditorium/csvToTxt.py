import pandas as pd
import numpy as np

data = pd.read_csv("auditorium_one_column.csv",comment='#',sep=";",header=None,)
heat = data[0].tolist()
print(heat)
heat_20y=[]
for i in range(20):
    heat_20y  = heat_20y +heat

time = [3600*i for i in range(8760)]
full_data = np.stack([time, heat], axis=1)

np.savetxt('power.txt', full_data, delimiter="\t",fmt='%f')
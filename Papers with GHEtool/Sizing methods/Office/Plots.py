import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

mod = pd.read_csv("ModelicaResults/TavgFluidL3.csv",comment='#',sep=",",skiprows=[1])
GHE = pd.read_csv("exports/L3_temperature_profile.csv",comment='#',sep=",",header=None)

plt.figure()
#plt.plot(mod["Time"],mod["TAvgFluid"]-273.15, color = "b",linewidth = 0.5,label="modelica")
plt.plot(mod["Time"],GHE, color = "r",linewidth = 0.5,label="GHEtool")
plt.legend()


a = GHE[0] - mod["TAvgFluid"]  + 273.15
print(a)

plt.figure()
plt.plot(mod["Time"],a, color = "b",linewidth = 0.5,label="difference")
plt.show()



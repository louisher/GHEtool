import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

T_ground_avg = 11.07018210018297

mod = pd.read_csv("ModelicaResults/TavgFluidL4Tconst.csv",comment='#',sep=",",skiprows=[1])
GHE = pd.read_csv("exports/L4_temperature_profile.csv",comment='#',sep=",",header=None)
GHE_Tw = pd.read_csv("exports/Tb_L4_temperature_profile.csv",comment='#',sep=",",header=None)
mod_Tw = pd.read_csv("ModelicaResults/TAveBorL4Tconst.csv",comment='#',sep=",")


GHE_Tw = GHE_Tw.to_numpy()
GHE_Tw = GHE_Tw.tolist()
GHE_Tw = [[T_ground_avg]] + GHE_Tw
print(len(mod))
time_Tw = [i*3600 for i in range(175201)]
time = [3600*(i) for i in range(175200)]



plt.figure()
plt.plot(mod["Time"],mod["TAvgFluid"]-273.15, color = "b",linewidth = 0.5,label="modelica")
plt.plot(time,GHE, color = "r",linewidth = 0.5,label="GHEtool")
plt.legend()

plt.figure("T wall")
plt.plot(mod_Tw["Time"],mod_Tw["borFie.TBorAve"]-273.15, color = "b",linewidth = 0.5,label="modelica")
plt.plot(time_Tw,GHE_Tw, color = "r",linewidth = 0.5,label="GHEtool")
plt.legend()
plt.show()
a = GHE[0] - mod["TAvgFluid"]  + 273.15
b = GHE_Tw[0] - mod["TAvgFluid"]  + 273.15

plt.figure()
plt.plot(mod["Time"],a, color = "b",linewidth = 0.5,label="difference")

plt.figure("Twall dif")
plt.plot(time,b, color = "b",linewidth = 0.5,label="difference")
plt.show()



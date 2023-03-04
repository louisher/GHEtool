import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from plotly.subplots import make_subplots
import plotly.graph_objects as go

T_ground_avg = 11.07018210018297

# load data
mod_Tconst = pd.read_csv("ModelicaResults/TavgFluid_L4_Tconst.csv", comment='#', sep=",", skiprows=[])
mod = pd.read_csv("ModelicaResults/TavgFluid_L4.csv", comment='#', sep=",", skiprows=[])
GHE = pd.read_csv("exports/L4_temperature_profile.csv", comment='#', sep=",", header=None)
GHE_Tw = pd.read_csv("exports/Tb_L4_temperature_profile.csv", comment='#', sep=",", header=None)
mod_Tw_Tconst = pd.read_csv("ModelicaResults/TAveBor_L4_Tconst.csv", comment='#', sep=",")
mod_Tw = pd.read_csv("ModelicaResults/TAveBor_L4.csv", comment='#', sep=",")

sizing = ["L2", "L3", "L4"]
modelica = [pd.read_csv("ModelicaResults/TavgFluid_L2_Tconst.csv", comment='#', sep=",", skiprows=[])["TAvgFluid"],
            pd.read_csv("ModelicaResults/TavgFluid_L3_Tconst.csv", comment='#', sep=",", skiprows=[])["TAvgFluid"],
            pd.read_csv("ModelicaResults/TavgFluid_L4_Tconst.csv", comment='#', sep=",", skiprows=[])["TAvgFluid"]]
GHEtool = [pd.read_csv("exports/L2_temperature_profile.csv", comment='#', sep=",", header=None)[0],
           pd.read_csv("exports/L3_temperature_profile.csv", comment='#', sep=",", header=None)[0],
           pd.read_csv("exports/L4_temperature_profile.csv", comment='#', sep=",", header=None)[0]]

max_temps = [np.max(i) - 273.15 for i in modelica]
min_temps = [np.min(i) - 273.15for i in modelica]

rel_diff_max = [(17-i)/17*100 for i in max_temps]
rel_diff_min = [(i-3)/3*100 for i in min_temps]

print(max_temps)
print(min_temps)
print(rel_diff_max)
print(rel_diff_min)

# convert GHE data to numpy
GHE_Tw = np.array(GHE_Tw.iloc[:, 0])

# add initial temperature to GHEtool data to have the same length as in Modelica
GHE_Tw = np.concatenate((np.array([T_ground_avg]), GHE_Tw))

# initiate time arrays
time_Tw = np.arange(0, 175201 * 3600, 3600)
time = np.arange(0, 175200 * 3600, 3600)

plt.figure()
plt.plot(mod_Tconst["TAvgFluid"]-mod["TAvgFluid"])
plt.show()

# create figures
plt.figure()
plt.plot(mod_Tconst["Time"], mod_Tconst["TAvgFluid"] - 273.15, color="b", linewidth=0.5, label="modelica Tconst")
plt.plot(mod_Tconst["Time"], mod["TAvgFluid"] - 273.15, color="g", linewidth=0.5, label="modelica Grad")

plt.plot(time, GHE.iloc[:, 0], color="r", linewidth=0.5, label="GHEtool")
plt.title("Average fluid temperature")
plt.legend()

plt.figure("T wall")
plt.plot(mod_Tw_Tconst["Time"], mod_Tw_Tconst["borFie.TBorAve"] - 273.15, color="b", linewidth=0.5, label="modelica Tconst")
plt.plot(mod_Tw_Tconst["Time"], mod_Tw["borFie.TBorAve"] - 273.15, color="g", linewidth=0.5, label="modelica Grad")

plt.plot(time_Tw, GHE_Tw, color="r", linewidth=0.5, label="GHEtool")
plt.title("Average borehole wall temperature")
plt.legend()

# calculate difference
diff_fluid = GHE[0] - mod_Tconst["TAvgFluid"] + 273.15
diff_Twall = GHE_Tw - mod_Tw_Tconst["borFie.TBorAve"] + 273.15
plt.show()

# calculate difference
diff_fluid = GHE[0] - mod["TAvgFluid"] + 273.15
diff_Twall = GHE_Tw - mod_Tw["borFie.TBorAve"] + 273.15

# create figures
plt.figure()
plt.plot(mod["Time"], diff_fluid, color="b", linewidth=0.5, label="difference")
plt.title("Difference average fluid temperature")

plt.figure("Twall dif")
plt.plot(time_Tw, diff_Twall, color="b", linewidth=0.5, label="difference")
plt.title("Difference average borehole wall temperature")

fig = make_subplots(rows=3, cols=1,
                    shared_xaxes=True,
                    vertical_spacing=0.02)

fig.add_trace(go.Scatter(x=mod["Time"], y=diff_fluid),
              row=3, col=1)

fig.add_trace(go.Scatter(x=mod["Time"], y=mod["TAvgFluid"]-273.15),
              row=2, col=1)

fig.add_trace(go.Scatter(x=time, y=GHE.iloc[:, 0]),
              row=1, col=1)

fig.update_layout(height=1000, width=2000,
                  title_text="Stacked Subplots with Shared X-Axes")
fig.show()

plt.show()
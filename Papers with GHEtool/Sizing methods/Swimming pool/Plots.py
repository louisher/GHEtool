import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from plotly.subplots import make_subplots
import plotly.graph_objects as go

# set average ground temperature
T_ground_avg = 13.10678

# load data
mod = pd.read_csv("ModelicaResults/TavgFluidL4Seg12.csv", comment='#', sep=",", skiprows=[])
GHE = pd.read_csv("exports/L4_temperature_profile.csv", comment='#', sep=",", header=None)
GHE_Tw = pd.read_csv("exports/Tb_L4_temperature_profile.csv", comment='#', sep=",", header=None)
mod_Tw = pd.read_csv("ModelicaResults/TAveBorL4Seg12.csv", comment='#', sep=",")
Q_flow = pd.read_csv("ModelicaResults/Q_flow20y.csv", comment='#', sep=",", skiprows=[])

# convert GHE data to numpy
GHE_Tw = np.array(GHE_Tw.iloc[:, 0])

# add initial temperature to GHEtool data to have the same length as in Modelica
GHE_Tw = np.concatenate((np.array([T_ground_avg]), GHE_Tw))

# initiate time arrays
time_Tw = np.arange(0, 175201 * 3600, 3600)
time = np.arange(0, 175200 * 3600, 3600)

# create figures
plt.figure()
plt.plot(mod["Time"], mod["TAvgFluid"]-273.15, color="b", linewidth =0.5, label="modelica")
plt.plot(time, GHE.iloc[:, 0], color="r", linewidth=0.5, label="GHEtool")
plt.title("Average fluid temperature")
plt.legend()

plt.figure("T wall")
plt.plot(mod_Tw["Time"], mod_Tw["borFie.TBorAve"]-273.15, color="b", linewidth=0.5, label="modelica")
plt.plot(time_Tw, GHE_Tw, color="r", linewidth=0.5, label="GHEtool")
plt.title("Average borehole wall temperature")
plt.legend()

# calculate difference
diff_fluid = GHE[0] - mod["TAvgFluid"] + 273.15
diff_Twall = GHE_Tw - mod_Tw["borFie.TBorAve"] + 273.15

# calculate relative difference
diff_fluid_rel = np.divide(diff_fluid, Q_flow["hea.Q_flow"])
plt.figure()
plt.plot(diff_fluid_rel)


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
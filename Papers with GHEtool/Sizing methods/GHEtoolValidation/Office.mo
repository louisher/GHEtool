within GHEtoolValidation;
model Office
  parameter Integer nSeg = 12;
  parameter Modelica.Units.SI.Temperature T_startAll = 273.15 + 11.10796;
  parameter Modelica.Units.SI.Temperature TExt0_start=T_startAll;
  parameter Modelica.Units.SI.Length z0=0;
  parameter Real dT_dz(final unit="K/m", min=0) = 0.02;
  parameter Modelica.Units.SI.Height z[nSeg]={borFieDat.conDat.hBor/nSeg*(i -
      0.5) for i in 1:nSeg};

  IDEAS.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = IDEAS.Media.Water(lambda_const=0.568),
    T_start=T_startAll,
    addPowerToMedium=false,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    inputType=IDEAS.Fluid.Types.InputType.Constant)
    annotation (Placement(transformation(extent={{-20,-10},{0,-30}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TBorFieIn(
    redeclare package Medium = IDEAS.Media.Water(lambda_const=0.568),
    T_start=T_startAll,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    tau=0) "Inlet temperature of the borefield"
    annotation (Placement(transformation(extent={{10,-10},{30,-30}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TBorFieOut(
    redeclare package Medium = IDEAS.Media.Water(lambda_const=0.568),
    T_start=T_startAll,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature of the borefield"
    annotation (Placement(transformation(extent={{70,-10},{90,-30}})));
  IDEAS.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = IDEAS.Media.Water(lambda_const=0.568),
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=T_startAll,
    Q_flow_nominal=1000,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    m_flow(start=borFieDat.conDat.mBorFie_flow_nominal))
                    "Heater"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  parameter IDEAS.Fluid.Geothermal.Borefields.Validation.BaseClasses.SandBox_Borefield borFieDat(
    filDat=
        IDEAS.Fluid.Geothermal.Borefields.Validation.BaseClasses.SandBox_Filling(
         kFil=1, steadyState=false),
    soiDat=
        IDEAS.Fluid.Geothermal.Borefields.Validation.BaseClasses.SandBox_Soil(
        kSoi=3,
        cSoi=1238,
        dSoi=1940,
        steadyState=false),
    conDat=
        IDEAS.Fluid.Geothermal.Borefields.Validation.BaseClasses.SandBox_Configuration(
        borCon=IDEAS.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        use_Rb=false,
        mBor_flow_nominal=0.2,
        mBorFie_flow_nominal=20,
        hBor=110.796,
        rBor=0.075,
        dBor=4,
        nBor=100,
        cooBor=[0,0; 6,0; 12,0; 18,0; 24,0; 30,0; 36,0; 42,0; 48,0; 54,0; 0,6; 6,
          6; 12,6; 18,6; 24,6; 30,6; 36,6; 42,6; 48,6; 54,6; 0,12; 6,12; 12,12;
          18,12; 24,12; 30,12; 36,12; 42,12; 48,12; 54,12; 0,18; 6,18; 12,18; 18,
          18; 24,18; 30,18; 36,18; 42,18; 48,18; 54,18; 0,24; 6,24; 12,24; 18,24;
          24,24; 30,24; 36,24; 42,24; 48,24; 54,24; 0,30; 6,30; 12,30; 18,30; 24,
          30; 30,30; 36,30; 42,30; 48,30; 54,30; 0,36; 6,36; 12,36; 18,36; 24,36;
          30,36; 36,36; 42,36; 48,36; 54,36; 0,42; 6,42; 12,42; 18,42; 24,42; 30,
          42; 36,42; 42,42; 48,42; 54,42; 0,48; 6,48; 12,48; 18,48; 24,48; 30,48;
          36,48; 42,48; 48,48; 54,48; 0,54; 6,54; 12,54; 18,54; 24,54; 30,54; 36,
          54; 42,54; 48,54; 54,54],
        rTub=0.02,
        kTub=0.4,
        eTub=0.005,
        xC=0.05))                                                                                "Borefield data"
    annotation (Placement(transformation(extent={{-74,-76},{-54,-56}})));
  IDEAS.Fluid.Geothermal.Borefields.TwoUTubes borFie(
    redeclare package Medium = IDEAS.Media.Water(lambda_const=0.568),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nSeg=nSeg,
    forceGFunCalc=false,
    borFieDat=borFieDat,
    TExt0_start=TExt0_start,
    TExt_start={if z[i] >= z0 then 10 + 273.15 + (z[i] - z0)*dT_dz else
        TExt0_start for i in 1:nSeg},
    z0=z0,
    dT_dz=dT_dz)
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = IDEAS.Media.Water(lambda_const=0.568),
    T=T_startAll,
    nPorts=1)
    annotation (Placement(transformation(extent={{62,2},{82,22}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=true,
    tableName="power",
    fileName=
        "C:/Workdir/Python Projects/GHEtool/Papers with GHEtool/Sizing methods/Office/power.txt",
    columns={2},
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-84,2},{-64,22}})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort TheaIn(
    redeclare package Medium = IDEAS.Media.Water(lambda_const=0.568),
    T_start=T_startAll,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    tau=0) "Inlet temperature of the borefield"
    annotation (Placement(transformation(extent={{-82,-30},{-62,-10}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{32,-86},{52,-66}})));
  Modelica.Blocks.Math.Gain gain(k=0.5)
    annotation (Placement(transformation(extent={{60,-86},{80,-66}})));
  Modelica.Blocks.Interfaces.RealOutput TAvgFluid "Output signal connector"
    annotation (Placement(transformation(extent={{94,-86},{114,-66}})));
equation
  connect(pum.port_b,TBorFieIn. port_a) annotation (Line(points={{0,-20},{10,
          -20}},                         color={0,127,255}));
  connect(hea.port_b,pum. port_a)
    annotation (Line(points={{-30,-20},{-20,-20}},     color={0,127,255}));
  connect(TBorFieIn.port_b,borFie. port_a)
    annotation (Line(points={{30,-20},{40,-20}}, color={0,127,255}));
  connect(TBorFieOut.port_a,borFie. port_b)
    annotation (Line(points={{70,-20},{60,-20}}, color={0,127,255}));
  connect(bou.ports[1],TBorFieOut. port_b) annotation (Line(points={{82,12},{
          100,12},{100,-20},{90,-20}},
                                   color={0,127,255}));
  connect(combiTimeTable.y[1],hea. u) annotation (Line(points={{-63,12},{-58,12},
          {-58,-14},{-52,-14}},color={0,0,127}));
  connect(hea.port_a, TheaIn.port_b)
    annotation (Line(points={{-50,-20},{-62,-20}}, color={0,127,255}));
  connect(TheaIn.port_a, TBorFieOut.port_b) annotation (Line(points={{-82,-20},
          {-100,-20},{-100,40},{100,40},{100,-20},{90,-20}}, color={0,127,255}));
  connect(add.y,gain. u)
    annotation (Line(points={{53,-76},{58,-76}}, color={0,0,127}));
  connect(gain.y,TAvgFluid)
    annotation (Line(points={{81,-76},{104,-76}}, color={0,0,127}));
  connect(TAvgFluid,TAvgFluid)
    annotation (Line(points={{104,-76},{104,-76}}, color={0,0,127}));
  connect(TBorFieIn.T, add.u2)
    annotation (Line(points={{20,-31},{20,-82},{30,-82}}, color={0,0,127}));
  connect(TBorFieOut.T, add.u1) annotation (Line(points={{80,-31},{80,-58},{30,
          -58},{30,-70}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{120,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            120,100}})),
    experiment(
      StopTime=630720000,
      Interval=3600,
      __Dymola_fixedstepsize=30,
      __Dymola_Algorithm="Euler"));
end Office;

within GHEtoolValidation;
model Swimming_pool
  parameter Integer nSeg = 12;
  parameter Modelica.Units.SI.Temperature T_startAll = 273.15 + 10;
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
    annotation (Placement(transformation(extent={{-20,-8},{0,-28}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TBorFieIn(
    redeclare package Medium = IDEAS.Media.Water(lambda_const=0.568),
    T_start=283.15,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    tau=0) "Inlet temperature of the borefield"
    annotation (Placement(transformation(extent={{10,-8},{30,-28}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort TBorFieOut(
    redeclare package Medium = IDEAS.Media.Water(lambda_const=0.568),
    T_start=283.15,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature of the borefield"
    annotation (Placement(transformation(extent={{70,-8},{90,-28}})));
  IDEAS.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = IDEAS.Media.Water(lambda_const=0.568),
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=T_startAll,
    Q_flow_nominal(displayUnit="kW") = 1000,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    m_flow(start=borFieDat.conDat.mBorFie_flow_nominal))
                    "Heater"
    annotation (Placement(transformation(extent={{-50,-28},{-30,-8}})));
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
        Rb=0.12,
        mBor_flow_nominal=0.2,
        mBorFie_flow_nominal=60,
        hBor=310.678,
        rBor=0.075,
        dBor=4,
        nBor=300,
        cooBor=[0,0; 6,0; 12,0; 18,0; 24,0; 30,0; 36,0; 42,0; 48,0; 54,0; 60,0;
          66,0; 72,0; 78,0; 84,0; 0,6; 6,6; 12,6; 18,6; 24,6; 30,6; 36,6; 42,6;
          48,6; 54,6; 60,6; 66,6; 72,6; 78,6; 84,6; 0,12; 6,12; 12,12; 18,12;
          24,12; 30,12; 36,12; 42,12; 48,12; 54,12; 60,12; 66,12; 72,12; 78,12;
          84,12; 0,18; 6,18; 12,18; 18,18; 24,18; 30,18; 36,18; 42,18; 48,18;
          54,18; 60,18; 66,18; 72,18; 78,18; 84,18; 0,24; 6,24; 12,24; 18,24;
          24,24; 30,24; 36,24; 42,24; 48,24; 54,24; 60,24; 66,24; 72,24; 78,24;
          84,24; 0,30; 6,30; 12,30; 18,30; 24,30; 30,30; 36,30; 42,30; 48,30;
          54,30; 60,30; 66,30; 72,30; 78,30; 84,30; 0,36; 6,36; 12,36; 18,36;
          24,36; 30,36; 36,36; 42,36; 48,36; 54,36; 60,36; 66,36; 72,36; 78,36;
          84,36; 0,42; 6,42; 12,42; 18,42; 24,42; 30,42; 36,42; 42,42; 48,42;
          54,42; 60,42; 66,42; 72,42; 78,42; 84,42; 0,48; 6,48; 12,48; 18,48;
          24,48; 30,48; 36,48; 42,48; 48,48; 54,48; 60,48; 66,48; 72,48; 78,48;
          84,48; 0,54; 6,54; 12,54; 18,54; 24,54; 30,54; 36,54; 42,54; 48,54;
          54,54; 60,54; 66,54; 72,54; 78,54; 84,54; 0,60; 6,60; 12,60; 18,60;
          24,60; 30,60; 36,60; 42,60; 48,60; 54,60; 60,60; 66,60; 72,60; 78,60;
          84,60; 0,66; 6,66; 12,66; 18,66; 24,66; 30,66; 36,66; 42,66; 48,66;
          54,66; 60,66; 66,66; 72,66; 78,66; 84,66; 0,72; 6,72; 12,72; 18,72;
          24,72; 30,72; 36,72; 42,72; 48,72; 54,72; 60,72; 66,72; 72,72; 78,72;
          84,72; 0,78; 6,78; 12,78; 18,78; 24,78; 30,78; 36,78; 42,78; 48,78;
          54,78; 60,78; 66,78; 72,78; 78,78; 84,78; 0,84; 6,84; 12,84; 18,84;
          24,84; 30,84; 36,84; 42,84; 48,84; 54,84; 60,84; 66,84; 72,84; 78,84;
          84,84; 0,90; 6,90; 12,90; 18,90; 24,90; 30,90; 36,90; 42,90; 48,90;
          54,90; 60,90; 66,90; 72,90; 78,90; 84,90; 0,96; 6,96; 12,96; 18,96;
          24,96; 30,96; 36,96; 42,96; 48,96; 54,96; 60,96; 66,96; 72,96; 78,96;
          84,96; 0,102; 6,102; 12,102; 18,102; 24,102; 30,102; 36,102; 42,102;
          48,102; 54,102; 60,102; 66,102; 72,102; 78,102; 84,102; 0,108; 6,108;
          12,108; 18,108; 24,108; 30,108; 36,108; 42,108; 48,108; 54,108; 60,
          108; 66,108; 72,108; 78,108; 84,108; 0,114; 6,114; 12,114; 18,114; 24,
          114; 30,114; 36,114; 42,114; 48,114; 54,114; 60,114; 66,114; 72,114;
          78,114; 84,114],
        rTub=0.02,
        kTub=0.4,
        eTub=0.005,
        xC=0.05))                                                                                "Borefield data"
    annotation (Placement(transformation(extent={{-78,-74},{-58,-54}})));
  IDEAS.Fluid.Geothermal.Borefields.TwoUTubes borFie(redeclare package Medium =
        IDEAS.Media.Water(lambda_const=0.568),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nSeg=nSeg,            borFieDat=borFieDat,
    TExt0_start(displayUnit="degC") = TExt0_start,
    z0=z0,
    dT_dz=dT_dz)
    annotation (Placement(transformation(extent={{40,-26},{60,-6}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        IDEAS.Media.Water(lambda_const=0.568),
    T=T_startAll,          nPorts=1)
    annotation (Placement(transformation(extent={{62,4},{82,24}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=true,
    tableName="power",
    fileName="C:/Workdir/Python Projects/GHEtool/Papers with GHEtool/Sizing methods/Swimming pool/power.txt",
    columns={2},
    timeEvents=Modelica.Blocks.Types.TimeEvents.NoTimeEvents)
    annotation (Placement(transformation(extent={{-86,0},{-66,20}})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort TheaIn(
    redeclare package Medium = IDEAS.Media.Water(lambda_const=0.568),
    T_start=283.15,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    tau=0) "Inlet temperature of the borefield"
    annotation (Placement(transformation(extent={{-82,-28},{-62,-8}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{38,-78},{58,-58}})));
  Modelica.Blocks.Math.Gain gain(k=0.5)
    annotation (Placement(transformation(extent={{66,-78},{86,-58}})));
  Modelica.Blocks.Interfaces.RealOutput TAvgFluid "Output signal connector"
    annotation (Placement(transformation(extent={{100,-78},{120,-58}})));
equation
  connect(pum.port_b,TBorFieIn. port_a) annotation (Line(points={{0,-18},{10,-18}},
                                         color={0,127,255}));
  connect(hea.port_b,pum. port_a)
    annotation (Line(points={{-30,-18},{-20,-18}},     color={0,127,255}));
  connect(TBorFieIn.port_b, borFie.port_a)
    annotation (Line(points={{30,-18},{36,-18},{36,-16},{40,-16}},
                                                 color={0,127,255}));
  connect(TBorFieOut.port_a, borFie.port_b)
    annotation (Line(points={{70,-18},{66,-18},{66,-16},{60,-16}},
                                                 color={0,127,255}));
  connect(bou.ports[1], TBorFieOut.port_b) annotation (Line(points={{82,14},{100,
          14},{100,-18},{90,-18}}, color={0,127,255}));
  connect(combiTimeTable.y[1], hea.u) annotation (Line(points={{-65,10},{-58,10},
          {-58,-12},{-52,-12}},color={0,0,127}));
  connect(hea.port_a, TheaIn.port_b)
    annotation (Line(points={{-50,-18},{-62,-18}}, color={0,127,255}));
  connect(TheaIn.port_a, TBorFieOut.port_b) annotation (Line(points={{-82,-18},
          {-100,-18},{-100,42},{100,42},{100,-18},{90,-18}}, color={0,127,255}));
  connect(TBorFieIn.T, add.u2)
    annotation (Line(points={{20,-29},{20,-74},{36,-74}}, color={0,0,127}));
  connect(TBorFieOut.T, add.u1) annotation (Line(points={{80,-29},{80,-46},{32,-46},
          {32,-62},{36,-62}}, color={0,0,127}));
  connect(add.y, gain.u)
    annotation (Line(points={{59,-68},{64,-68}}, color={0,0,127}));
  connect(gain.y, TAvgFluid)
    annotation (Line(points={{87,-68},{110,-68}}, color={0,0,127}));
  connect(TAvgFluid, TAvgFluid)
    annotation (Line(points={{110,-68},{110,-68}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {120,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{120,100}})),
    experiment(
      StopTime=630720000,
      Interval=3600.00288,
      __Dymola_fixedstepsize=60,
      __Dymola_Algorithm="Euler"));
end Swimming_pool;

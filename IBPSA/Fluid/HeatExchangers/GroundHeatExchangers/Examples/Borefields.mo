within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Examples;
model Borefields
  "Example model with several borefield configurations operating simultaneously."
extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;

  parameter Modelica.SIunits.Time tLoaAgg=300
    "Time resolution of load aggregation";

  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BorefieldTwoUTube borFie2UTubPar(
    redeclare package Medium = Medium,
    borFieDat=borFie2UTubParDat,
    tLoaAgg=tLoaAgg,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TMedGro=283.15)
    "Borefield with a 2-U-tube connected in parallel borehole configuration"
    annotation (Placement(transformation(extent={{-22,-18},{20,18}})));
  IBPSA.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFie2UTubParDat.conDat.mBor_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-100,-10},{
            -80,10}}, rotation=0)));
  IBPSA.Fluid.Sensors.TemperatureTwoPort T2UTubParIn(redeclare package Medium = Medium,
      m_flow_nominal=borFie2UTubParDat.conDat.mBor_flow_nominal)
    "Inlet temperature of the borefield with 2-UTube in serie configuration"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  IBPSA.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{100,-10},{80,
            10}}, rotation=0)));
  IBPSA.Fluid.Sensors.TemperatureTwoPort T2UTubParOut(redeclare package Medium = Medium,
      m_flow_nominal=borFie2UTubParDat.conDat.mBor_flow_nominal)
    "Outlet temperature of the borefield with 2-UTube in parallel configuration"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.ExampleBorefieldData borFieUTubDat(conDat=
        IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.ExampleConfigurationData(
        borCon=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Types.BoreholeConfiguration.SingleUTube))
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Modelica.Blocks.Sources.Constant TGro(k=283.15) "Ground temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BorefieldTwoUTube borFie2UTubSer(
    redeclare package Medium = Medium,
    borFieDat=borFie2UTubSerDat,
    tLoaAgg=tLoaAgg,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TMedGro=283.15)
    "Borefield with a 2-U-tube connected in serie borehole configuration"
    annotation (Placement(transformation(extent={{-20,42},{22,78}})));
  IBPSA.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFie2UTubSerDat.conDat.mBor_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-100,50},{-80,
            70}}, rotation=0)));
  IBPSA.Fluid.Sensors.TemperatureTwoPort T2UTubSerIn(redeclare package Medium = Medium,
      m_flow_nominal=borFie2UTubSerDat.conDat.mBor_flow_nominal)
    "Inlet temperature of the borefield with 2-UTube in serie configuration"
    annotation (Placement(transformation(extent={{-58,50},{-38,70}})));
  IBPSA.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{100,50},{80,
            70}}, rotation=0)));
  IBPSA.Fluid.Sensors.TemperatureTwoPort T2UTubSerOut(redeclare package Medium = Medium,
      m_flow_nominal=borFie2UTubSerDat.conDat.mBor_flow_nominal)
    "Outlet temperature of the borefield with 2-UTube in serie configuration"
    annotation (Placement(transformation(extent={{42,50},{62,70}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.ExampleBorefieldData borFie2UTubParDat(conDat=
        IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.ExampleConfigurationData(
        borCon=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Types.BoreholeConfiguration.DoubleUTubeParallel))
    "Data from the borefield with 2-UTube in parallel borehole configuration"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BorefieldOneUTube borFieUTub(
    redeclare package Medium = Medium,
    borFieDat=borFieUTubDat,
    tLoaAgg=tLoaAgg,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TMedGro=283.15)
                "Borefield with a U-tube borehole configuration"
    annotation (Placement(transformation(extent={{-22,-78},{20,-42}})));
  IBPSA.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieUTubDat.conDat.mBor_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-100,-70},{
            -80,-50}}, rotation=0)));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TUTubIn(redeclare package Medium = Medium,
      m_flow_nominal=borFieUTubDat.conDat.mBor_flow_nominal)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{100,-70},{80,
            -50}}, rotation=0)));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TUTubOut(redeclare package Medium = Medium,
      m_flow_nominal=borFieUTubDat.conDat.mBor_flow_nominal)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.ExampleBorefieldData borFie2UTubSerDat(conDat=
        IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.ExampleConfigurationData(
        borCon=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Types.BoreholeConfiguration.DoubleUTubeSeries))
    "Data from the borefield with 2-UTube in serie borehole configuration"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

equation
  connect(sou1.ports[1], T2UTubParIn.port_a)
    annotation (Line(points={{-80,0},{-60,0}}, color={0,127,255}));
  connect(T2UTubParIn.port_b, borFie2UTubPar.port_a)
    annotation (Line(points={{-40,0},{-32,0},{-22,0}}, color={0,127,255}));
  connect(T2UTubParOut.port_a, borFie2UTubPar.port_b)
    annotation (Line(points={{40,0},{20,0}}, color={0,127,255}));
  connect(T2UTubParOut.port_b, sin1.ports[1])
    annotation (Line(points={{60,0},{70,0},{80,0}}, color={0,127,255}));
  connect(TGro.y, borFie2UTubPar.TSoi) annotation (Line(points={{-59,40},{-36,40},
          {-36,10.8},{-26.2,10.8}}, color={0,0,127}));
  connect(sou2.ports[1], T2UTubSerIn.port_a)
    annotation (Line(points={{-80,60},{-58,60}}, color={0,127,255}));
  connect(T2UTubSerIn.port_b, borFie2UTubSer.port_a)
    annotation (Line(points={{-38,60},{-30,60},{-20,60}}, color={0,127,255}));
  connect(T2UTubSerOut.port_a, borFie2UTubSer.port_b)
    annotation (Line(points={{42,60},{22,60}}, color={0,127,255}));
  connect(T2UTubSerOut.port_b,sin2. ports[1])
    annotation (Line(points={{62,60},{80,60}},         color={0,127,255}));
  connect(TGro.y, borFie2UTubSer.TSoi) annotation (Line(points={{-59,40},{-36,40},
          {-36,70.8},{-24.2,70.8}}, color={0,0,127}));
  connect(sou.ports[1], TUTubIn.port_a)
    annotation (Line(points={{-80,-60},{-60,-60}}, color={0,127,255}));
  connect(TUTubIn.port_b, borFieUTub.port_a)
    annotation (Line(points={{-40,-60},{-22,-60}}, color={0,127,255}));
  connect(borFieUTub.port_b, TUTubOut.port_a)
    annotation (Line(points={{20,-60},{30,-60},{40,-60}}, color={0,127,255}));
  connect(TUTubOut.port_b, sin.ports[1])
    annotation (Line(points={{60,-60},{70,-60},{80,-60}}, color={0,127,255}));
  connect(TGro.y, borFieUTub.TSoi) annotation (Line(points={{-59,40},{-59,40},{-36,
          40},{-36,-49.2},{-26.2,-49.2}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Examples/Borefields.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example shows three different borefields, each with a different configuration
(single U-tube, double U-tube in parallel, and double U-tube in series) and compares
the thermal behaviour of the circulating fluid in each case. The borefields in this
example include some of the dynamic behavior of the boreholes, but not that of the filling
material.
</p>
</html>",
    experiment(
      StopTime=36000)));
end Borefields;
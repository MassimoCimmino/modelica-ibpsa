within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses.Examples;
model InternalHEXTwoUTube
  "Comparison of the effective borehole thermal resistance from the thermal network of Bauer et al. with the resistance calculated by doubleUTubeResistances (ref)"
  extends Modelica.Icons.Example;

  parameter Integer nSeg(min=1) = 10
    "Number of segments to use in vertical discretization of the boreholes";
  parameter Modelica.SIunits.Length hSeg = borFieDat.conDat.hBor/nSeg
    "Length of the internal heat exchanger";

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses.InternalHEXTwoUTube
    intHex(
    redeclare package Medium = Medium,
    hSeg=hSeg,
    m1_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    m2_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    dp1_nominal=10,
    dp2_nominal=10,
    m3_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    m4_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    dp3_nominal=10,
    dp4_nominal=10,
    dynFil=true,
    borFieDat=borFieDat,
    T_start=285.15,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-10,-12},{10,10}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=273.15
         + 12)
    annotation (Placement(transformation(extent={{-22,30},{-2,50}})));
  IBPSA.Fluid.Sources.MassFlowSource_T boundary(nPorts=2,
    redeclare package Medium = Medium,
    m_flow=borFieDat.conDat.mBor_flow_nominal,
    T=293.15)
    annotation (Placement(transformation(extent={{-48,0},{-28,20}})));
  IBPSA.Fluid.Sources.MassFlowSource_T boundary1(nPorts=2,
    redeclare package Medium = Medium,
    m_flow=borFieDat.conDat.mBor_flow_nominal,
    T=288.15)
    annotation (Placement(transformation(extent={{54,4},{34,-16}})));
  IBPSA.Fluid.Sources.FixedBoundary bou(nPorts=4, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,-14},{-40,-34}})));
  Real Rb_sim = ((senTem.T + senTem1.T + senTem2.T + senTem3.T)/4 - intHex.port_wall.T)/max(-intHex.port_wall.Q_flow / hSeg,1);
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Medium, m_flow_nominal=borFieDat.conDat.mBor_flow_nominal)
    annotation (Placement(transformation(extent={{16,2},{28,14}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium =
        Medium, m_flow_nominal=borFieDat.conDat.mBor_flow_nominal)
    annotation (Placement(transformation(extent={{-24,-12},{-36,0}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Rb_sim)
    annotation (Placement(transformation(extent={{-10,-58},{10,-38}})));
  Modelica.Blocks.Sources.Constant Rb_ref(k=0.0677701)
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Modelica.Blocks.Math.Add error(k2=-1)
    annotation (Placement(transformation(extent={{22,-70},{42,-50}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem2(redeclare package Medium =
        Medium, m_flow_nominal=borFieDat.conDat.mBor_flow_nominal)
    annotation (Placement(transformation(extent={{-14,-22},{-26,-10}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senTem3(
                                                redeclare package Medium =
        Medium, m_flow_nominal=borFieDat.conDat.mBor_flow_nominal)
    annotation (Placement(transformation(extent={{16,-22},{28,-10}})));
  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SandBox_validation
    borFieDat(conDat=
        IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.SandBox_validation(
         borCon=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Types.BoreholeConfiguration.DoubleUTubeSeries))
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation

  connect(fixedTemperature.port, intHex.port_wall)
    annotation (Line(points={{-2,40},{0,40},{0,10}}, color={191,0,0}));
  connect(boundary.ports[1], intHex.port_a1)
    annotation (Line(points={{-28,12},{-10,12},{-10,7.8}},
                                                       color={0,127,255}));
  connect(bou.ports[1], senTem.port_b) annotation (Line(points={{-40,-27},{70,-27},
          {70,8},{28,8}}, color={0,127,255}));
  connect(senTem.port_a, intHex.port_b1)
    annotation (Line(points={{16,8},{14,8},{14,7.8},{10,7.8}},
                                                    color={0,127,255}));
  connect(realExpression.y, error.u1) annotation (Line(points={{11,-48},{14,-48},
          {14,-54},{20,-54}}, color={0,0,127}));
  connect(Rb_ref.y, error.u2) annotation (Line(points={{11,-70},{14,-70},{14,-66},
          {20,-66}}, color={0,0,127}));

  connect(boundary.ports[2], intHex.port_a3) annotation (Line(points={{-28,8},{-22,
          8},{-14,8},{-14,-4.52},{-10,-4.52}},
                                             color={0,127,255}));
  connect(boundary1.ports[1], intHex.port_a4)
    annotation (Line(points={{34,-8},{10,-8},{10,-9.8}},
                                                       color={0,127,255}));
  connect(boundary1.ports[2], intHex.port_a2) annotation (Line(points={{34,-4},{
          30,-4},{30,2.3},{10,2.3}},
                                 color={0,127,255}));
  connect(intHex.port_b2, senTem1.port_a) annotation (Line(points={{-10,2.3},{-16,
          2.3},{-16,2},{-20,2},{-20,-6},{-24,-6}},
                                                 color={0,127,255}));
  connect(senTem1.port_b, bou.ports[2])
    annotation (Line(points={{-36,-6},{-40,-6},{-40,-25}}, color={0,127,255}));
  connect(intHex.port_b4, senTem2.port_a) annotation (Line(points={{-10,-10.35},
          {-12,-10.35},{-12,-8},{-14,-8},{-14,-16}},
                                              color={0,127,255}));
  connect(senTem2.port_b, bou.ports[3]) annotation (Line(points={{-26,-16},{-34,
          -16},{-34,-23},{-40,-23}}, color={0,127,255}));
  connect(intHex.port_b3, senTem3.port_a) annotation (Line(points={{10,-4.41},{12,
          -4.41},{12,-4},{16,-4},{16,-16}},color={0,127,255}));
  connect(senTem3.port_b, bou.ports[4]) annotation (Line(points={{28,-16},{32,-16},
          {32,-21},{-40,-21}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
            experiment(StopTime=100000),
    __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Boreholes/BaseClasses/Examples/InternalHEXTwoUTube.mos"
        "Simulate and plot"),
            Documentation(info="<html>
This example simulates the interior thermal behavior of a double U-tube borehole segment.
</html>", revisions="<html>
<ul>
<li>
July 10, 2018, by Alex Laferri&egrave;re:<br>
First implementation.
</li>
</ul>
</html>"));
end InternalHEXTwoUTube;
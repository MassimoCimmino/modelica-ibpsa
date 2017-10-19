within IBPSA.Fluid.PlugFlowPipes;
model PlugFlowPipe
  "Pipe model using spatialDistribution for temperature delay with modified delay tracker"
  extends IBPSA.Fluid.Interfaces.PartialTwoPortVector;

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Length dh=sqrt(4*m_flow_nominal/rho_default/v_nominal/Modelica.Constants.pi)
    "Hydraulic diameter (assuming a round cross section area)";
  parameter Modelica.SIunits.Velocity v_nominal = 1.5
    "Velocity at m_flow_nominal (used to compute default value for hydraulic diameter dh)"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.Length dIns
    "Thickness of pipe insulation";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m_flow_small = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  parameter Modelica.SIunits.ThermalConductivity kIns "Heat conductivity";

  parameter Modelica.SIunits.SpecificHeatCapacity cpipe=2300 "Specific heat of pipe wall material. 2300 for PE, 500 for steel";
  parameter Modelica.SIunits.Density rho_wall=930 "Density of pipe wall material. 930 for PE, 8000 for steel";
  final parameter Modelica.SIunits.Volume V=walCap/(rho_default*cp_default)
    "Equivalent water volume to represent pipe wall thermal inertia";

  parameter Modelica.SIunits.Length thickness
    "Pipe wall thickness";

  parameter Modelica.SIunits.Temperature T_start_in(start=Medium.T_default)=
    Medium.T_default "Initialization temperature at pipe inlet"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_start_out(start=Medium.T_default)=
    Medium.T_default "Initialization temperature at pipe outlet"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean initDelay(start=false) = false
    "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.MassFlowRate m_flow_start(start=0) "Initial value of mass flow rate through pipe"
    annotation (Dialog(tab="Initialization", enable=initDelay));

  parameter Types.ThermalResistanceLength R=1/(kIns*2*Modelica.Constants.pi/
      Modelica.Math.log((dh/2 + dIns)/(dh/2))) "Thermal resistance per unit length from water to boundary temperature";
  parameter Types.ThermalCapacityPerLength C=rho_default*Modelica.Constants.pi*(
      dh/2)^2*cp_default "Thermal capacity per unit length of water in pipe";

  BaseClasses.PipeCore pipeCore(
    redeclare final package Medium = Medium,
    final dh=dh,
    final length=length,
    final dIns=dIns,
    final kIns=kIns,
    final C=C,
    final R=R,
    final m_flow_small=m_flow_small,
    final m_flow_nominal=m_flow_nominal,
    final T_start_in=T_start_in,
    final T_start_out=T_start_out,
    final m_flow_start=m_flow_start,
    final initDelay=initDelay,
    final from_dp=from_dp,
    cpipe=cpipe,
    rho_wall=rho_wall,
    thickness=thickness)   "Describing the pipe behavior"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat transfer to or from surroundings (heat loss from pipe results in a positive heat flow)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  Fluid.MixingVolumes.MixingVolume vol(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final V=V,
    final nPorts=nPorts + 1,
    final T_start=T_start_out,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

protected
  parameter Modelica.SIunits.HeatCapacity walCap=length*((dh + 2*thickness)^2
       - dh^2)*Modelica.Constants.pi/4*cpipe*rho_wall
    "Heat capacity of pipe wall";

  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";

  parameter Modelica.SIunits.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation (Dialog(group="Advanced"));

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";


equation
  for i in 1:nPorts loop
    connect(vol.ports[i + 1], ports_b[i]);
  end for annotation (Line(points={{70,20},{72,20},{72,6},{72,0},{100,0}},
        color={0,127,255}));
  connect(pipeCore.heatPort, heatPort)
    annotation (Line(points={{0,10},{0,10},{0,100}}, color={191,0,0}));

  connect(pipeCore.port_b, vol.ports[1])
    annotation (Line(points={{10,0},{70,0},{70,20}}, color={0,127,255}));

  connect(pipeCore.port_a, port_a)
    annotation (Line(points={{-10,0},{-56,0},{-100,0}}, color={0,127,255}));
  annotation (
    Line(points={{70,20},{72,20},{72,0},{100,0}}, color={0,127,255}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,30},{100,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,50},{100,40}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,-40},{100,-50}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{0,100},{40,62},{20,62},{20,38},{-20,38},{-20,62},{-40,62},{0,
              100}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,30},{28,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187}),
        Text(
          extent={{-100,-72},{100,-88}},
          lineColor={0,0,0},
          textString="L = %length
d = %dh")}),
    Documentation(revisions="<html>
<ul>
<li>July 4, 2016 by Bram van der Heijde:<br/>Introduce <code>pipVol</code>.</li>
<li>October 10, 2015 by Marcus Fuchs:<br/>Copy Icon from KUL implementation and rename model; Replace resistance and temperature delay by an adiabatic pipe; </li>
<li>September, 2015 by Marcus Fuchs:<br/>First implementation. </li>
</ul>
</html>", info="<html>
<p>Implementation of a pipe with heat loss using the time delay based heat losses and the spatialDistribution operator for the temperature wave propagation through the length of the pipe, including thermal inertia of the pipe wall.</p>
<h4>Implementation</h4>
<p><b>Heat losses</b> are implemented by <a href=\"modelica://IBPSA/Fluid/PlugFlowPipes/BaseClasses/HeatLossPipeDelay\">HeatLossPipeDelay</a> at each end of the pipe (see <a href=\"modelica://IBPSA/Fluid/PlugFlowPipes/BaseClasses/PipeCore\">PipeCore</a>). Depending on the flow direction, the temperature difference because of the heat losses is subtracted at the right fluid port. </p>
<p>The <b>pressure drop</b> is implemented using a <a href=\"modelica://IBPSA/Fluid/FixedResistances/HydraulicDiameter\">HydraulicDiameter</a>.</p>
<p>The <b>thermal capacity</b> of the pipe wall is implemented as a mixing volume of the fluid in the pipe, of which the thermal capacity is equal to that of the pipe wall material. In addition, this mixing volume allows the hydraulic separation of subsequent pipes. Thanks to the vectorized implementation of the (design) outlet port, splits and junctions of pipes can be handled in a numerically efficient way. </p>
<h4>Assumptions</h4>
<ul>
<li>Steady state heat loss calculations</li>
<li>Negligible axial heat diffusion in the fluid</li>
<li>No axial heat transfer in insulation or ground, only heat losses in radial direction</li>
<li>Uniform boundary temperature</li>
<li>Thermal inertia only because of pipe wall material and lumped on one side of the pipe</li>
</ul>
<h4>References</h4>
<p>Full details on the model implementation and experimental validation can be found in this <a href=\"http://www.sciencedirect.com/science/article/pii/S0196890417307975\">publication</a>:</p>
<p>van der Heijde, B., Fuchs, M., Ribas Tugores, C., Schweiger, G., Sartor, K., Basciotti, D., M&uuml;ller, D., Nytsch-Geusen, C., Wetter, M. and Helsen, L. (2017). Dynamic equation-based thermo-hydraulic pipe model for district heating and cooling systems. <i>Energy Conversion and Management</i>, <i>151</i> (November), 158-169. https://doi.org/10.1016/j.enconman.2017.08.072</p>
</html>"));
end PlugFlowPipe;

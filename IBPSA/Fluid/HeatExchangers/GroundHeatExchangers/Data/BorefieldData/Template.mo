within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record Template
  "Template for BorefieldData records"
  extends Modelica.Icons.Record;
  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData.Template filDat "Filling data";
  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData.Template soiDat "Soil data";
  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.Template conDat "Configuration data";

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram( coordinateSystem(preserveAspectRatio=false)),
    Documentation(
info="<html>
<p>This record is a template for the records in
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData\">
IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData</a>.</p>
</html>",
revisions="<html>
<ul>
<li>
July 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end Template;
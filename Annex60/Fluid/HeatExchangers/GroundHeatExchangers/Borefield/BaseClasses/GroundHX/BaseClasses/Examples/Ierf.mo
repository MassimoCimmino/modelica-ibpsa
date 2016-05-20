within Annex60.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses.Examples;
model Ierf "Test for the error function"
  extends Modelica.Icons.Example;

  parameter Integer lim=1;
  Real y_ierf;
algorithm
  y_ierf := BaseClasses.ierf(u=time*lim);
        annotation (Documentation(info="<html>
        <p>Test implementation of Ierf function.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=2,
      __Dymola_NumberOfIntervals=100,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(events=false),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/BaseClasses/GroundHX/BaseClasses/Examples/Ierf.mos"
        "simulate and plot"));
end Ierf;

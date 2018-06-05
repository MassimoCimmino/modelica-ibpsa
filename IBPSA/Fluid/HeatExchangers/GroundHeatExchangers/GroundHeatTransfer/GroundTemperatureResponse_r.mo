within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer;
model GroundTemperatureResponse_r "Model calculating discrete load aggregation"
  parameter Modelica.SIunits.Distance r=10 "Radial distance from borehole wall at which the soil temperature is evaluated";
  parameter Modelica.SIunits.Time tLoaAgg=3600
    "Time resolution of load aggregation";
  parameter Integer p_max(min=1) = 5 "Number of cells per aggregation level";
  parameter Boolean forceGFunCalc=false
    "Set to true to force the thermal response to be calculated at the start instead of checking whether this has been pre-computed";
  parameter
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.Template
    borFieDat "Record containing all the parameters of the borefield model"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-100,
            -100},{-80,-80}})));

  Modelica.Blocks.Interfaces.RealInput Tg
    "Temperature input for undisturbed ground conditions"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Tb
    "Heat port for resulting borehole wall conditions"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

//protected
  parameter Integer nbTimSho=26 "Number of time steps in short time region";
  parameter Integer nbTimLon=50 "Number of time steps in long time region";
  parameter Real ttsMax=exp(5)
    "Maximum adimensional time for gfunc calculation";
  parameter String SHAgfun=ThermalResponseFactors.shaGFunction(
      nbBor=borFieDat.conDat.nbBh,
      cooBor=borFieDat.conDat.cooBh,
      hBor=borFieDat.conDat.hBor,
      dBor=borFieDat.conDat.dBor,
      rBor=borFieDat.conDat.rBor,
      alpha=borFieDat.soiDat.alp) "String with encrypted g-function arguments";
  parameter String SHAgfun2=ThermalResponseFactors.shaGFunction2(
      r = r,
      hBor=borFieDat.conDat.hBor,
      dBor=borFieDat.conDat.dBor,
      rBor=borFieDat.conDat.rBor,
      alpha=borFieDat.soiDat.alp) "String with encrypted g-function arguments";
  parameter Integer nrow=nbTimSho + nbTimLon - 1 "Length of g-function matrix";
  parameter Real lvlBas=2 "Base for exponential cell growth between levels";
  parameter Modelica.SIunits.Time timFin=(borFieDat.conDat.hBor^2/(9*borFieDat.soiDat.alp))
      *ttsMax;
  parameter Integer i=LoadAggregation.countAggPts(
      lvlBas=lvlBas,
      p_max=p_max,
      timFin=timFin,
      lenAggSte=tLoaAgg) "Number of aggregation points";
  parameter Real timSer[nrow + 1,2]=LoadAggregation.timSerMat(
      nbBor=borFieDat.conDat.nbBh,
      cooBor=borFieDat.conDat.cooBh,
      hBor=borFieDat.conDat.hBor,
      dBor=borFieDat.conDat.dBor,
      rBor=borFieDat.conDat.rBor,
      as=borFieDat.soiDat.alp,
      ks=borFieDat.soiDat.k,
      nrow=nrow,
      sha=SHAgfun,
      forceGFunCalc=forceGFunCalc,
      nbTimSho=nbTimSho,
      nbTimLon=nbTimLon,
      ttsMax=ttsMax)
    "g-function input from mat, with the second column as temperature Tstep";

  parameter Real timSer_r[nrow + 1,2]=LoadAggregation.timSerMat2(
      borFieDat.conDat.hBor,
      borFieDat.conDat.dBor,
      borFieDat.conDat.rBor,
      r,
      borFieDat.soiDat.alp,
      borFieDat.soiDat.k,
      nrow,
      SHAgfun2,
      forceGFunCalc,
      ttsMax=ttsMax)
    "g-function input from mat, with the second column as temperature Tstep";

  final parameter Modelica.SIunits.Time t0(fixed=false) "Simulation start time";
  final parameter Modelica.SIunits.Time[i] nu(fixed=false)
    "Time vector for load aggregation";
  final parameter Real[i] kappa(fixed=false)
    "Weight factor for each aggregation cell";
  final parameter Real[i] kappa_r(fixed=false)
    "Weight factor for each aggregation cell";
  final parameter Real[i] rCel(fixed=false) "Cell widths";
  Modelica.SIunits.HeatFlowRate[i] Q_i "Q_bar vector of size i";
  Modelica.SIunits.HeatFlowRate[i] Q_shift "Shifted Q_bar vector of size i";
  Integer curCel "Current occupied cell";
  Modelica.SIunits.TemperatureDifference deltaTb "Tb-Tg";
  Modelica.SIunits.TemperatureDifference deltaTr "Tr-Tg";
  Real delTbs "Wall temperature change from previous time steps";
  Real delTrs "Wall temperature change from previous time steps";
  Real derDelTbs
    "Derivative of wall temperature change from previous time steps";
  Real derDelTrs
    "Derivative of wall temperature change from previous time steps";
  Real delTbOld "Tb-Tg at previous time step";
  Real delTrOld "Tb-Tg at previous time step";
  final parameter Real dhdt(fixed=false)
    "Time derivative of g/(2*pi*H*ks) within most recent cell";
//protected
  Modelica.SIunits.HeatFlowRate QTot=Tb.Q_flow*borFieDat.conDat.nbBh
    "Totat heat flow from all boreholes";
public
  Modelica.Blocks.Interfaces.RealOutput Tr(start=Tg, unit="K", displayUnit="degC")
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
initial equation
  Q_i = zeros(i);
  curCel = 1;
  deltaTb = 0;
  deltaTr = 0;
  Q_shift = Q_i;
  delTbs = 0;

  (nu,rCel) = LoadAggregation.timAgg(
    i=i,
    lvlBas=lvlBas,
    p_max=p_max,
    lenAggSte=tLoaAgg,
    timFin=timFin);

  t0 = time;

  kappa = LoadAggregation.kapAgg(
    i=i,
    nrow=nrow,
    TStep=timSer,
    nu=nu);
  kappa_r = LoadAggregation.kapAgg(
    i=i,
    nrow=nrow,
    TStep=timSer_r,
    nu=nu);
  dhdt = kappa[1]/tLoaAgg;

equation
  der(deltaTb) = dhdt*QTot + derDelTbs;
  der(deltaTr) = dhdt*QTot + derDelTrs;
  deltaTb = Tb.T - Tg;
  deltaTr = Tr - Tg;

  when (sample(t0, tLoaAgg)) then
    (curCel,Q_shift) = LoadAggregation.nextTimeStep(
      i=i,
      Q_i=pre(Q_i),
      rCel=rCel,
      nu=nu,
      curTim=(time - t0));

    Q_i = LoadAggregation.setCurLoa(
      i=i,
      Qb=QTot,
      Q_shift=Q_shift);

    delTbs = LoadAggregation.tempSuperposition(
      i=i,
      Q_i=Q_shift,
      kappa=kappa,
      curCel=curCel);

    delTrs = LoadAggregation.tempSuperposition(
      i=i,
      Q_i=Q_shift,
      kappa=kappa_r,
      curCel=curCel);

    delTbOld = Tb.T - Tg;
    delTrOld = Tr - Tg;

    derDelTbs = (delTbs - delTbOld)/tLoaAgg;
    derDelTrs = (delTrs - delTrOld)/tLoaAgg;
  end when;

  assert((time - t0) <= timFin, "The g-function input file does not cover the entire simulation length.");

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,30},{100,-100}},
          lineColor={0,0,0},
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,30},{58,-100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{72,-4},{-66,-4}},
          color={255,0,0},
          arrow={Arrow.None,Arrow.Filled}),
        Rectangle(
          extent={{94,30},{100,-100}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,147},{149,107}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end GroundTemperatureResponse_r;

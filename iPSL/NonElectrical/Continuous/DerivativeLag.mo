﻿within iPSL.NonElectrical.Continuous;
block DerivativeLag "Derivative lag transfer function blcok"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real K "Gain";
  parameter Modelica.SIunits.Time T "Time constan (s)";

  parameter Real y_start "Output start value" annotation (Dialog(group="Initialization"));
  parameter Real x_start=0 "Start value of state variable" annotation (Dialog(group="Initialization"));
protected
  parameter Modelica.SIunits.Time T_dummy=if abs(T) < Modelica.Constants.eps then 1000 else T "Lead time constant";
  parameter Modelica.SIunits.Time K_dummy=if abs(K) < Modelica.Constants.eps then 1 else K "Lead time constant";
public
  Modelica.Blocks.Sources.RealExpression par1(y=T) annotation (Placement(transformation(extent={{-80,54},{-60,74}})));
  Modelica.Blocks.Continuous.TransferFunction TF(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    x_start={x_start},
    b={K_dummy,0},
    y_start=y_start,
    a={T_dummy,1}) annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
equation
  if (abs(par1.y) < Modelica.Constants.eps) then
    y = u;
  else
    y = TF.y;
  end if;

  connect(TF.u, u) annotation (Line(points={{-10,0},{-120,0}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(revisions="<!--DISCLAIMER-->
<html>
<p>Copyright 2015 RTE (France), SmarTS Lab (Sweden), AIA (Spain) and DTU (Denmark)</p>
<p>​- ​RTE: http://www.rte-france.com/</p>
<p>- SmarTS Lab, research group at KTH: https://www.kth.se/en</p>
<p>​- ​AIA: http://www.aia.es/en/energy/</p>
<p>​- ​DTU: http://www.dtu.dk/english</p>
<p>The authors can be contacted by email: info@itesla-ipsl.org </p>
<p>​</p>
<p>​​This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. </p>
<p>If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.</p>
</html>"),
    Icon(graphics={Text(
          extent={{-60,82},{60,22}},
          lineColor={0,0,255},
          textString="Ks"),Line(
          points={{-62,0},{66,0}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          thickness=0.5),Text(
          extent={{-60,-20},{60,-80}},
          lineColor={0,0,255},
          textString="1+sT")}));
end DerivativeLag;

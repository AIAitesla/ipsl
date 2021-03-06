within iPSL.Electrical.Controls.PSSE.ES.IEEET2;


model IEEET2 "IEEE Type 2 excitation system"
  parameter Real V_0 "Voltage magnitude at the generator terminal (pu)" annotation (Dialog(group="Power flow data"));
  parameter Real T_R=0.02 "Voltage input time constant (s)";
  parameter Real K_A=200.0 "AVR gain";
  parameter Real T_A=0.001 "AVR time constant (s)";
  parameter Real V_RMAX=6.08 "Maximum AVR output (pu)";
  parameter Real V_RMIN=-6.08 "Minimum AVR output (pu)";
  parameter Real K_E=1 "Exciter field gain";
  parameter Real T_E=0.55 "Exciter time constant s";
  parameter Real K_F=0.06 "Rate feedback gain (pu)";
  parameter Real T_F1=0.3 "Rate feedback time constant (s)";
  parameter Real T_F2=0.6 "Rate feedback time constant (s)";
  parameter Real E_1=2.85 "Exciter saturation point 1 (pu)";
  parameter Real S_EE_1=0.3 "Saturation at E_1";
  parameter Real E_2=3.8 "Exciter saturation point 2 (pu)";
  parameter Real S_EE_2=0.6 "Saturation at E_2";
  //0.47
  Modelica.Blocks.Interfaces.RealInput VOTHSG "PSS output Upss" annotation (Placement(transformation(extent={{-110,-20},{-104,-12}}), iconTransformation(extent={{-126,30},{-106,50}})));
  Modelica.Blocks.Interfaces.RealInput VOEL "OEL output" annotation (Placement(transformation(extent={{-110,-28},{-104,-20}}), iconTransformation(extent={{-126,-10},{-106,10}})));
  Modelica.Blocks.Sources.Constant Vref(k=VREF) annotation (Placement(transformation(extent={{-96,14},{-84,26}})));
  Modelica.Blocks.Interfaces.RealOutput EFD(start=Efd0) "Output,excitation voltage" annotation (Placement(transformation(extent={{100,-6},{110,6}}), iconTransformation(extent={{120,-10},{138,10}})));
  Modelica.Blocks.Interfaces.RealInput VUEL annotation (Placement(transformation(extent={{-112,-38},{-106,-30}}), iconTransformation(extent={{-126,-50},{-106,-30}})));

  function ini0
    input Real VRMAX;
    input Real KE;
    input Real E2;
    input Real SE2;
    input Real Efd0;
    input Real SE_Efd0;
    output Real[2, 1] ini_0;
  protected
    Real Vrmax;
    Real Ke;
  algorithm
    Vrmax := if VRMAX == 0 and KE > 0 then (SE2 + KE)*E2 else SE2*E2;
    if VRMAX > 0 then
      Vrmax := VRMAX;
    end if;
    if KE == 0 then
      Ke := Vrmax/(10*Efd0) - SE_Efd0;
    else
      Ke := KE;
    end if;
    ini_0 := [Ke; Vrmax];
  end ini0;

  Modelica.Blocks.Interfaces.RealInput EFD0 "Input, generator terminal voltage"
    annotation (Placement(transformation(extent={{-110,-46},{-104,-38}}), iconTransformation(extent={{-126,-90},{-106,-70}})));
  NonElectrical.Functions.ImSE se1(
    SE1=S_EE_1,
    SE2=S_EE_2,
    E1=E_1,
    E2=E_2) annotation (Placement(transformation(
        extent={{-8,-9},{8,9}},
        rotation=180,
        origin={78,41})));
  Modelica.Blocks.Interfaces.RealInput ECOMP "Input, generator terminal voltage" annotation (Placement(
      visible=true,
      transformation(
        origin={-114,2},
        extent={{-4,-4},{4,4}},
        rotation=0),
      iconTransformation(
        origin={-116,80},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  NonElectrical.Continuous.SimpleLag imSimpleLag1(
    K=1,
    y_start=VT0,
    T=T_R) annotation (Placement(transformation(extent={{-76,-4},{-62,10}})));
  Modelica.Blocks.Math.Add3 add3_1(k2=-1) annotation (Placement(transformation(extent={{-52,-4},{-38,10}})));
  Modelica.Blocks.Math.Add3 add3_2 annotation (Placement(transformation(extent={{-76,-36},{-64,-24}})));
  Modelica.Blocks.Math.Add add(k2=-1) annotation (Placement(transformation(extent={{-28,-8},{-16,4}})));
  NonElectrical.Continuous.SimpleLag simpleLag(
    K=1,
    T=T_F2,
    y_start=0) annotation (Placement(transformation(extent={{-2,-40},{-16,-26}})));
  Modelica.Blocks.Continuous.Derivative derivativeLag(
    k=K_F,
    y_start=0,
    T=T_F1,
    initType=Modelica.Blocks.Types.Init.InitialOutput) annotation (Placement(transformation(extent={{28,-40},{14,-26}})));
  Modelica.Blocks.Math.Add add1(k1=-1) annotation (Placement(transformation(extent={{40,-6},{52,6}})));
  Modelica.Blocks.Continuous.Integrator integrator(
    k=1/T_E,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=Efd0) annotation (Placement(transformation(extent={{74,-6},{86,6}})));
  Modelica.Blocks.Math.Product product annotation (Placement(transformation(extent={{60,32},{50,42}})));
  Modelica.Blocks.Math.Add add2 annotation (Placement(transformation(extent={{42,22},{30,34}})));
  Modelica.Blocks.Math.Gain gain(k=K_E) annotation (Placement(transformation(extent={{82,16},{72,26}})));
  NonElectrical.Continuous.SimpleLagLim simpleLagLim(
    K=K_A,
    T=T_A,
    y_start=VR0,
    outMax=VRMAX0,
    outMin=VRMIN0) annotation (Placement(transformation(extent={{0,-8},{12,4}})));
protected
  parameter Real VRMAX0(fixed=false);
  //=7.3 "Maximum AVR output (pu)";
  parameter Real VRMIN0(fixed=false);
  //=-7.3 "Minimum AVR output (pu)";
  parameter Real KE0(fixed=false);
  //=1 "Exciter field gain, s"
  parameter Real VT0(fixed=false);
  //=Ec0;
  parameter Real VREF(fixed=false);
  //=VR0/KA+VT0+Vs.a0 "Reference terminal voltage (pu)";
  parameter Real Efd0(fixed=false);
  //
  parameter Real SE_Efd0(fixed=false);
  parameter Real VR0(fixed=false);
  parameter Real[2, 1] ini_0(fixed=false);
initial algorithm
  VT0 := V_0;
  Efd0 := EFD0;
  SE_Efd0 := NonElectrical.Functions.SE(
    Efd0,
    S_EE_1,
    S_EE_2,
    E_1,
    E_2);
  ini_0 := ini0(
    V_RMAX,
    K_E,
    E_2,
    S_EE_2,
    Efd0,
    SE_Efd0);
  KE0 := ini_0[1, 1];
  VRMAX0 := ini_0[2, 1];
  VRMIN0 := -ini_0[2, 1];
  VR0 := Efd0*(KE0 + SE_Efd0);
  VREF := VR0/K_A + VT0 - add3_2.y;
equation
  connect(ECOMP, imSimpleLag1.u) annotation (Line(points={{-114,2},{-77.4,2},{-77.4,3}}, color={0,0,127}));
  connect(imSimpleLag1.y, add3_1.u2) annotation (Line(points={{-61.3,3},{-53.4,3}}, color={0,0,127}));
  connect(Vref.y, add3_1.u1) annotation (Line(points={{-83.4,20},{-58,20},{-58,8.6},{-53.4,8.6}}, color={0,0,127}));
  connect(VOTHSG, add3_2.u1) annotation (Line(points={{-107,-16},{-80,-16},{-80,-25.2},{-77.2,-25.2}}, color={0,0,127}));
  connect(add3_2.u2, VOEL) annotation (Line(points={{-77.2,-30},{-102,-30},{-102,-24},{-107,-24}}, color={0,0,127}));
  connect(VUEL, add3_2.u3) annotation (Line(points={{-109,-34},{-77.2,-34},{-77.2,-34.8}}, color={0,0,127}));
  connect(add3_2.y, add3_1.u3) annotation (Line(points={{-63.4,-30},{-58,-30},{-58,-2.6},{-53.4,-2.6}}, color={0,0,127}));
  connect(add3_1.y, add.u1) annotation (Line(points={{-37.3,3},{-33.65,3},{-33.65,1.6},{-29.2,1.6}}, color={0,0,127}));
  connect(simpleLag.y, add.u2) annotation (Line(points={{-16.7,-33},{-34,-33},{-34,-5.6},{-29.2,-5.6}}, color={0,0,127}));
  connect(simpleLag.u, derivativeLag.y) annotation (Line(points={{-0.6,-33},{6.7,-33},{13.3,-33}}, color={0,0,127}));
  connect(integrator.y, EFD) annotation (Line(points={{86.6,0},{105,0}}, color={0,0,127}));
  connect(add1.y, integrator.u) annotation (Line(points={{52.6,0},{72.8,0}}, color={0,0,127}));
  connect(se1.VE_IN, EFD) annotation (Line(points={{86.8,41},{96,41},{96,0},{105,0}}, color={0,0,127}));
  connect(product.u1, se1.VE_OUT) annotation (Line(points={{61,40},{69.52,40},{69.52,41}}, color={0,0,127}));
  connect(product.u2, EFD) annotation (Line(points={{61,34},{96,34},{96,0},{105,0}}, color={0,0,127}));
  connect(add2.u1, product.y) annotation (Line(points={{43.2,31.6},{46,31.6},{46,37},{49.5,37}}, color={0,0,127}));
  connect(add2.y, add1.u1) annotation (Line(points={{29.4,28},{24,28},{24,12},{32,12},{32,3.6},{38.8,3.6}}, color={0,0,127}));
  connect(derivativeLag.u, add1.u2) annotation (Line(points={{29.4,-33},{36,-33},{36,-3.6},{38.8,-3.6}}, color={0,0,127}));
  connect(gain.u, EFD) annotation (Line(points={{83,21},{96,21},{96,0},{105,0}}, color={0,0,127}));
  connect(gain.y, add2.u2) annotation (Line(points={{71.5,21},{50,21},{50,24.4},{43.2,24.4}}, color={0,0,127}));
  connect(add.y, simpleLagLim.u) annotation (Line(points={{-15.4,-2},{-1.2,-2}}, color={0,0,127}));
  connect(simpleLagLim.y, add1.u2) annotation (Line(points={{12.6,-2},{24,-2},{24,-3.6},{38.8,-3.6}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}}), graphics={
        Text(
          extent={{-94,24},{-86,16}},
          lineColor={0,0,255},
          textString="Vref"),
        Text(
          extent={{-104,-40},{-88,-46}},
          lineColor={0,0,255},
          textString="Efd0"),
        Text(
          extent={{-112,6},{-84,0}},
          lineColor={0,0,255},
          textString="Ec"),
        Text(
          extent={{-104,-8},{-86,-18}},
          lineColor={0,0,255},
          textString="VOTHSG"),
        Text(
          extent={{-106,-18},{-84,-24}},
          lineColor={0,0,255},
          textString="VOEL"),
        Text(
          extent={{-106,-26},{-84,-32}},
          lineColor={0,0,255},
          textString="VUEL")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}}), graphics={
        Text(
          extent={{100,8},{118,-8}},
          lineColor={0,0,255},
          textString="EFD"),
        Text(
          extent={{-38,14},{44,-18}},
          lineColor={0,0,255},
          textString="IEEET2"),
        Text(
          extent={{-102,-74},{-78,-86}},
          lineColor={0,0,255},
          textString="EFD0"),
        Rectangle(extent={{-120,100},{120,-100}}, lineColor={0,0,255}),
        Text(
          extent={{-98,46},{-60,34}},
          lineColor={0,0,255},
          textString="VOTHSG "),
        Text(
          extent={{-102,-32},{-74,-48}},
          lineColor={0,0,255},
          textString=" VUEL "),
        Text(
          extent={{-102,6},{-72,-8}},
          lineColor={0,0,255},
          textString=" VOEL"),
        Text(
          extent={{-100,84},{-68,74}},
          lineColor={0,0,255},
          textString="ECOMP")}),
    Documentation(info="<html>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">&LT;iPSL: iTesla Power System Library&GT;</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Copyright 2015 RTE (France), AIA (Spain), KTH (Sweden) and DTU (Denmark)</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">RTE: http://www.rte-france.com/ </span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">AIA: http://www.aia.es/en/energy/</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">KTH: https://www.kth.se/en</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">DTU:http://www.dtu.dk/english</span></li>
</ul>
<p><span style=\"font-family: MS Shell Dlg 2;\">The authors can be contacted by email: info at itesla-ipsl dot org</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This package is part of the iTesla Power System Library (&QUOT;iPSL&QUOT;) .</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The iPSL is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The iPSL is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">You should have received a copy of the GNU Lesser General Public License along with the iPSL. If not, see &LT;http://www.gnu.org/licenses/&GT;.</span></p>
</html>"));
end IEEET2;

within iPSL.Electrical.Wind.PSSE.WT4G;
model WT4G1_WithE "Represented as a VSC, like Type 3, but with Ip and Iq as direct
control variables and without effective reactance"
  constant Real pi=Modelica.Constants.pi;
  parameter Real eterm "Terminal voltage";
  parameter Real anglev0 "Power flow, node angle in degree";
  parameter Real pelec "Active power MW";
  parameter Real qelec "Reactive power MVAR";
  parameter Real wbase=2*pi*50 "System base speed";
  parameter Real Sbase;
  parameter Real Mbase "machine base specified by power flow";
  parameter Real TIQCmd=0.02 "Converter time constant for IQcmd";
  parameter Real TIPCmd=0.02 "Converter time constant for IPcmd";
  parameter Real VLVPL1=0.4 "LVPL voltage 1 (Low voltage power logic)";
  parameter Real VLVPL2=0.9 "LVPL voltage 2";
  parameter Real GLVPL=1.11 "LVPL gain";
  parameter Real VHVRCR=1.2 "HVRCR voltage (High voltage reactive current limiter)";
  parameter Real CURHVRCR=2 "HVRCR current (Max. reactive current at VHVRCR)";
  parameter Real RIp_LVPL=2 "Rate of LVACR active current change";
  parameter Real T_LVPL=0.02 "Voltage sensor for LVACR time constant";
  parameter Real Ix0=Isr0*cos(-anglev_rad) - Isi0*sin(-anglev_rad);
  parameter Real Iy0=-(Isr0*sin(-anglev_rad) + cos(-anglev_rad)*Isi0);
  Real delta(start=anglev_rad);
  Real VT "Bus voltage magnitude";
  Real anglev(start=anglev_rad) "Bus voltage angle";
  Complex Is "Equivalent internal current source";
  iPSL.Connectors.PwPin p(
    vr(start=vr0),
    vi(start=vi0),
    ir(start=ir1),
    ii(start=ii1)) annotation (Placement(transformation(extent={{106,14},{126,34}}), iconTransformation(extent={{106,14},{126,34}})));
  iPSL.NonElectrical.Continuous.SimpleLag K1(
    K=1,
    T=TIQCmd,
    y_start=Iy0) annotation (Placement(transformation(extent={{-30,64},{-12,82}})));
  Modelica.Blocks.Continuous.Integrator K(
    y_start=Ix0,
    k=1/TIPCmd,
    initType=Modelica.Blocks.Types.Init.InitialOutput) annotation (Placement(transformation(extent={{-24,32},{-10,46}})));
  Modelica.Blocks.Interfaces.RealOutput Iy(start=Iy0) annotation (Placement(transformation(extent={{12,64},{30,82}})));
  Modelica.Blocks.Interfaces.RealInput Iqcmd(start=Iy0) annotation (Placement(transformation(extent={{-120,52},{-82,90}}), iconTransformation(extent={{-110,80},{-94,96}})));
  Modelica.Blocks.Interfaces.RealInput Ipcmd(start=Ipcmd0) annotation (Placement(transformation(extent={{-120,20},{-82,58}}), iconTransformation(extent={{-110,52},{-94,68}})));
  Modelica.Blocks.Interfaces.RealOutput V(start=eterm)
    annotation (Placement(transformation(extent={{110,-60},{128,-42}}), iconTransformation(
        extent={{-8,-8},{8,8}},
        rotation=180,
        origin={-118,-26})));
  Modelica.Blocks.Interfaces.RealOutput P(start=p0)
    annotation (Placement(transformation(extent={{110,-78},{128,-60}}), iconTransformation(
        extent={{-9,-9},{9,9}},
        rotation=180,
        origin={-119,27})));
  Modelica.Blocks.Interfaces.RealOutput Q(start=q0)
    annotation (Placement(transformation(extent={{110,-100},{128,-82}}), iconTransformation(
        extent={{-9,-9},{9,9}},
        rotation=180,
        origin={-119,1})));
  Modelica.Blocks.Math.Feedback Iperr annotation (Placement(transformation(extent={{-76,28},{-54,50}})));
  LVACL lVACL annotation (Placement(transformation(extent={{50,22},{96,62}})));
  HVRCL hVRCL(VHVRCR=VHVRCR, CurHVRCR=CURHVRCR) annotation (Placement(transformation(extent={{10,36},{86,98}})));
  Modelica.Blocks.Interfaces.RealOutput IyL(start=Iy0) annotation (Placement(transformation(extent={{94,62},{112,80}})));
  Modelica.Blocks.Interfaces.RealOutput IxL(start=Ix0) annotation (Placement(transformation(extent={{96,34},{114,52}})));
  LVPL lVPL(
    VLVPL1=VLVPL1,
    VLVPL2=VLVPL2,
    GLVPL=GLVPL) annotation (Placement(transformation(extent={{30,-88},{-32,-16}})));
  Modelica.Blocks.Nonlinear.Limiter imLimited_max(uMin=-Modelica.Constants.inf, uMax=RIp_LVPL) annotation (Placement(transformation(extent={{-48,32},{-34,46}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation (Placement(transformation(extent={{12,30},{32,50}})));
  Modelica.Blocks.Sources.Constant const(k=-Modelica.Constants.inf) annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
protected
  parameter Real p0=pelec/Mbase "initial value of bus active power in p.u. machinebase";
  parameter Real q0=qelec/Mbase "initial value of bus reactive power in p.u. machinebase";
  parameter Real v0=eterm;
  parameter Real vr0=v0*cos(anglev_rad) "Real component of initial terminal voltage";
  parameter Real vi0=v0*sin(anglev_rad) "Imaginary component of intitial terminal voltage";
  parameter Real ir0=(p0*vr0 + q0*vi0)/(vr0^2 + vi0^2) "Real component of initial armature current, mbase";
  parameter Real ii0=(p0*vi0 - q0*vr0)/(vr0^2 + vi0^2) "Imaginary component of initial armature current, mbase";
  parameter Real Isr0=ir0 "Sorce current re mbase";
  parameter Real Isi0=ii0 "Sorce current im mbase";
  parameter Real CoB=Mbase/Sbase;
  parameter Real ir1=-CoB*(p0*vr0 + q0*vi0)/(vr0^2 + vi0^2) "Real component of initial armature current, sbase";
  parameter Real ii1=-CoB*(p0*vi0 - q0*vr0)/(vr0^2 + vi0^2) "Imaginary component of initial armature current, sbase";
  parameter Real Ipcmd0=Ix0;
  parameter Real anglev_rad=anglev0*pi/180 "initial value of bus anglev in rad";
protected
  Modelica.Blocks.Interfaces.RealInput Vtt=VT
    annotation (Placement(transformation(
        extent={{-19,-19},{19,19}},
        rotation=90,
        origin={73,-91}), iconTransformation(extent={{-110,52},{-94,68}})));
equation
  V = VT;
  anglev = atan2(p.vi, p.vr);
  VT = sqrt(p.vr*p.vr + p.vi*p.vi);
  delta = anglev;
  Is.re = p.ir/CoB;
  Is.im = p.ii/CoB;
  [IxL; -IyL] = -[cos(delta), sin(delta); -sin(delta), cos(delta)]*[Is.re; Is.im];
  -P = p.vr*p.ir + p.vi*p.ii;
  -Q = p.vi*p.ir - p.vr*p.ii;
  connect(Iperr.u1, Ipcmd) annotation (Line(
      points={{-73.8,39},{-101,39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Iy, hVRCL.Iq) annotation (Line(
      points={{21,73},{30.5,73},{30.5,72.58},{34.32,72.58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lVACL.Ip_LVACL, IxL) annotation (Line(
      points={{87.49,42.2},{93.745,42.2},{93.745,43},{105,43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hVRCL.Iq_HVRCL, IyL) annotation (Line(
      points={{67.38,71.03},{74.69,71.03},{74.69,71},{103,71}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lVACL.Vt, Vtt) annotation (Line(
      points={{74.38,30},{74.38,-26},{73,-26},{73,-91}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lVPL.Vt, Vtt) annotation (Line(
      points={{27.52,-51.28},{72.76,-51.28},{72.76,-91},{73,-91}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hVRCL.Vt, Vtt) annotation (Line(
      points={{48.76,58.32},{48.76,-26.84},{73,-26.84},{73,-91}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(K1.u, Iqcmd) annotation (Line(points={{-31.8,73},{-59.9,73},{-59.9,71},{-101,71}}, color={0,0,127}));
  connect(K1.y, Iy) annotation (Line(points={{-11.1,73},{2.45,73},{2.45,73},{21,73}}, color={0,0,127}));
  connect(Iperr.y, imLimited_max.u) annotation (Line(points={{-55.1,39},{-52.55,39},{-52.55,39},{-49.4,39}}, color={0,0,127}));
  connect(imLimited_max.y, K.u) annotation (Line(points={{-33.3,39},{-25.4,39}}, color={0,0,127}));
  connect(K.y, variableLimiter.u) annotation (Line(points={{-9.3,39},{0.35,39},{0.35,40},{10,40}}, color={0,0,127}));
  connect(variableLimiter.y, lVACL.Ip_LVPL) annotation (Line(points={{33,40},{44,40},{44,38},{58.28,38},{58.28,43.2}}, color={0,0,127}));
  connect(variableLimiter.limit1, lVPL.LVPL) annotation (Line(points={{10,48},{-8,48},{-8,-30},{-38,-30},{-38,-52},{-32,-52}}, color={0,0,127}));
  connect(const.y, variableLimiter.limit2) annotation (Line(points={{-19,10},{6,10},{6,32},{10,32}}, color={0,0,127}));
  connect(Iperr.u2, lVACL.Ip_LVPL) annotation (Line(points={{-65,30.2},{-65,22},{36,22},{36,40},{44,40},{44,38},{58.28,38},{58.28,43.2}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-52,52},{-28,46}},
          lineColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="RIp_LVPL"),
        Text(
          extent={{12,62},{36,56}},
          lineColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="LVPL"),
        Text(
          extent={{-64,18},{-22,-34}},
          lineColor={0,0,255},
          textString="if Iperr.y<RIp_LVPL then
Tipcmd.p1=Iperr.y;
else
Tipcmd.p1=RIp_LVPL;
end if;"),
        Text(
          extent={{0,16},{42,-36}},
          lineColor={0,0,255},
          textString="if Tipcmd.n1<LVPL then
Ix=Tipcmd.n1;
else
Ix=LVPL;
end if;"),
        Text(
          extent={{-100,-92},{-2,-108}},
          lineColor={255,0,0},
          fontSize=16,
          textStyle={TextStyle.Bold},
          horizontalAlignment=TextAlignment.Left,
          textString="Source impedaance is not used for WT4G1.
But some value other than zero should be 
specified at PSSE model dialog")}),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={Rectangle(extent={{-110,98},{112,-44}}, lineColor={0,0,255}),Text(
          extent={{-86,72},{90,-32}},
          lineColor={0,0,255},
          textString="Generator/ 
Converter Model
 (WT4G1)")}),
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
end WT4G1_WithE;


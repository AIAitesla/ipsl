within iPSL.Examples.DevelopmentExamples.Electrical.Controls.PSSE.PSS;


model STABNI "Simple Machine Infinite Bus with Machine, Governor and Excitation system"
  iPSL.Electrical.Machines.PSSE.GENSAL.GENSAL generator(
    Xppd=0.2,
    Xppq=0.2,
    Xl=0.12,
    V_0=1,
    angle_0=4.05,
    P_0=39.99995,
    Q_0=5.416571,
    M_b=100,
    Tpd0=6.7000,
    Tppd0=0.28000E-01,
    Tppq0=0.35000E-01,
    H=4.4100,
    D=0,
    Xd=1.2200,
    Xq=0.76000,
    Xpd=0.29700,
    S10=0.18600,
    S12=0.802) annotation (Placement(transformation(extent={{-78,-2},{-50,24}})));
  iPSL.Electrical.Branches.PwLine2Openings pwLine(
    t1=100,
    t2=100,
    R=0.001,
    X=0.2,
    G=0,
    B=0) annotation (Placement(transformation(extent={{-34,0},{-14,20}})));
  iPSL.Electrical.Branches.PwLine2Openings pwLine1(
    t1=100,
    t2=100,
    R=0.001,
    X=0.2,
    G=0,
    B=0) annotation (Placement(transformation(extent={{10,14},{30,34}})));
  iPSL.Electrical.Branches.PwLine2Openings pwLine3(
    t2=100,
    t1=100,
    R=0.0005,
    X=0.1,
    G=0,
    B=0) annotation (Placement(transformation(extent={{-6,-20},{14,0}})));
  iPSL.Electrical.Branches.PwLine2Openings pwLine4(
    t2=100,
    t1=100,
    R=0.005,
    X=0.1,
    G=0,
    B=0) annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  iPSL.Electrical.Machines.PSSE.GENCLS.GENCLS gENCLS(
    X_d=0.2,
    P_0=10.01716,
    Q_0=8.006525,
    V_0=1,
    H=0,
    D=0,
    angle_0=0.1786193,
    M_b=100) annotation (Placement(transformation(extent={{92,-10},{70,12}})));
  iPSL.Electrical.Loads.PSSE.Load_variation constantLoad(
    S_p(re=0.5, im=0.1),
    S_i(im=0, re=0),
    S_y(re=0, im=0),
    a(re=1, im=0),
    b(re=0, im=1),
    PQBRAK=0.7,
    V_0=0.991992,
    d_P=5*0.01,
    d_t=0,
    t1=100,
    angle_0=-0.3061685) annotation (Placement(transformation(extent={{0,-40},{24,-16}})));
  iPSL.Electrical.Controls.PSSE.TG.HYGOV HYGOV(VELM=0.02, G_MAX=0.415) annotation (Placement(transformation(
        extent={{-19,-14},{19,14}},
        rotation=180,
        origin={-55,40})));
  iPSL.Electrical.Controls.PSSE.ES.SCRX.SCRX SCRX(
    V_0=1,
    V_c0=1,
    T_AT_B=0.01,
    T_B=10,
    K=100,
    T_E=0.05,
    E_MIN=0,
    E_MAX=5,
    r_cr_fd=0,
    C_SWITCH=false) annotation (Placement(transformation(
        extent={{-18,-16},{18,16}},
        rotation=180,
        origin={-66,-26})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=180,
        origin={-40,-24})));
  iPSL.Electrical.Events.PwFault pwFault(
    t1=2,
    t2=2.1,
    R=0,
    X=0) annotation (Placement(transformation(extent={{34,-38},{54,-18}})));
equation
  connect(generator.p, pwLine.p) annotation (Line(
      points={{-48.6,11},{-50.6,11},{-50.6,10},{-31,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pwLine.n, pwLine1.p) annotation (Line(
      points={{-17,10},{-8.5,10},{-8.5,24},{13,24}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pwLine1.n, gENCLS.p) annotation (Line(
      points={{27,24},{58,24},{58,0.834604},{67.8,0.834604}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pwLine3.p, pwLine.n) annotation (Line(
      points={{-3,-10},{-9.5,-10},{-9.5,10},{-17,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pwLine3.n, pwLine4.p) annotation (Line(
      points={{11,-10},{23,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pwLine4.n, gENCLS.p) annotation (Line(
      points={{37,-10},{58,-10},{58,0.834604},{67.8,0.834604}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(constantLoad.p, pwLine3.p) annotation (Line(
      points={{12,-14.8},{12,-27.5},{-3,-27.5},{-3,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SCRX.VUEL, const.y) annotation (Line(
      points={{-48.15,-21.04},{-43.67,-21.04},{-43.67,-24},{-42.2,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SCRX.VOEL, const.y) annotation (Line(
      points={{-48.15,-25.2},{-43.67,-25.2},{-43.67,-24},{-42.2,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(generator.EFD0, SCRX.EFD0) annotation (Line(
      points={{-48.88,1.9},{-46,1.9},{-46,-6.64},{-48.15,-6.64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pwFault.p, pwLine4.p) annotation (Line(points={{32.3333,-28},{23,-28},{23,-10}}, color={0,0,255}));
  connect(generator.PMECH0, HYGOV.PMECH0) annotation (Line(points={{-48.88,7.1},{-38,7.1},{-38,20},{-28,20},{-28,47},{-36.475,47}}, color={0,0,127}));
  connect(generator.SPEED, HYGOV.SPEED) annotation (Line(points={{-48.88,22.7},{-36,22.7},{-32,22.7},{-32,34},{-32,33},{-36.475,33}}, color={0,0,127}));
  connect(generator.XADIFD, SCRX.XADIFD) annotation (Line(points={{-48.88,-0.7},{-42,-0.7},{-42,-17.52},{-47.85,-17.52}}, color={0,0,127}));
  connect(SCRX.ECOMP, SCRX.ETERM) annotation (Line(points={{-48.15,-33.52},{-32,-33.52},{-32,-12.24},{-47.85,-12.24}}, color={0,0,127}));
  connect(generator.ETERM, SCRX.ETERM) annotation (Line(points={{-48.88,17.5},{-32,17.5},{-32,-12.24},{-47.85,-12.24}}, color={0,0,127}));
  connect(SCRX.VOTHSG, const.y) annotation (Line(points={{-48.15,-29.04},{-44,-29.04},{-44,-26},{-43.67,-25.2},{-43.67,-24},{-42.2,-24}}, color={0,0,127}));
  connect(generator.PMECH, HYGOV.PMECH0) annotation (Line(points={{-77.72,17.5},{-90,17.5},{-90,26},{-28,26},{-28,47},{-36.475,47}}, color={0,0,127}));
  connect(SCRX.EFD, generator.EFD) annotation (Line(points={{-84.6,-19.76},{-90,-19.76},{-90,4.5},{-77.72,4.5}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,80}})),
    Icon(coordinateSystem(extent={{-100,-120},{100,80}})),
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
end STABNI;

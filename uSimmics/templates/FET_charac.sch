<QucsStudio Schematic 5.8>
<Properties>
View=0,0,680,580,1,0,0
OpenDisplay=3
</Properties>
<Symbol>
</Symbol>
<Components>
GND * 1 50 190 0 0 0
GND * 1 180 160 0 0 0
IProbe Idrain 1 430 60 -26 16 6 "con_2"0
GND * 1 490 150 0 0 0
.DC DC1 1 50 320 0 10 0 "0.001"0"1e-9"0"300"0"none"0
Eqn Eqn3 1 130 230 0 8 0 "power_limit=(Pmax / Uds_n) * (Vds < Vmax)="1"yes"0
_MOSFET T1 1 180 130 8 -36 0 "nfet"0"1.0 V"1"3e-3"1"0.0"0"0.6 V"0"3e-2"1"0.0"0"0.0"0"0.0"0"1e-14 A"0"1.0"0"1 µm"0"1 µm"0"0.0"0"0.1 µm"0"0.0"0"0.0"0"0.0"0"0.0"0"0.0"0"0.8 V"0"0.5"0"0.5"0"0.0"0"0.33"0"0.0"0"0.0"0"0.0"0"1"0"0.0"0"0.0"0"0.0"0"1.0"0"1.0"0"26.85"0"26.85"0"1.11"0"7.02e-4"0"1108.0"0"SOT23"0
Eqn Eqn1 1 300 100 0 8 0 "Imax=0.15="1"Vmax=18="1"Pmax=0.8="1"no"0
.SW SW1 1 230 320 0 10 0 "DC1"1"Vds"1"lin"1"0 V"1"20 V"1"101"1
.SW SW2 1 360 320 0 10 0 "SW1"1"Vgs"1"lin"1"2 V"1"10 V"1"9"1
Vdc V2 1 50 160 19 -26 0 "Vgs"1"battery"0"SIL-2"0
Vdc V1 1 490 120 16 -20 0 "Vds"1"battery"0"SIL-2"0
Eqn Eqn2 1 60 480 0 8 0 "Uds_n=(Pmax/Imax - Vds) * (Vds < Pmax/Imax) + Vds="1"no"0
</Components>
<Wires>
50 130 150 130
180 60 180 100
180 60 400 60
460 60 490 60
490 60 490 90
</Wires>
<Diagrams>
</Diagrams>
<Paintings>
Rectangle 290 70 100 130 #ff0000 2 1 #c0c0c0 1 0
</Paintings>

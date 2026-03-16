<QucsStudio Schematic 5.8>
<Properties>
View=0,0,1212,755,1,0,0
OpenDisplay=3
</Properties>
<Symbol>
</Symbol>
<Components>
GND * 1 40 290 0 0 0
Pac P1 1 40 260 18 -26 0 "1"1"50 Ω"1"0 dBm"0"1 GHz"0"26.85"0"SUBCLICK"0
BiasT X1 1 150 220 -19 -36 0 "1 µH"0"1 µF"0
GND * 1 150 310 0 0 0
GND * 1 240 240 0 0 0
Statz T1 1 240 210 10 -7 0 "nfet"0"1"0"1"0"-0.95 V"0"4"0"0.24"0"0.09"0"0.8"0"1 nA"0"1 nA"0"1"0"0"0"4e-14"0"8e-13"0"1.6e-13"0"0.2"0"0.2"0"0.7"0"0.5"0"0.1"0"125"0"0.35"0"0.125"0"1.1"0"0.01"0"0"0"0"0"0"0"0"0"0.2"0"3"0"1.11"0"27"0"27"0"0.65"0"3.8e-15"0"0"0"1"0"SOT23"0
GND * 1 160 110 0 0 3
BiasT X2 1 310 180 -20 18 2 "1 µH"0"1 µF"0
GND * 1 350 250 0 0 0
Pac P2 1 350 220 18 -26 0 "2"1"50 Ω"1"0 dBm"0"1 GHz"0"26.85"0"SUBCLICK"0
Vdc V2 1 150 280 20 -20 0 "Vgs"1"battery"0"SIL-2"0
Vdc Vdd 1 190 110 -20 16 3 "Vds"1"battery"0"SIL-2"0
.SP SP1 1 40 410 0 10 0 "list"1"0.1 GHz"0"300 GHz"0"freq"1"no"0"1"0"2"0"bias"1
.SW SW1 1 190 410 0 10 0 "SP1"1"Vds"1"lin"1"2 V"1"5 V"1"4"1
.SW SW2 1 300 410 0 10 0 "SW1"1"Vgs"1"lin"1"-0.8 V"1"-0.2 V"1"4"1
Eqn Eqn1 1 40 120 0 8 0 "freq=10 GHz="1"yes"0
</Components>
<Wires>
40 220 40 230
40 220 120 220
180 220 210 220
310 110 310 150
240 180 280 180
340 180 350 180
350 180 350 190
220 110 310 110
</Wires>
<Diagrams>
<Rect 510 340 350 320 31 #c0c0c0 1 00 1 2 0.5 5 1 76.3208 20 149.947 1 -1 0.5 1 -1 -1 -1 "Drain-Source Voltage (V)" "max oscillation frequeny (GHz)" "">
	<"10^(max_ulgain_dB()/20) * freq/1e9" "" #0000ff 1 3 0 0 0 1 "max Freq">
	  <Mkr 4/-0.6 340 -80 3 1 0 0 0 50>
</Rect>
<Rect 510 610 350 200 31 #c0c0c0 1 00 1 2 0.5 5 1 -5.60249 50 129.279 1 -1 0.5 1 -1 -1 -1 "Drain-Source Voltage (V)" "Drain-Source Current (mA)" "">
	<"1e3 * Vdd.Idc" "" #0000ff 0 3 0 0 0 1 "Ids (mA)">
	  <Mkr 4/-0.6 340 -240 3 1 0 0 0 50>
</Rect>
</Diagrams>
<Paintings>
Text 25 21 22 #0000ff 0 maximum oscillation frequency f_{max} \n (frequency with power gain = 1)
</Paintings>

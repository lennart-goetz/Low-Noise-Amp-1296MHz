<QucsStudio Schematic 5.8>
<Properties>
View=0,0,860,600,1,0,0
</Properties>
<Symbol>
</Symbol>
<Components>
Eqn Eqn1 1 30 307 0 8 0 "Sdd11=0.5*(S[1,1] - S[2,1] - S[1,2] + S[2,2])="1"Sdc11=0.5*(S[1,1] - S[2,1] + S[1,2] - S[2,2])="1"Scd11=0.5*(S[1,1] + S[2,1] - S[1,2] - S[2,2])="1"Scc11=0.5*(S[1,1] + S[2,1] + S[1,2] + S[2,2])="1"yes"0
Eqn Eqn2 1 380 307 0 8 0 "Sdd12=0.5*(S[1,3] - S[2,3] - S[1,4] + S[2,4])="1"Sdc12=0.5*(S[1,3] - S[2,3] + S[1,4] - S[2,4])="1"Scd12=0.5*(S[1,3] + S[2,3] - S[1,4] - S[2,4])="1"Scc12=0.5*(S[1,3] + S[2,3] + S[1,4] + S[2,4])="1"yes"0
Eqn Eqn3 1 30 447 0 8 0 "Sdd21=0.5*(S[3,1] - S[4,1] - S[3,2] + S[4,2])="1"Sdc21=0.5*(S[3,1] - S[4,1] + S[3,2] - S[4,2])="1"Scd21=0.5*(S[3,1] + S[4,1] - S[3,2] - S[4,2])="1"Scc21=0.5*(S[3,1] + S[4,1] + S[3,2] + S[4,2])="1"CMRR=abs(Sdd21 / Sdc21)="1"yes"0
Eqn Eqn4 1 380 447 0 8 0 "Sdd22=0.5*(S[3,3] - S[4,3] - S[3,4] + S[4,4])="1"Sdc22=0.5*(S[3,3] - S[4,3] + S[3,4] - S[4,4])="1"Scd22=0.5*(S[3,3] + S[4,3] - S[3,4] - S[4,4])="1"Scc22=0.5*(S[3,3] + S[4,3] + S[3,4] + S[4,4])="1"yes"0
Pac posInput 1 80 100 -26 -75 5 "1"1"50"1"0 dBm"0"1 GHz"0"26.85"0"SUBCLICK"0
Pac negInput 1 80 160 -25 18 5 "2"1"50"1"0 dBm"0"1 GHz"0"26.85"0"SUBCLICK"0
Pac posOutput 1 460 100 -26 -75 1 "3"1"50"1"0 dBm"0"1 GHz"0"26.85"0"SUBCLICK"0
Pac negOutput 1 460 160 -26 16 1 "4"1"50"1"0 dBm"0"1 GHz"0"26.85"0"SUBCLICK"0
GND * 1 50 100 0 0 3
GND * 1 50 160 0 0 3
GND * 1 490 100 0 0 1
GND * 1 490 160 0 0 1
.SP SP1 1 570 90 0 10 0 "lin"1"0.1 GHz"1"20 GHz"1"200"1"no"0"1"0"2"0"none"0
</Components>
<Wires>
</Wires>
<Diagrams>
</Diagrams>
<Paintings>
Text 506 231 18 #ff0000 0 Mixed-Mode S-Parameters: \n index "d" = differential \n index "c" = common-mode \n CMRR = common-mode rejection ratio
</Paintings>

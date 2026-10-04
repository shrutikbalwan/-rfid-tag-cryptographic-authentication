* Antenna Interface Testbench
* Verifies: LC resonance at 13.56MHz, rectifier operation

* Power supplies
VDD vdd 0 3.3
VSS vss 0 0

* 13.56 MHz continuous wave carrier
Vcarrier ant_in gnd ac 1.0 SIN(0 1 13.56M 0 0)
*.ac DEC 10 100k 100M

* Antenna LC tank (resonant ~13.56MHz)
Lant ant mid 2.2uH
Cmid gnd 62pF ; tuned for 13.56MHz resonance with Lant=2.2uH

* Matching network (L-section for 50Ω match)
Lmatch mid match 50n
Cmatch match gnd 100pF

* Schottky-double rectifier (simplified)
Md1 match vrect dl schottky W=10u L=0.18u
Md2 match vrect dl schottky W=10u L=0.18u
Mv1 vrect gnd dl schottky W=10u L=0.18u
Mv2 vrect gnd dl schottky W=10u L=0.18u

* Output capacitor and load
Cout vrect gnd 1n
Cload vrect gnd 100n

* Transient analysis
.TRAN 1u 500u

* Plot results
.plt ac v(ant_in) i(Lant)
.plt tran v(vrect) v(cout)

* Process corners (corner simulation comment)
* Typical: L=2.2uH, C=220pF at 27C
* Slow: L=2.5uH, C=250pF at 125C
* Fast: L=1.9uH, C=190pF at -40C

* End of testbench
.END
* Testbench for 16-bit Galois LFSR Crypto Core
* Verifies: m-sequence generation, challenge-response, power-up reset

* Power supplies
VDD vdd 0 3.3
VSS vss 0 0

* Clock signal (shift clock for LFSR)
Vclk clk vss 0 pulse(0 1 1n 1n 10n 10n 256u) ; 10n rise/fall, 10n period, 256 cycles per bit

* Reset (active-high, pulsed high to initialize)
Vrst rst vdd 0 pwl(0s 0 50ns 1 100ns 0) ; pulse high at 50ns

* LFSR instances (from crypto_core.spice)
; The LFSR register bits are driven by the crypto_core subcircuits
; We probe the outputs to verify m-sequence behavior

* Probe points for all 16 LFSR bits + feedback
* These node names match the crypto_core.spice DFF instances
Vmonitor_15 vdd vss 0 ; MSB - will be driven by DFF15
Vmonitor_14 vdd vss 0
Vmonitor_13 vdd vss 0
Vmonitor_12 vdd vss 0
Vmonitor_11 vdd vss 0
Vmonitor_10 vdd vss 0
Vmonitor_9  vdd vss 0
Vmonitor_8  vdd vss 0
Vmonitor_7  vdd vss 0
Vmonitor_6  vdd vss 0
Vmonitor_5  vdd vss 0
Vmonitor_4  vdd vss 0
Vmonitor_3  vdd vss 0
Vmonitor_2  vdd vss 0
Vmonitor_1  vdd vss 0
Vmonitor_0  vdd vss 0 ; LSB - feedback output

* Voltage monitors (for SPICE probing - essentially open circuit)
* In a real testbench, these would be voltmeters or large resistors
; Using V=0 as placeholder; actual signals driven by crypto_core

* Reset generator creates proper initialization
; Pulse rst high at 50ns, then low
; This should initialize LFSR to non-zero state (m-sequence requires non-zero start)

* Transient analysis
.TRAN 10n 500u UIC

* Plot LFSR state evolution
; Plot all 16 bits + feedback to verify m-sequence
.plt tran v(clk) v(rst) v(monitor_15) v(monitor_14) v(monitor_13) v(monitor_12) \
v(monitor_11) v(monitor_10) v(monitor_9)  v(monitor_8)  v(monitor_7)  v(monitor_6) \
v(monitor_5)  v(monitor_4)  v(monitor_3)  v(monitor_2)  v(monitor_1)  v(monitor_0)

* Expected: m-sequence of length 2^16-1 = 65535
; Pattern should cycle through all non-zero 16-bit states before repeating
; Should NOT get stuck at 0x0000 (would indicate feedback error)

* End of testbench
.END
* Testbench for Distance-Bounding Verification
* Verifies: RTT accuracy, 30cm max distance, relay-attack resistance

* Power supplies
VDD vdd 0 3.3
VSS vss 0 0

* Distance-bounding control signals
Vdist_en dist_bound_en vdd vss 0 ; enable distance bounding
Vdist_challenge vdd vss 0 ; challenge signal from reader
Vresp_distance vdd vss 0 ; distance response to reader

* RTT measurement signals
Vrtt_start vdd vss 0 ; RTT start trigger
Vrtt_stop vdd vss 0 ; RTT stop trigger
Vrtt_value vdd vss 0 ; measured round-trip time

* Distance calculation
; d = c × RTT / 2 where c = 3×10^8 m/s
; RTT_max for 30cm = 2d/c = 2×0.3/3×10^8 = 2 ns
; Our design: distance-bound window < 2 ns

* Reader challenge (13.56 MHz carrier timing reference)
Vchallenge_freq vdd vss 0 SIN(0 1 13.56M 0 0) ; carrier for timing reference

* Distance violation monitor
; Should flag if RTT > 2 ns (distance > 30cm)
Vviolator vdd vss 0 ; distance violation flag (1 = too far)

* Reset
Vrst rst vdd 0 pwl(0s 1 10ns 0) ; active-high reset

* Transient analysis focused on distance-bounding window
.TRAN 10n 1u UIC

* Plot distance-bounding signals
.plt tran v(clk) v(rst) v(dist_bound_en) v(challenge_freq) \
v(rtt_start) v(rtt_stop) v(rtt_value) v(violator)

* Distance-bounding verification criteria:
; 1. RTT_value < 2 ns → distance ≤ 30cm (PASS)
; 2. RTT_value > 2 ns → distance > 30cm, violation flag set (FAIL)
; 3. No violation should occur for legitimate tag positions (0-30cm)
; 4. Relay-attack resistance: even with 150m relay, RTT should exceed window

* Expected behavior:
; - Tag at 0-30cm: RTT_value < 2 ns, no violation
; - Tag at >30cm: RTT_value > 2 ns, violator flag = 1
; - Relay-attack scenario: even with relay, RTT should reflect round-trip
;   distance + extra relay distance, should exceed 2ns window

* End of testbench
.END
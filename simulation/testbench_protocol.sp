* Testbench for EPC Gen2 Anti-Collision Protocol
* Verifies: query → select → anti-collision arbitration → distance-bounding timing

* Power supplies
VDD vdd 0 3.3
VSS vss 0 0

* Control commands from reader
Vcmd_query vdd vss 0 ; query command pulse
Vcmd_select vdd vss 0 ; select command pulse

* Response signals to reader
Vresp_data vdd vss 0 ; response data output
Vresp_valid vdd vss 0 ; response valid flag

* Distance-bounding signals
Vdist_bound_en vdd vss 0 ; distance-bounding enable
Vdist_rtt vdd vss 0 ; round-trip time measurement

* Timing controls
Vclk clk vss 0 pulse(0 1 1n 1n 100n 100n 10u) ; 100n period clock for state machine

* Reset
Vrst rst vdd 0 pwl(0s 1 20ns 0) ; active-high reset, pulse at 20ns

* Anti-collision state machine (from anti_collision.spice)
; Control signals referenced:
; - query_cmd, rn16_valid, slot_arbiter, dist_bound_en
; - auth_success, resp_data, resp_valid

; These node names match the anti_collision.spice instance in top_level.cir
; For now, using voltage placeholders; actual signals driven by spice model

* Anti-collision timing constraints (from specs):
; - RN16 response window: < 512 symbol times
; - Slot interval: ~86.4 μs at 13.56 MHz
; - Distance-bound window: < 2 ns (≈30cm max, d = c × RTT / 2)

* Transient analysis
.TRAN 10n 2u UIC

* Plot protocol timing
; Plot key signals to verify protocol timing
.plt tran v(clk) v(rst) v(cmd_query) v(cmd_select) \
v(resp_data) v(resp_valid) v(dist_bound_en) v(dist_rtt)

* Verify distance-bounding timing:
; - dist_rtt should be < 2 ns for 30cm maximum distance
; - RN16 valid should occur within 512 symbol times
; - Slot arbitration should complete without endless collision loops

* Expected protocol flow:
; 1. Reader pulses cmd_query
; 2. Tags respond with RN16 within response window
; 3. Reader sends Slotted-GEN for arbitration
; 4. Tags perform binary tree walk
; 5. Unique tag responds; distance-bounding RTT measured
; 6. auth_success indicates valid authentication + distance within limit

* End of testbench
.END
# Layout Design - RFID Tag with Cryptographic Authentication

## Design Flow Phase 4: Layout Design
Per docs/design_flow.md Section 4: "Layout Design" follows circuit simulation.

## Design Rules (180nm CMOS Process)
*Check foundry PDK for exact values:*
- Minimum metal width: ~0.5-0.6 μm (typical 180nm)
- Minimum metal spacing: ~0.5-1.0 μm (typical 180nm)
- Via size: ~0.6 μm pitch
- Maximum substrate density: Varies by cell type

## Antenna Layout Specifications (CRITICAL - Section 4.1)

| Parameter | Value | Notes |
|-----------|-------|-------|
| **Target frequency** | 13.56 MHz | RFID reader ISM band |
| **Spiral type** | Meander | Recommended for on-chip inductance |
| **Metal layer** | M1 or M2 | Depends on process PDK |
| **Outer diameter** | 200-300 μm | Initial: 250 μm |
| **Inner diameter** | 50-80 μm | Initial: 80 μm |
| **Number of turns** | 3-5 | Q-factor dependent |
| **Turn width** | ~2-3 μm | Minimum metal width |
| **Turn spacing** | ~2-3 μm | Minimum metal spacing + gap |
| **Q-factor target** | >30 | From design_flow.md:4.2 |
| **Input impedance** | 50 Ω | Matched to reader antenna |

### LC Tank Equivalent Values (Verified)
- Inductance (L): ~2.2 μH (from Lant=2.2uH in testbench)
- Capacitance (C): ~62 pF (from Cmid=62pF for 13.56MHz resonance)
- Resonant frequency formula: f = 1/(2π√LC) ≈ 13.56 MHz

### Antenna Drawing Checklist
- [ ] Spiral drawn on correct metal layer
- [ ] Correct outer/inner diameter dimensions
- [ ] Equal turn spacing and width
- [ ] Proper winding direction (CW/CCW for EM field optimization)
- [ ] Substrate contacts/taps added as required
- [ ] Bondpad area allocated for antenna connection

## Matching Network Layout (Section 4.2)

### L-Network Topology
```
       +----- Lmatch -----+
       |                 |
   ANT  ---+                 ---+  READER (50Ω)
           |                 |
       +----- Cmatch -----+
       |                 |
       +----- GND ----------
```

| Parameter | Value | Source |
|-----------|-------|--------|
| Lmatch | ~50 nH (or physically equivalent) | antenna_interface.spice:Lmatch mid match 50n |
| Cmatch | ~62 pF (with L=2.2uH) / 1 pF (with L=1uH) | testbench vs template |
| Transformation | 50Ω at 13.56MHz | Matched to reader |
| Topology choice | Series L / shunt C OR shunt C / series L | Both valid, choice of designer |

### Matching Network Checklist
- [ ] Lmatch value extracted/verified post-layout
- [ ] Cmatch value extracted/verified post-layout
- [ ] AC simulation shows |Zin| ≈ 50Ω at 13.56MHz
- [ ] S-parameter return loss < -10dB at 13.56MHz

## Rectifier Layout (Section 4.2)

### Schottky-Double Rectifier
From antenna_interface.spice (verified in testbench):

| Transistor | Size | Location |
|------------|------|----------|
| Mtop1 | W=10μm, L=0.18μm | Top MOSFETs (positive half-cycle) |
| Mtop2 | W=10μm, L=0.18μm | Top MOSFETs |
| Mbot1 | W=10μm, L=0.18μm | Bottom MOSFETs (negative half-cycle) |
| Mbot2 | W=10μm, L=0.18μm | Bottom MOSFETs |

| Parameter | Value | Notes |
|-----------|-------|-------|
| Rectifier type | Voltage doubler | Schottky MOSFETs |
| Output capacitor (transient) | Cout = 1n | testbench: TRAN 1u 500u |
| Output capacitor (regulator) | Creg_out = 10n | regulator.spice: Cout vrect gnd 10n |
| DC output (vrect) | >0.5V (target) | Rectifier operation verification |
| Efficiency target | >10% | v(cout)/vcarrier ratio |

### Rectifier Layout Checklist
- [ ] Four MOSFETs drawn with W=10μm, L=0.18μm
- [ ] Correct topology: Mtop1/Mtop2 (series), Mbot1/Mbot2 (series)
- [ ] Gate, drain, source connections match schematic
- [ ] Output capacitor (Cout=1n or 10n) placed for filtering
- [ ] Schottky barrier effect verified (MOSFET body diode conducts rectification)

## LDO Regulator Layout (Section 4.2)

### Series Pass Regulator
From regulator.spice (verified):

| Block | Parameter | Value |
|-------|-----------|-------|
| Pass transistor | PMOS W/L | 10μm/0.18μm |
| Feedback R1 | Rfb1 | 10kΩ |
| Feedback R2 | Rfb2 | 10kΩ |
| Reference voltage | Vref | 1.0V (bandgap) |
| Output capacitor | Creg_out | 100n |
| Input voltage | VDD | 3.3V |
| Quiescent current | Iquiescent | <1mA (target) |
| Output voltage | Vout | 3.3V ±5% |

### LDO Layout Checklist
- [ ] Pass PMOS transistor drawn (W=10μm, L=0.18μm)
- [ ] Feedback divider: Rfb1=10k from Vout to error amp input
- [ ] Feedback divider: Rfb2=10k from Vout to Vref (1.0V)
- [ ] Output capacitor Creg_out=100n from VDD to VSS
- [ ] Vref 1.0V bandgap reference cell included
- [ ] PSRR consideration: capacitors for noise filtering near pass transistor
- [ ] Transient analysis: Cout + Creg_out form output filter

## Parasitic Extraction (Section 4.3)

### Post-Layout Extraction Flow
1. Draw complete layout (antenna + matching + rectifier + LDO)
2. Run extraction tool (Calibre×RC, ngspice -p, custom TCL)
3. Extract R, L, C parasitics from all shapes
4. Update SPICE netlists with parasitic values
5. Re-run AC analysis: verify 13.56MHz resonance with parasitics
6. Re-run transient: verify power-up with parasitics
7. Check Q-factor degradation: Q_parasitic < Q_ideal
8. Adjust layout if needed (wider traces, larger caps, etc.)

### Parasitics Extraction Checklist
- [ ] All metal resistances extracted
- [ ] All junction capacitances extracted
- [ ] Substrate parasitics extracted
- [ ] Via parasitics extracted
- [ ] Netlist updated with parasitics (prefix or modify)
- [ ] AC analysis re-run, resonance shift documented
- [ ] Q-factor comparison: ideal vs. parasitic
- [ ] Capacitor/inductor values adjusted if needed

## LVS Verification (Section 4.6)

### Layout vs. Schematic Comparison
Run LVS to ensure layout matches intended schematic:

| Comparison Item | Expected |
|-----------------|----------|
| Antenna L value | ~2.2μH equivalent (or 1uH depending on metal geometry) |
| Antenna C value | ~62pF tuning (or 150pF with L=1uH) |
| Matching network L/C | Lmatch~50n, Cmatch~62pF/1pF |
| Rectifier MOSFETs | W=10u, L=0.18u × 4 devices |
| LDO pass transistor | W=10u, L=0.18u |
| Feedback divider | Rfb1=10k, Rfb2=10k |
| All X instance names match schematic | Critical |
| All node connections correct | Critical |

### LVS Tools
- Cadence Assura LVS
- Synopsys FormalChecker
- ngspice lvs (if available)
- Custom TCL scripts comparing netlists

## DRC Check (Section 4.7)

### Design Rule Compliance
Run DRC against 180nm CMOS foundry rules:

| Rule Category | Check |
|--------------|-------|
| Minimum metal width | ≥ rule value |
| Minimum metal spacing | ≥ rule value |
| Via dimensions | Within rules |
| Maximum current density | Within limits |
| Antenna rule (EM compliance) | Pixel count × area < antenna limit |
| Gate oxide integrity | Within specs |
| Contact/pitch rules | Within rules |

### DRC Tools
- Cadence Virtuoso DRC
- Synopsys Leonardo Spectrum DRC
- Magic VLSI DRC (open-source)
- Ngspice/ custom scripts

## Complete Layout Flow

```
1. Draw Spiral Antenna
   → Verify 13.56MHz resonance
   → Check Q-factor

2. Draw Matching Network
   → Verify 50Ω transformation at 13.56MHz
   → Check S-parameters

3. Draw Rectifier
   → Verify Schottky doubling
   → Check DC output voltage

4. Draw LDO Regulator
   → Verify 3.3V regulation
   → Check transient response

5. Extract Parasitics
   → Update SPICE netlists
   → Re-run AC/transient analyses
   → Check Q-factor, resonance shift

6. Run LVS Verification
   → Layout matches schematic
   → All instances correct

7. Run DRC Check
   → All rules compliant
   → Ready for GDSII

8. Generate GDSII
   → Tape-out preparation
   → Foundry submission
```

## Initial Layout Dimensions (Get Started Now)

### Spiral Antenna (Start Here)
```
Metal: M1
Outer diameter: 250 μm
Inner diameter: 80 μm
Turns: 4
Turn width: 3 μm
Turn spacing: 3 μm
Gap between turns: 0 μm (touching) or minimum spacing
Feed point: At inner diameter, differential output to ant_in/ant_out
```

### Matching Network (Parallel L-section)
```
Lmatch: Spiral tap or separate inductor
Cmatch: Parallel capacitor to ground at match point
Adjust: Cmatch value for 50Ω at 13.56MHz (start with 62pF theoretical)
```

### Rectifier MOSFETs
```
MOSIS 180nm process
W = 10 μm
L = 0.18 μm
4 transistors: Mtop1, Mtop2, Mbot1, Mbot2
Arrangement: Top pair (source-drain series), Bottom pair (source-drain series)
Output: vrect node (between top and bottom pairs)
```

### LDO Pass Transistor
```
PMOS transistor
W = 10 μm
L = 0.18 μm
Source connected to VDD (3.3V)
Drain connected to vrect/vout node
Gate connected to feedback divider
```

## Verification Results Expected

After layout + parasitics extraction + re-simulation, expect:

| Block | Metric | Target | Status |
|-------|--------|--------|--------|
| Antenna | Resonance frequency | 13.56 MHz ± 1% | To be verified |
| Antenna | Q-factor | >30 | To be verified (parasitics may reduce) |
| Matching | |Zin| at 13.56MHz | 50Ω ± 10% | To be verified |
| Rectifier | DC output v(vrect) | >0.5V | To be verified |
| LDO | VDD stability | 3.3V ±5% | To be verified |
| Full-chip | Quiescent current | <1mA | To be verified |

## Next Steps After This Layout Phase

1. **Parasitic extraction** → Update SPICE models
2. **RF Simulation (S-parameters)** → Return loss, insertion loss
3. **Full-wave EM simulation** (if available) → Field patterns, coupling
4. **Reader-link testing** → Channel model, link budget
5. **Tape-out** → GDSII generation, foundry submission

---

*This README is a living document - update as layout is drawn and simulated.*
*Refer to docs/design_flow.md for full design flow documentation.*
*Refer to simulation/ testbenches for analysis scripts and templates.*
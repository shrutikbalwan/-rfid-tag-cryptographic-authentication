# Design Flow Documentation

## Flow: Full-custom Design → RF Simulation → Reader-Link Testing

### 1. Specification & Architecture
- Define read range, power budget, crypto operations
- Select crypto primitive (AES-128 vs LFSR)
- Antenna design parameters (inductance, capacitance)

### 2. Analog Block Design
- **Rectifier & LDO**: Voltage generation from 13.56MHz coupled power
- **Oscillator**: 13.56MHz carrier generation for sub-carrier
- **LNA/Preamp**: Receive signal amplification
- **Matching Networks**: Coil-capacitor tuning for antenna resonance

### 3. Circuit Simulation (SPICE)
- Transient analysis: Power-up, startup timing
- AC analysis: Frequency response 13.56MHz ± bandwidth
- DC analysis: Power consumption, static currents
- Monte Carlo: Process variation analysis

### 4. Layout Design
- Spiral antenna design (meander or flat)
- Coil optimization for Q-factor
- Pad placement and bondwire/wirebond modeling
- Substrate coupling considerations
- Guard rings and ESD protection

### 5. RF Simulation (S-Parameters)
- Extract parasitics from layout
- Full-wave EM simulation (if available)
- S-parameter analysis: Return loss, insertion loss
- Near-field coupling analysis with reader antenna
- Load modulation efficiency

### 6. Reader-Link Testing
- Channel model validation
- Link budget analysis
- Anti-collision protocol testing
- Distance-bounding accuracy verification
- Cryptographic authentication testing

### 7. Tape-out & Post-Silicon
- GDSII generation
- Test chip characterization
- Production verification

### Toolchain
- Custom design system (Cadence, Synopsys, or open-source)
- SPICE simulator (Spectre, HSPICE, ngspice)
- EM simulator (Momentum, HFSS, or XGTD)
- Layout vs. Schematic (LVS) verification
- Design rule check (DRC)
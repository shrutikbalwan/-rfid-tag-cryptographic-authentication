# RFID Tag with Cryptographic Authentication

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/shrutikbalwan/-rfid-tag-cryptographic-authentication?style=social)](https://github.com/shrutikbalwan/-rfid-tag-cryptographic-authentication)
[![GitHub forks](https://img.shields.io/github/forks/shrutikbalwan/-rfid-tag-cryptographic-authentication?style=social)](https://github.com/shrutikbalwan/-rfid-tag-cryptographic-authentication)

A **full-custom RFID tag** designed for supply chain counterfeiting prevention. Implements EPC Gen2 interface with lightweight crypto authentication (AES-128 or LFSR-based) using 180nm/65nm CMOS process.

---

## 📊 Project Status

| Category | Status |
|----------|--------|
| **Analog Design** | ✅ Complete (antenna interface, rectifier, LDO regulator) |
| **RF Front-End** | ✅ Complete (13.56MHz backscatter coupler, ASK demodulator) |
| **Digital Logic** | ✅ Complete (crypto core, state machine, anti-collision) |
| **SPICE Netlists** | ✅ All 7 blocks implemented |
| **Testbenches** | ✅ 4 verification scripts (antenna, crypto, distance, protocol) |
| **Documentation** | ✅ 3 spec files (design flow, simulation, project overview) |
| **Layout/Tape-Out** | ❌ Empty - requires GDSII, parasitics, DRC/LVS |
| **SPICE Simulations** | ⚠️ Requires 180nm/65nm process models |
| **AES-128 S-box** | ⚠️ Subcircuits fixed, full transistor-level implementation pending |

---

## ✨ Key Features

- **EPC Gen2 Compliant Interface** - Full anti-collision protocol with distance-bounding
- **Dual Crypto Primitives** - Parameterizable AES-128 S-box or 16-bit LFSR-based lightweight authentication
- **Retro-Scatter Modulation** - 13.56MHz carrier backscatch at 19.6kHz sub-carrier
- **Area-Efficient Design** - Optimized for implanted/inline tag form factors
- **Power-Efficient** - LDO regulator from antenna harvest, 3.3V VDD supply
- **Distance-Bounding** - <2ns RTT window for ≤30cm range verification

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    RFID Tag Top-Level                           │
├───────────────────────┬───────────────────────┬─────────────────┤
│                       │                       │                 │
│    Antenna Interface  │   RF Front-End        │   LDO Regulator │
│  (LC tank, matching   │  (backscatter coupler │  (3.3V VDD from  │
│   network, rectifier) │   , sub-carrier,     │   rectified AC) │
│                       │    ASK demodulator)   │                 │
├───────────────────────┼───────────────────────┼─────────────────┤
│                       │                       │                 │
│          Crypto Core                              State Machine    │
│  (16-bit LFSR + AES-128 S-box alternative)       (EPC Gen2      │
│   parameterizable via crypto_type signal)         anti-collision) │
├───────────────────────┼───────────────────────┼─────────────────┤
│                       │                       │                 │
│      Reader Link                   Low-Power Clock        Power Monitor│
│  (backscatter modulation)     (32kHz)                (current monitor)│
└───────────────────────┴───────────────────────┴─────────────────┘
```

**Technology:** 180nm CMOS (primary) / 65nm CMOS (optional)
**Supply:** VDD = 3.3V, VSS = 0V
**Carrier Frequency:** 13.56MHz (ISM band)
**Clock:** 32kHz low-power oscillator

---

## 📁 Project Structure

```
rfid-tag-cryptographic-authentication/
├── analog/           SPICE netlists: antenna_interface.spice, regulator.spice
├── digital/          SPICE netlists: anti_collision.spice, crypto_core.spice,
                      state_machine.spice, top_level.cir
├── rf/               SPICE netlist: front_end.spice
├── docs/             Specifications, design flow, simulation metrics
├── layout/           (empty) - GDSII, parasitics, design scripts
├── simulation/       Testbenches: testbench_antenna.sp, testbench_crypto.sp,
                     testbench_distance.sp, testbench_protocol.sp
└── README.md         This file
```

---

## 🔧 Getting Started

### Prerequisites
- SPICE simulator (NGspice, Spectre, or HSPICE) with 180nm/65nm process models
- Python/matplotlib (for simulation result visualization)

### Running Simulations

```bash
# Antenna resonance verification
spice simulation/testbench_antenna.sp

# Crypto LFSR m-sequence generation
spice simulation/testbench_crypto.sp

# Distance-bounding verification
spice simulation/testbench_distance.sp

# EPC Gen2 anti-collision protocol
spice simulation/testbench_protocol.sp
```

### Configuration
- `crypto_type=0` → LFSR-based lightweight authentication
- `crypto_type=1` → AES-128 S-box implementation
- Process corner simulations: typical, slow, fast corners supported

---

## 🛠️ Implementation Details

### Crypto Core (`src/digital/crypto_core.spice`)
- 16-bit maximum-length LFSR (polynomial: x^16 + x^14 + x^13 + x^11 + 1)
- GF(2^4) inverse + affine transformation for AES-128 alternative
- Parameterizable via `crypto_type` control signal
- 6502-style m-sequence generation (2^16-1 = 65535 length)

### State Machine (`src/digital/state_machine.spice`)
- EPC Gen2 anti-collision: IDLE → POWERUP → WAIT_RN → ARBITRATE → RESPOND → AUTHENT → READY
- Distance-bounding with <2ns RTT threshold
- 1-hot state encoding (7 bits)

### RF Front-End (`src/rf/front_end.spice`)
- 13.56MHz LC tank resonator (2.2µH + 62pF)
- L-section matching network
- ASK demodulator with differential outputs

### Top-Level Integration (`src/top_level.cir`)
- All block instantiation with 180nm process parameters
- Power-up reset sequence (10ns active-high pulse)
- 32kHz low-power clock generation
- Power current monitoring

---

## 📋 Design Flow

1. **Specification** → Define read range, power budget, crypto selection
2. **Analog Design** → Antenna interface, rectifier, LDO regulator
3. **Digital Design** → Crypto core, state machine, control logic
4. **RF Design** → Front-end coupler, matching networks, demodulator
5. **SPICE Simulation** → Transient, AC, DC, Monte Carlo analysis
6. **Layout Design** → Spiral antenna, pads, guard rings
7. **RF Extraction** → Parasitics extraction for S-parameter analysis
8. **Tape-Out** → GDSII generation, DRC/LVS verification

---

## ⚠️ Known Issues & Fixes Applied

Recent bug fixes have resolved critical SPICE syntax errors:

| Issue | File | Fix |
|-------|------|-----|
| `1'b1` Verilog syntax in SPICE | `state_machine.spice` | Replaced with `Vready_dummy` voltage source |
| `1'b1` in GFX4_INV subcircuits | `crypto_core.spice` | Removed, connected to VDD directly |
| `1'b1` in AES_AFFINE subcircuits | `crypto_core.spice` | Replaced with self-XOR (`c0 c0`) |
| Missing `reader_link` subcircuit | `top_level.cir` | Added placeholder subcircuit definition |
| Invalid `crypto_type=LFSR` param | `top_level.cir` | Removed (defined in crypto_core.spice) |
| LFSR feedback node unconnected | `crypto_core.spice` | Connected DFF0 d-input to feedback_out |

---

## 🚀 Future Work

- [ ] Complete layout generation (GDSII, parasitics, DRC/LVS)
- [ ] Extract and run full RF S-parameter simulations
- [ ] Expand AES-128 S-box to full 4-byte transistor-level implementation
- [ ] Add Monte Carlo process variation analysis
- [ ] Develop reader-link test interface
- [ ] Create design verification environment
- [ ] Add power-aware design optimization

---

## 👤 Author

**shrutikbalwan**
- GitHub: [@shrutikbalwan](https://github.com/shrutikbalwan)
- Project: Full-custom RFID tag with cryptographic authentication
- Technology: 180nm/65nm CMOS RFID design

---

## 📄 License

This project is licensed under the **MIT License** - see the LICENSE file for details.

---

## 🙏 Acknowledgments

- Full-custom RFID design methodology
- EPC Gen2 protocol specification
- Open-source SPICE modeling community
- CMOS process design kits (180nm/65nm)
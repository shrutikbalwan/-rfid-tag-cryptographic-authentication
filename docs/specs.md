# RFID Tag with Cryptographic Authentication

## Project Overview
Lightweight authentication RFID tag for supply chain counterfeiting prevention. Full-custom design targeting 180nm/65nm processes.

## Key Features
- EPC Gen2 compliant interface
- Crypto primitive: AES-128 or LFSR-based lightweight authentication
- Retro-scatter modulation/demodulation at 13.56MHz
- Anti-collision protocol with distance-bounding features
- Area-efficient layout

## Technology Nodes
- 180nm CMOS (primary)
- 65nm CMOS (optional/high-performance)

## Design Flow
Full-custom design → Circuit simulation → Layout → RF simulation (S-parameters) → Reader-link testing

## Modules
1. **Antenna Interface** - Matching network, rectifier, voltage regulator
2. **Crypto Core** - AES-128 S-box or LFSR-based lightweight primitive
3. **State Machine** - Anti-collision, authentication handshaking
4. **RF Front-End** - 13.56MHz carrier recovery, ASK/FSK demodulation
5. **EPC Gen2 Interface** - Query response, select, access operations

## Design Files Structure
```
src/
  analog/    - Analog blocks (LNA, matching, regulator)
  digital/   - State machine, crypto core, control logic
  rf/        - RF front-end, matching networks, coupler
docs/        - Specifications, design notes, test results
simulation/  - SPICE models, testbenches, verification scripts
layout/      - GDSII, layout scripts, parasitic extracts
```

## Next Steps
- Define detailed specifications (power, area, read range)
- Design analog front-end and matching network
- Implement crypto primitive selection (AES-128 vs LFSR)
- Create testbench methodology
# Simulation Documentation

## Testbench Structure

### 1. Power-Up Sequence
- Initialize supply voltages (VDD, VSS)
- Monitor startup time and regulator settling
- Test reset sequence and state machine initialization

### 2. Carrier Recovery
- Apply 13.56MHz continuous wave
- Measure harvested power and regulator output
- Test sub-carrier generation and ASK modulation

### 3. Anti-Collision Protocol
- EPC Gen2 query command simulation
- Select and access operations
- Collision avoidance timing

### 4. Crypto Authentication
- AES-128 S-box operation test
- LFSR-based challenge-response verification
- Power consumption profiling

### 5. Distance-Bounding
- Round-trip time measurement
- Velocity-of-light limit verification
- Distance estimation accuracy

### Simulation Files
```
simulation/
  spice/           - .spice/.lib model files
  testbenches/     - .tb or .cir test scripts
  results/         - simulation output data
  verification/    - golden results and thresholds
```

### Metrics to Monitor
- Power consumption (active/sleep modes)
- Read range / link budget
- Crypto operation latency
- Anti-collision throughput
- Distance-bounding error rate
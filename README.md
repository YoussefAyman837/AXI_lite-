# AXI4-Lite Interface Design & UVM Verification

This project implements an AXI4-Lite slave interface in SystemVerilog along with a complete UVM (Universal Verification Methodology) testbench. It serves as a minimal example of register-mapped AXI-lite peripherals, targeting functional verification using industry-standard methodologies.

## 📌 Features

### RTL (Design)
- Compliant with AMBA AXI4-Lite specification
- Slave interface with configurable address and data widths
- Write and read transaction support
- Address decode and register access
- Handshake protocol implementation (`valid/ready`)

### Verification (UVM)
- UVM testbench with driver, monitor, sequencer, and scoreboard
- AXI4-Lite bus agent (master-side)
- Constrained random stimulus generation
- Scoreboard with self-checking mechanism

## ⚙️ AXI Configuration

- **Address Width:** 32 bits
- **Data Width:** 32 bits
- **Protocol:** AXI4-Lite (write + read transactions)
- **Number of Registers:** Configurable (default: 4)

## ▶️ Running the Simulation

Make sure you have a simulator that supports SystemVerilog and UVM (e.g., Synopsys VCS, Cadence Xcelium, or Mentor Questa)

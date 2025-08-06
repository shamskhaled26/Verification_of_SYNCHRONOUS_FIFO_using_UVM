# Verification of SYNCHRONOUS FIFO using UVM

This project delivers a complete **UVM-based verification environment** for a parameterizable **synchronous FIFO** implemented in SystemVerilog. A synchronous FIFO operates under a **single clock domain**, simplifying timing control while supporting write and read data flow with status flags, overflow/underflow detection, and pointer wrap‑around logic.  

---

## 🧠 Project Overview

- **RTL Design**: A configurable synchronous FIFO (customizable data width and depth) with proper pointer logic and status/flag signals (`empty`, `full`, `overflow`, `underflow`).
- **UVM Verification**: A comprehensive testbench built using **Universal Verification Methodology (UVM)**, including `driver`, `monitor`, `agent`, `scoreboard`, `sequence_item`, `sequencer`, `environment`, and `tests`.
- **Test Types**: Directed and constrained-random tests to stress corner cases: simultaneous write/read, full and empty states, pointer wrap-around, overflow, underflow, and reset behavior :contentReference[oaicite:1]{index=1}.

---

## 📂 Repository Structure
Verification_of_SYNCHRONOUS_FIFO_using_UVM/
├── design/
│ └── sync_fifo.sv # Core FIFO RTL (parameterized)
│
├── uvm_env/
│ ├── fifo_interface.sv # Interface to connect DUT signals
│ ├── fifo_transaction.sv # Sequence items and data transactions
│ ├── fifo_sequence.sv # Stimulus sequences (write/read scenarios)
│ ├── fifo_driver.sv # Applies stimulus to DUT
│ ├── fifo_monitor.sv # Observes DUT and collects transactions
│ ├── fifo_scoreboard.sv # Compares DUT output to reference model
│ ├── fifo_coverage.sv # Functional coverage collection
│ ├── fifo_agent.sv # Bundles driver and monitor
│ ├── fifo_environment.sv # Top-level environment
│ ├── fifo_test.sv # UVM test class instantiation
│ └── fifo_sva.sv # SystemVerilog Assertions for protocol checks
│
└── README.md # This documentation---

## 🔧 Key Features

### RTL Design  
- Parameterized `WIDTH` and `DEPTH`  
- Write (`wr_en`, `data_in`) and read (`rd_en`, `data_out`) ports  
- Control flags: `full`, `empty`, `overflow`, `underflow`  
- Correct handling of simultaneous read/write and pointer wrap-around:contentReference[oaicite:2]{index=2}  

### UVM Verification  
- Transactions generated and randomized via sequence items  
- Scoreboard compares DUT with a reference model  
- Assertions cover:  
  - Reset behavior (pointers and flags)  
  - No writes when full or no reads when empty  
  - Correct pointer cycling and FIFO contents  
- Coverage ensures all control states and combinations are exercised :contentReference[oaicite:3]{index=3}  

---

## 🏁 Getting Started

### Prerequisites  
- UVM-capable SystemVerilog simulator (e.g. QuestaSim, VCS, XSIM)  
- Support for functional coverage and SVA assertions  


# Compile RTL and UVM environment:
vlog +incdir+design +incdir+uvm_env design/sync_fifo.sv uvm_env/*.sv

# Run the UVM test:
vsim -uvm +UVM_TESTNAME=fifo_test work.top

# Check reports:
# - UVM report summary
# - Coverage report


🧪 Verification Strategy
Reset Test: Apply reset and verify that pointers are reset and the FIFO is empty.

Write-Only Test: Drive writes until FIFO becomes full; confirm no overflow writes.

Read-Only Test: Read until FIFO is empty; no underflow occurs.

Mixed Random Traffic: Interleave write/read operations randomly to cover corner cases.

Pointer Wrap-Around: Ensure correct circular buffer behavior beyond depth limit

# Cache Controller Design and Verification

A parameterized **Direct-Mapped Cache Controller** implemented in **SystemVerilog**. The project models the interaction between a CPU, cache, and main memory using a modular architecture and a finite State Machine (FSM). The design follows a modular development approach, where each hardware block is implemented, verified, and documented independently before being integrated into the complete cache controller.

## Project Objectives

* Design a parameterized Direct-Mapped Cache Controller.
* Implement cache hit and miss handling.
* Support read and write operations between the CPU and main memory.
* Build a reusable and modular RTL design.
* Verify each module using dedicated SystemVerilog testbenches.
* Integrate all modules into a complete cache subsystem.

## Features

* Parameterized cache configuration
* Modular RTL architecture
* Direct-Mapped cache organization
* Tag, Index, and Block Offset based address decoding
* Cache Hit/Miss detection
* Valid and Dirty bit management
* FSM-based cache control
* Memory interface for external RAM
* SystemVerilog verification environment
* GTKWave simulation support

## Project Structure

```text
cacheController/
│
├── rtl/                # RTL modules
├── tb/                 # Testbenches
├── docs/               # Phase-wise documentation
├── waveforms/          # Generated waveform files (optional)
├── README.md
│
└── ...
```

## Development Roadmap

| Phase   | Module                     | Status  |
| ------- | -------------------------- | ------  |
| Phase 1 | Top-Level Cache Controller | ✓       |
| Phase 2 | Address Decoder            | ✓       |
| Phase 3 | Tag RAM                    | ✓       |
| Phase 4 | Data RAM                   | ✓       |
| Phase 5 | Tag Comparator             | ⏳      |
| Phase 6 | Cache FSM                  | ⏳      |
| Phase 7 | Memory Interface           | ⏳      |
| Phase 8 | Top-Level Integration      | ⏳      |
| Phase 9 | Complete Verification      | ⏳      |

## Documentation

Detailed implementation and verification of every phase are available inside the **`docs/`** directory.

Each phase includes:

* Design objective
* Module architecture
* RTL implementation details
* Interface description
* Testbench
* Simulation results
* Waveform snapshots (where applicable)
* Future improvements

Example:

```text
docs/
├── Phase-1.md
├── Phase-2.md
├── Phase-3.md
├── ...
```


## Tools

* SystemVerilog
* Icarus Verilog (iverilog)
* Vs Code Editor
* GTKWave
* Git & GitHub

## Future Enhancements

* 2-Way Set Associative Cache
* LRU Replacement Policy
* Write-Back and Write-Allocate support
* Configurable Cache Size and Block Size
* Performance Counters (Hit/Miss Statistics)
* Self-Checking Verification Environment
* Randomized Testbench
* FPGA Implementation
* Synthesis using Open-Source EDA Tools

## License

This project is intended for learning, digital design practice, and ASIC/FPGA development.

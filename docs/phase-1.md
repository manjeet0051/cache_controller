## Phase 1: Project Skeleton

### Objective

Establish the top-level cache controller architecture and verify the design compiles successfully.

### Completed

* Created top-level `cache_controller` module.
* Defined CPU interface signals.
* Defined main memory interface signals.
* Added internal signal declarations for future modules.
* Developed a basic SystemVerilog testbench.
* Verified successful compilation and simulation.


### CPU Interface

| Signal      | Direction | Description                    |
| ----------- | --------- | ------------------------------ |
| `cpu_read`  | Input     | Read request from CPU          |
| `cpu_write` | Input     | Write request from CPU         |
| `cpu_addr`  | Input     | Memory address                 |
| `cpu_wdata` | Input     | Write data                     |
| `cpu_rdata` | Output    | Read data returned to CPU      |
| `cpu_ready` | Output    | Transaction complete indicator |

### Memory Interface

| Signal      | Direction | Description               |
| ----------- | --------- | ------------------------- |
| `mem_read`  | Output    | Memory read request       |
| `mem_write` | Output    | Memory write request      |
| `mem_addr`  | Output    | Memory address            |
| `mem_wdata` | Output    | Data written to memory    |
| `mem_rdata` | Input     | Data returned from memory |
| `mem_ready` | Input     | Memory ready signal       |

### Simulation

```bash
cd result
vvp cache_controller
```
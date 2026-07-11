## Data RAM

## Objective

Implement the **Data RAM** module to store the actual cache data for each cache line. Unlike the Tag RAM, which stores cache metadata, the Data RAM stores the data words that are accessed during CPU read and write operations.

## Completed

* Designed a parameterized Data RAM in SystemVerilog.
* Implemented storage for cache data.
* Organized memory as cache lines containing multiple words.
* Added synchronous write operation.
* Added asynchronous read operation.
* Developed a standalone SystemVerilog testbench.
* Verified read and write operations across different cache lines and word offsets.

## Architecture

Each cache line contains four 32-bit words.

```text
                    Cache Line
+-----------------------------------------------------------+
| Word 0 (32) | Word 1 (32) | Word 2 (32) | Word 3 (32) |
+-----------------------------------------------------------+
```

Overall memory organization:

```text
Data RAM
│
├── Line 0
├── Line 1
├── Line 2
│      .
│      .
├── Line 63
```

## Module Interface

### Inputs

| Signal        | Description                          |
| ------------- | ------------------------------------ |
| `clk`         | System clock                         |
| `we`          | Write enable                         |
| `index`       | Cache line index                     |
| `word_offset` | Selects a word within the cache line |
| `data_in`     | Data to be written                   |

### Outputs

| Signal     | Description                                     |
| ---------- | ----------------------------------------------- |
| `data_out` | Data read from the selected cache line and word |

## Features

* Parameterized cache size
* Parameterized word width
* Configurable words per cache line
* Two-dimensional memory organization
* Synchronous write
* Asynchronous read
* Modular and reusable RTL design

## Test Cases

| Test Case                   | Status |
| --------------------------- | ------ |
| Write cache line 5, word 0  | ✓      |
| Read cache line 5, word 0   | ✓      |
| Write cache line 5, word 2  | ✓      |
| Read cache line 5, word 2   | ✓      |
| Write cache line 20, word 1 | ✓      |
| Read cache line 20, word 1  | ✓      |

## Simulation

```bash
iverilog -g2012 -o data_ram.out rtl/data_ram.sv tb/tb_data_ram.sv
vvp data_ram.out
```

Alternate (Already Compiled)
```bash
cd result
vvp data_ram
```
## Results

* Data was successfully written to the selected cache line and word location.
* Read operations returned the expected values.
* Multiple cache lines operated independently without interference.
* Different word offsets within the same cache line were accessed correctly.
* Simulation completed successfully.


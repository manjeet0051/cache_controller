## Tag RAM

## Objective

Implement the **Tag RAM** module to store cache metadata for each cache line. The Tag RAM is responsible for maintaining the **Tag**, **Valid Bit**, and **Dirty Bit**, which are required for cache hit/miss detection and cache management.

## Completed

* Designed a parameterized Tag RAM in SystemVerilog.
* Implemented storage for:

  * Tag
  * Valid Bit
  * Dirty Bit
* Added synchronous write operation.
* Added asynchronous read operation.
* Implemented reset logic to initialize all cache entries.
* Developed a standalone SystemVerilog testbench.
* Verified write and read operations for multiple cache indices.

## Architecture

Each cache line stores the following information:

```text
+--------------------------------------+
| Valid Bit | Dirty Bit | Tag (22 bits)|
+--------------------------------------+
```

## Module Interface

### Inputs

| Signal     | Description       |
| ---------- | ----------------- |
| `clk`      | System clock      |
| `rst_n`    | Active-low reset  |
| `we`       | Write enable      |
| `index`    | Cache line index  |
| `tag_in`   | Tag to be written |
| `valid_in` | Valid bit input   |
| `dirty_in` | Dirty bit input   |

### Outputs

| Signal      | Description      |
| ----------- | ---------------- |
| `tag_out`   | Stored tag       |
| `valid_out` | Stored valid bit |
| `dirty_out` | Stored dirty bit |

## Features

* Parameterized number of cache lines
* Parameterized tag width
* Synchronous write
* Asynchronous read
* Reset initializes all entries
* Suitable for direct-mapped cache architecture

## Test Cases

| Test Case                   | Status |
| --------------------------- | ------ |
| Reset all entries           | ✓      |
| Write first cache entry     | ✓      |
| Read first cache entry      | ✓      |
| Write another cache entry   | ✓      |
| Read multiple cache entries | ✓      |
| Verify Valid bit            | ✓      |
| Verify Dirty bit            | ✓      |

## Simulation

```bash
iverilog -g2012 -o tag_ram.out rtl/tag_ram.sv tb/tb_tag_ram.sv
vvp tag_ram.out
```

Alternate (Already Compiled)
```bash
cd result
vvp tag_ram
```

## Results

* All cache entries were correctly initialized after reset.
* Tag values were successfully written and read back.
* Valid and Dirty bits matched the expected values.
* Multiple cache indices operated independently.
* Simulation completed successfully.


## Address Decoder

## Objective

Implement the Address Decoder module to split the CPU address into **Tag**, **Index**, and **Block Offset** fields for cache lookup.

## Completed

* Designed a parameterized Address Decoder in SystemVerilog.
* Supports configurable address width, cache index width, and block offset width.
* Extracts:

  * Tag
  * Index
  * Block Offset
* Developed a standalone testbench.
* Verified functionality using multiple test addresses.
* Generated waveform (`address_decoder.vcd`) for simulation analysis.

## Address Format

For a **32-bit CPU address**:

| Field        | Bits |
| ------------ | ---- |
| Tag          | 22   |
| Index        | 6    |
| Block Offset | 4    |

```text
 -------------------------------------------------
|               Tag (22) | Index (6) | Offset (4) |
 -------------------------------------------------
```

## Test Cases

| Address      | Expected Purpose |
| ------------ | ---------------- |
| `0x12345678` | Random address   |
| `0xABCDEF12` | Random address   |
| `0x00000020` | Small address    |
| `0xFFFFFFFF` | Maximum address  |

## Simulation

Run

```bash
cd result
vvp address_decoder
```

## Results

* Address fields were extracted correctly for all test cases.
* Parameterized implementation allows easy modification of cache configuration.
* Simulation completed successfully without functional errors.

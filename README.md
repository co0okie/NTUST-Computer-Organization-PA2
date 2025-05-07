# Simple MIPS CPU Implementation

This project implements a basic MIPS CPU supporting the following instructions:

- `addu`, `subu`, `sll`, `or`, `addiu`, `lw`, `sw`, `ori`, `beq`, `j`

## Prerequisites

- Python 3  
- Icarus Verilog (`iverilog`)  
- GTKWave

## Usage

1. Navigate to one of the `Part1`, `Part2`, or `Part3` directories.
2. Edit the MIPS assembly in `main.a`.
3. To run the simulation:
   ```sh
   make run
   ```
4. To view the waveform:
   ```sh
   make wave
   ```

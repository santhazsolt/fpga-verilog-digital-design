# FPGA Digital Design with Verilog

A collection of FPGA projects developed as part of my university coursework, using Verilog HDL and Xilinx Vivado. The projects explore digital logic design, sequential circuits, clock division, seven-segment display control, and simulation-based verification.

## Project Overview

The objective of these projects was to develop practical skills in digital hardware design, modular Verilog development, FPGA implementation, and functional verification.

The repository contains several digital design exercises, from basic combinational circuits to a hierarchical digital clock.

## Hardware and Software

- **FPGA development board:** Digilent Nexys A7
- **FPGA device family:** Xilinx Artix-7
- **Hardware description language:** Verilog HDL
- **Development environment:** Xilinx Vivado
- **Verification:** Verilog testbenches and Vivado behavioral simulation
- **Hardware debugging:** Vivado Integrated Logic Analyzer (ILA), where applicable

## Projects

### 1. Multiplexer Design

Implementation of 4-to-1 multiplexers using Verilog.

Topics covered:

- Combinational logic
- Select signals and data routing
- Parameterized, multi-bit designs
- Testbench-based functional verification

### 2. Clock Divider

A configurable clock-divider design for generating slower timing signals from a faster clock source.

Topics covered:

- Counter-based frequency division
- Configurable division ratios
- Clock and timing analysis
- On-chip signal observation using Vivado ILA, where implemented

### 3. Seven-Segment Display Controller

A collection of modules for controlling a multiplexed seven-segment display on the Nexys A7 board.

Topics covered:

- Seven-segment decoding
- Digit selection and anode control
- Display multiplexing
- Blanking control
- Refresh-rate behavior
- Simulation and physical-board testing

### 4. Digital Clock

A hierarchical digital clock design based on cascaded counters and timing-control logic.

Topics covered:

- Counter design and parameterization
- Seconds, minutes, and hours
- Carry propagation between time units
- Counter rollover and reset behavior
- Time adjustment through increment/decrement control
- Testbench-based verification

## Running the Projects

1. Install Xilinx Vivado with support for the Artix-7 device family.
2. Clone or download this repository.
3. Open the relevant Vivado project, if its project files are included.
4. Alternatively, create a new RTL project and add the required Verilog source files and testbench.
5. Select the appropriate top-level module.
6. Run behavioral simulation using the corresponding testbench.
7. Inspect the waveforms and compare the observed behavior with the expected results.
8. For hardware demonstrations, use the correct board constraints and program the Nexys A7 FPGA.

**Note:** The `.xdc` constraints file must match the top-level module ports and the physical board connections. Testbench files are used for simulation and should not be selected as the hardware top module.

## Simulation and Results

The `screenshots/` directory contains selected waveform captures and hardware evidence from the projects.

The screenshots illustrate:

- Multiplexer input selection and output behavior
- Counter operation and timing signals
- Seven-segment decoding and blanking-control verification
- Clock-divider signal behavior observed using ILA
- Digital clock counter rollover and time-adjustment tests

The `docs/` directory contains presentations describing the implementation, simulation, debugging process, and hardware tests.

## Skills Demonstrated

- Verilog HDL
- Combinational and sequential logic design
- Parameterized and modular RTL
- Counter and timing circuit implementation
- Testbench development and simulation
- FPGA debugging with Vivado ILA
- Seven-segment display interfacing
- Digital design verification

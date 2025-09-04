============================================================
README — MCU Project (MIPS-based Microcontroller on FPGA)
============================================================

Authors:
  • Tal Adoni (31987300)
  • Omri Aviram (312192669)

------------------------------------------------------------
1. Project Overview
------------------------------------------------------------
This project implements a full MCU system on FPGA, based on a 
scalar pipelined MIPS processor. The system integrates core 
CPU functionality with memory, bus infrastructure, and 
memory-mapped peripherals, creating a working 
microcontroller-like environment.

The design was written in VHDL, simulated with ModelSim, and 
synthesized for Altera/Intel Cyclone V FPGA (DE10-Standard 
development board). Timing constraints and functional testing 
were applied to ensure correct operation in hardware.

------------------------------------------------------------
2. System Architecture
------------------------------------------------------------
Top-Level: Quartus_Top.vhd
  • Connects CPU, instruction/data memories, and peripherals.
  • Defines generics for bus width, address width, and 
    synthesis/simulation parameters.
  • Instantiates clocking and reset logic.

Main Components:
  • MIPS.vhd — Pipelined MIPS CPU with 5 pipeline stages:
      - IFETCH.vhd
      - IDECODE.vhd
      - EXECUTE.vhd
      - DMEMORY.vhd
      - CONTROL.vhd
      - HazardUnit_and_ForwardingUnit.vhd
  • MCU.vhd — Wraps CPU with peripheral bus and system control.
  • IO_decoder.vhd — Maps I/O addresses to peripherals.
  • Interrupt_controller.vhd — Handles external/internal IRQs.

Memory:
  • ITCM (Instruction Tightly-Coupled Memory)
  • DTCM (Data Tightly-Coupled Memory)
  • Synchronus FIFO.vhd — FIFO buffer used for FIR/IO
  • Counter.vhd — Generic n-bit counter (timing/events)

Peripherals:
  • Basic_Timer.vhd — Generates interrupts and PWM signals.
  • FIR_filter.vhd — Digital FIR accelerator with FIFO 
    interface for streaming data.
  • HexDecoder.vhd — Drives FPGA 7-segment displays.
  • BidirPin.vhd — Bidirectional I/O pin module.

Packages:
  • const_package.vhd — Global constants (word sizes, addresses).
  • aux_package.vhd — Helper functions and types.
  • cond_comilation_package.vhd — Conditional compilation 
    definitions.

------------------------------------------------------------
3. Features
------------------------------------------------------------
  • Scalar pipelined MIPS CPU (5 stages + hazard resolution).
  • Instruction & Data memories with M9K FPGA blocks.
  • Memory-mapped peripherals: Timer, GPIO, FIR, FIFO, etc.
  • Interrupt controller with priority and vectoring support.
  • Bus-based IO decoding for modular expansion.
  • Clock division for peripherals (FIRCLK ~44 kHz).
  • Hex display output for debugging.

------------------------------------------------------------
4. Simulation & Synthesis
------------------------------------------------------------
Simulation:
  • ModelSim testbenches verify pipeline correctness, memory 
    writes, and peripheral functionality.
  • FIFO and FIR modules were tested with waveform inspection.

Synthesis:
  • Quartus Prime with Cyclone V device.
  • Timing analysis performed with .sdc constraints:
      - create_clock for CLK_IN (50 MHz)
      - derive_pll_clocks for generated clocks
      - FIRCLK domain treated as asynchronous (optional)
  • FPGA tested with actual memory write/read and FIR output.

------------------------------------------------------------
5. Known Issues & Debugging Notes
------------------------------------------------------------
  • ModelSim and Quartus may show different memory initialization 
    order (endianness difference in hex files).
  • FIR filter requires consistent FIFO widths (cell_size must 
    match higher-level instantiations).
  • Critical paths in Quartus should be analyzed to maintain Fmax.
  • Ensure FIFOREN/FIFOWEN signals are pulsed properly to avoid 
    latching issues.

------------------------------------------------------------
6. File List
------------------------------------------------------------
  • Quartus_Top.vhd
  • MCU.vhd
  • MIPS.vhd
    ├── IFETCH.vhd
    ├── IDECODE.vhd
    ├── EXECUTE.vhd
    ├── DMEMORY.vhd
    ├── CONTROL.vhd
    └── HazardUnit_and_ForwardingUnit.vhd
  • Synchronus FIFO.vhd
  • Basic_Timer.vhd
  • FIR_filter.vhd
  • Counter.vhd
  • HexDecoder.vhd
  • IO_decoder.vhd
  • Interrupt_controller.vhd
  • BidirPin.vhd
  • const_package.vhd
  • aux_package.vhd
  • cond_comilation_package.vhd

------------------------------------------------------------
7. Usage Instructions
------------------------------------------------------------
1. Open Quartus project and add all VHDL files.
2. Apply SDC constraints for proper timing closure.
3. Compile project for Cyclone V FPGA (DE10-Standard).
4. Program the FPGA with the generated .sof file.
5. Interact with system via memory-mapped IO (keys, switches, 
   UART or testbench).

------------------------------------------------------------
8. License
------------------------------------------------------------
This project was developed as part of an academic course. 
It is intended for educational purposes only.

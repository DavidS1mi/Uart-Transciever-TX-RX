# Digital UART Transceiver (TX/RX) on FPGA

**Status:** Ongoing Project

## Overview
This project implements a digital Universal Asynchronous Receiver-Transmitter (UART) communication system on an FPGA using Verilog. The project is divided into two main components to compare design methodologies: a **structural** implementation for the Transmitter (TX) and a **behavioral** implementation for the Receiver (RX). 

The system converts 8-bit parallel input data into a serial bitstream for transmission and reconstructs it back into parallel data upon reception, adhering to a standard UART protocol frame.

## Protocol Specifications
* **Baud Rate:** 9600 bps (derived from a 50MHz system clock)
* **Data Bits:** 8 bits (transmitted LSB first)
* **Start Bit:** 1 bit (Logic `0`)
* **Stop Bit:** 1 bit (Logic `1`)
* **Parity Bit:** 1 bit (Calculated via XOR of all 8 data bits)
* **Total Frame Size:** 11 bits

## Architecture

### 1. Transmitter (TX) - Structural Modeling
The TX module is designed using a structural block-level approach. It buffers the input data and shifts it out serially bit-by-bit when triggered.
* **`reg0`**: An 8-bit register that saves the input data upon the `start` signal to prevent data corruption during transmission.
* **`counter_baud_rate`**: Divides the 50MHz system clock to generate a timing enable signal corresponding to the 9600 baud rate.
* **`counter_bit_select`**: Keeps track of the current bit index (0 to 10) being transmitted in the 11-bit UART frame.
* **`crc_calc`**: Combinational logic block that calculates the parity bit using a bitwise XOR operation on the 8 data bits.
* **`mux`**: A multiplexer that selects which bit (start, data[0:7], parity, or stop) to route to the output based on the bit select counter.
* **`toggle_ff`**: A toggle flip-flop used for internal state management.

### 2. Receiver (RX) - Behavioral Modeling
The RX module is designed behaviorally using a Finite State Machine (FSM). 
* Monitors the serial line for the `0` start bit.
* Uses internal counters to sample the line at the correct baud rate intervals.
* Extracts the 8 data bits and validates the frame (checking stop and parity bits).
* Outputs the reconstructed parallel data along with a `valid` pulse if the transmission was successful.

## Hardware Mapping (FPGA Constraints)
The design is targeted for an FPGA development board with the following I/O assignments:
* `clk` (Clock): 50MHz System Clock
* `rst` (Reset): Switch `[0]`
* `data_in` (8-bit parallel data): Switches `[1:8]`
* `start` (Start transmission): Switch `[9]`
* `out_tx` (Serial Output): Red LED `[0]`

## Simulation & Testing
The project includes a Testbench (TB) to verify the RTL logic before physical synthesis:
* **Clock Period:** 10 ns.
* **Reset Sequence:** A 10-clock-cycle reset is generated at the start of the simulation.
* **Test Case:** Input data is set to `254`, and a 1-clock-cycle `start` pulse is triggered at 30ns to observe the 11-bit serialized output and RX validation.

## Tools Used
* Verilog HDL
* FPGA Synthesis Tools (Quartus/Vivado)
* RTL Simulation Software (ModelSim/Vivado Simulator)

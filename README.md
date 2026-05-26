# UART Transceiver in SystemVerilog
![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-blue.svg)
![EDA](https://img.shields.io/badge/Tool-Xilinx_Vivado-orange.svg)
![Status](https://img.shields.io/badge/Status-Simulation_Verified-success.svg)

 Fully functional UART Transceiver with transmission and reception capabilities built from scratch in SystemVerilog.

## Features
* **Full-Duplex Communication**: Includes both transmit (`tx_pin`) and receive (`rx_pin`) capabilities.
* **UART Frame Format**: 1 Start bit (0), 8 Data bits, 1 Parity bit, 1 Stop bit (1) totaling an 11-bit frame.
* **Parity Generation**: Built-in parity generation using an XOR tree (`crc_calc`).
* **Configurable Baud Rate**: Controlled via internal module parameters. The default baud rate divider is `5208` (which yields 19200 baud on a 100MHz clock or 9600 baud on a 50MHz clock), with partial/half-cycle oversampling (`2604`) for precise receiver synchronization.
* **Integrated Testbench**: Loopback simulation testbench (`tb_transceiver`) provided to verify direct communication between the transmitter and receiver logic.

---

## How it works
 To send information between two devices over a single wire, the message is first translated into a sequence of tiny electrical pulses, much like rapidly turning a light switch on and off. Because they only share this one wire, both devices must agree on a very precise, steady rhythm beforehand so they don't get confused. 

 When the sender is ready, it sends a sudden "start" pulse down the wire to grab the receiver's attention, followed immediately by the actual message pulses, pushing them out one by one in perfect time with that shared beat. The receiving device simply watches the wire, catching each pulse exactly on the rhythm, and stops collecting the moment it sees a final pulse, instantly piecing the whole message back together on the other side.

---

## Architecture
The transceiver is divided into two primary subsystems that can operate concurrently:

<br>
<p align="center">
  <img width="90%" alt="UART Transmitter Architecture" src="https://github.com/user-attachments/assets/a1f8e6f0-3740-42d7-9df2-654d7e1210f6" />
</p>
<br>

### 1. Transmitter (`top.sv`)
The transmitter uses a modular structural datapath design, built by instantiating primitive logical blocks and routing them together, closely matching standard hardware schematics.
* **Frame Register (`reg0`)**: Buffers the complete 11-bit UART frame (`{1'b1, parity, data_in, 1'b0}`).
* **Multiplexer (`mux`)**: Serializes the data by selecting the appropriate bit according to the current bit index.
* **Baud Rate Counter (`Counter_baud_rate`)**: Timer that dictates the timing length of each serial bit sequence.
* **Bit Counter (`counter_bit_select`)**: Tracks the transmission progress from bit 0 to bit 10.
* **Control Logic (`toggle_ff`, `equalityverif`)**: Manages the start sequence and ensures transmission completes after 11 bits.
<img width="2061" height="591" alt="image" src="https://github.com/user-attachments/assets/febfd22f-a5bd-465c-bcc5-00b0da6d29d3" />


### 2. Receiver (`Receive.sv`)
The receiver is implemented using a classic Finite State Machine (FSM) utilizing oversampling logic to maximize data integrity.
* `idle`: Waits for the RX line to drop (identifying the Start bit).
* `start`: Waits for half a baud cycle (`baud_rate_partial`) to sample the middle of the start bit.
* `data`: Iterates through and samples the 8 data bits at the exact center of their respective clock periods into a shift register.
* `parity`: Reads the parity bit.
* `stop`: Verifies the presence of the Stop bit (1) and asserts the `valid` signal to the system, outputting the unpacked byte to `data_out`.
<img width="2164" height="527" alt="image" src="https://github.com/user-attachments/assets/7fc97b84-ffc8-4ec3-adfb-d38b3f662f4c" />


---

## Module Breakdown
* `transceiver.sv`: The top-level wrapper binding the transmitter and receiver.
* `tb_transceiver.sv`: Top-level testbench. Loops `tx_pin` to `rx_pin` and validates transmission of data bytes (`0xAB`, `0x55`).
* `Receive.sv`: FSM-based receiver logic.
* `top.sv`: Structural top-level module for the transmitter logic.
* `crc_calc.sv`: Combinational logic to calculate the bitwise XOR parity.
* `Counter_baud_rate.sv`: Timer module for scaling the clock to the correct baud rate.
* `counter_bit_select.sv`: 4-bit counter tracking the current bit index.
* `equalityverif.sv`: A highly parameterized equality comparator.
* `toggle_ff.sv`: A toggle flip-flop used for driving internal enablement paths.
* `reg0.sv`: 11-bit loadable register.
* `mux.sv`: Multiplexer element.

---

## Running the Simulation

<br>
<p align="center">
  <img width="100%" alt="Simulation Waveform" src="https://github.com/user-attachments/assets/ca1b2e6c-f34e-43ad-a610-e50ff9060960" />
</p>
<br>

**Waveform Breakdown:**
* **Triggering Transmission:** The `data_in` line changes to `ab` (hexadecimal for the data you want to send). Shortly after, the `start` signal pulses high, triggering the transmission.
* **Serializing Data:** A delay occurs because the transmitter cannot send all 8 bits of `ab` at the exact same time; it must send them one by one down the single `auxwire`.
* **Reconstruction:** The receiver waits and collects those pulses one by one in the background from the `auxwire`.
* **Completion:** Once it receives the final "stop bit," it knows the transmission is complete. It takes those collected bits, pieces them back together into an 8-bit byte, and pushes it out to `data_out`, which finally updates from `00` to `ab`.
* **Validation:** At that exact same moment, the `valid` signal briefly pulses high to indicate a successful read.

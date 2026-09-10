# Convolutional Encoder - RL Project 2021/22

*Puoi anche leggerlo in [Italiano](README.it.md)*

> **Academic Note:** This project was developed as the Final Project for the *Reti Logiche* course at Politecnico di Milano (Academic Year 2021/22), by Alberto Biffi and Giovanni Mattia Codemo achieving a final grade of **29/30**.

### Project Description
The project requires the design and implementation of a hardware component described in VHDL (synthesized via Xilinx Vivado Webpack) that interfaces with a block RAM memory. 

The system reads a continuous sequence of **W** bytes (where **W** is stored at memory address 0), serializes them into a 1-bit stream **U**, and applies a rate **1/2** convolutional code. The resulting encoded bit stream **Y** is packed back into 8-bit words and stored starting from memory address 1000.

### Technical Features & Challenges
* **Finite State Machine (FSM):** Implemented via a robust single-process synchronous architecture managed by a clock signal (i_clk) and an asynchronous/synchronous reset (i_rst).
* **Convolutional Logic:** Employs shift registers to implement the 1/2 rate encoder structure based on two generator polynomials, producing alternating output bits (**P_{1k}, P_{2k}**).
* **Memory Protocol Handling:** Manages control signals (o_en, o_we, o_address) to coordinate read and write operations with the block RAM seamlessly.
* **Multiple Stream Support:** Capable of processing multiple consecutive streams upon new i_start assertions without requiring a full system reset between executions.

### Technologies & Synthesis Results
* **Language:** VHDL (IEEE 1164 standard)
* **Synthesis Tool:** Xilinx Vivado Webpack (Target FPGA: Artix-7 xc7a200tfbg484-1)
* **Resource Utilization:** 
  * **LUTs:** 71
  * **Flip-Flops (FF):** 93
  * **Latches:** 0
* **Timing Performance:** Fully meets the 100 ns clock period constraint, with a post-synthesis positive slack of 95.850 ns.


### Repository Structure
`src/`: Contains the main VHDL source file (project_reti_logiche.vhd).

`docs/`: Includes the official project report (Relazione.pdf) and original rules/specifications.

`tests/`: Contains the simulation testbenches.
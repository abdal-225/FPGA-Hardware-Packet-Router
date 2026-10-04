# FPGA-Based Multi-Output Packet Router

## Overview

This project implements a packet router using Verilog HDL for routing incoming data packets to one of four output ports. The router uses FIFO-based buffering to temporarily store packets and manage data transfer between the input and output ports.

## Key Features

* **Packet Routing:** Routes packets to one of four output ports based on a 2-bit destination address.
* **FIFO Buffering:** Uses First-In, First-Out (FIFO) buffers to store packets temporarily and preserve their arrival order.
* **Flow Control:** Uses FIFO status signals, such as full and empty, to help prevent buffer overflow and invalid reads.
* **Multi-Output Support:** Supports four output destinations.
* **Modular Architecture:** Separates packet routing, FIFO buffering, and control logic into individual modules.
* **Verification:** Uses simulation to test packet routing and FIFO operation.

## Packet Format

Each packet consists of a 2-bit destination field and an 8-bit data field, making a total packet width of 10 bits.

| Destination | Output Port |
| ----------- | ----------- |
| `00`        | Output 0    |
| `01`        | Output 1    |
| `10`        | Output 2    |
| `11`        | Output 3    |

## Working Principle

The router receives an incoming packet and decodes its destination address. The packet is directed to the corresponding output port, where FIFO buffering temporarily stores data until it can be read. FIFO control signals coordinate read and write operations, supporting reliable data transfer when input and output rates differ.

## Tools and Technologies

* Verilog HDL
* Xilinx Vivado
* Logisim Evolution
  
## Project Status

The project focuses on packet routing, FIFO-based buffering, and flow-control logic. Simulation and system-level verification are part of the development process.

## Author

**Abdal Ahmad**

B.Tech – Electronics and Communication Engineering

NIT Warangal

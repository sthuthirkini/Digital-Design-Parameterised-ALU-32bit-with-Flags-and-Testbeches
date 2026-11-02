# 32-Bit Parameterized ALU with Clocked Test Vector Testbench

This repository contains a parameterized Arithmetic Logic Unit (ALU) implemented in SystemVerilog, accompanied by a clocked test vector testbench following standard digital design verification methodology.

## Repository Structure

* **alu32bit.sv**: Parameterized ALU hardware design module utilizing a shared adder and two's complement conditional inversion datapath.
* **alu32bit_tv_tb.sv**: Clocked test vector testbench with automated self-checking capabilities.
* **alu32bit.tv**: External binary test vector file containing structured input and expected output data rows.

## ALU Operations and Control

The ALU behavior is determined by the 2-bit `ALUControl` signal:

* **00**: Addition ($A + B$)
* **01**: Subtraction ($A - B$) via conditional inversion and carry-in
* **10**: Bitwise AND ($A \ \& \ B$)
* **11**: Bitwise OR ($A \ \| \ B$)

## Test Vector Format

Test vectors are structured continuously in binary format (`$readmemb`), where each row represents:{a, b, ALUControl, yexpected}

For a default configuration of 32 bits, each test vector row totals 96 bits.

## Simulation Instructions

To compile and execute the simulation using Icarus Verilog (`iverilog`) and `vvp`:

1. Compile the source files into a simulation executable:
   ```bash
   iverilog -g2012 -o alu_sim alu32bit.sv alu32bit_tv_tb.sv
   vvp alu_sim


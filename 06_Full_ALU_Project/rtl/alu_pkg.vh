// ============================================================
// File        : alu_pkg.vh
// Project     : 8-bit ALU — Full VLSI Flow
// Description : Opcode definitions (header file)
//
// WHY THIS FILE EXISTS:
//   Instead of using magic numbers like 3'b000, 3'b001
//   everywhere (which are hard to read and error-prone),
//   we define named constants here.
//   Any file that needs these just does: `include "alu_pkg.vh"
// ============================================================

`ifndef ALU_PKG_VH        // Include guard — prevents double-inclusion
`define ALU_PKG_VH        // Same pattern as #pragma once in C

// ── Opcode Definitions ──────────────────────────────────────
// 3-bit opcode → 8 possible operations
`define ALU_ADD  3'b000   // Addition:        result = A + B + Cin
`define ALU_SUB  3'b001   // Subtraction:     result = A - B
`define ALU_AND  3'b010   // Bitwise AND:     result = A & B
`define ALU_OR   3'b011   // Bitwise OR:      result = A | B
`define ALU_XOR  3'b100   // Bitwise XOR:     result = A ^ B
`define ALU_NOT  3'b101   // Bitwise NOT:     result = ~A
`define ALU_SHL  3'b110   // Shift Left:      result = A << 1
`define ALU_SHR  3'b111   // Shift Right:     result = A >> 1

// ── ALU Width ───────────────────────────────────────────────
// Defined here so testbench and DUT always agree
`define ALU_WIDTH 8

`endif // ALU_PKG_VH

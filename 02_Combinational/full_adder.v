// ============================================================
// Module      : full_adder
// File        : full_adder.v
// Description : 1-bit Full Adder combinational circuit.
// ============================================================

`timescale 1ns/1ps

module full_adder (
    input  wire a,
    input  wire b,
    input  wire c_in,
    output wire sum,
    output wire c_out
);

    assign sum   = a ^ b ^ c_in;
    assign c_out = (a & b) | (b & c_in) | (a & c_in);

endmodule

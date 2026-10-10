// ============================================================
// Module      : ripple_carry_adder
// File        : ripple_carry_adder.v
// Description : 4-bit Ripple Carry Adder Implementation
// ============================================================

/*
============================================================
YOUR ORIGINAL CODE (Preserved):
============================================================
module ripple_carry_adder(
    input [3:0] a,
    input [3:0] b,
    input c_in,
    output[3:0] sum,
    output c_out
)
assign sum = a ^ b ^ c_in;
assign c_out = (a & b) | (b & c_in) | (a & c_in);

endmodule

============================================================
EXPLANATION OF MISTAKES:
1. Syntax Error: Missing semicolon ';' after 'output c_out)'.
   It must be 'output c_out);'.

2. Logic Error (No Carry Ripple):
   - 'a' and 'b' are 4-bit vectors [3:0], but 'c_in' is 1-bit.
   - 'assign sum = a ^ b ^ c_in;' computes bitwise XOR on 4 bits independently 
     without propagating carries between bit positions (bit 0 to bit 1, etc.).
   - 'assign c_out = (a & b) | (b & c_in) | (a & c_in);' performs 4-bit bitwise 
     operations rather than generating the single final carry out from the 4th bit.

3. How a Ripple Carry Adder Works:
   A true Ripple Carry Adder connects multiple 1-bit Full Adders in series.
   The carry-out of stage 0 (c1) becomes the carry-in of stage 1, and so on.
============================================================
*/

// ============================================================
// CORRECTED CODE (Method 1: Structural Ripple Carry Adder)
// ============================================================
`timescale 1ns/1ps

module ripple_carry_adder (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       c_in,
    output wire [3:0] sum,
    output wire       c_out
);

    wire c1, c2, c3;  // Internal carry chain wires

    // Bit 0 Stage
    full_adder fa0 (.a(a[0]), .b(b[0]), .c_in(c_in), .sum(sum[0]), .c_out(c1));

    // Bit 1 Stage
    full_adder fa1 (.a(a[1]), .b(b[1]), .c_in(c1),   .sum(sum[1]), .c_out(c2));

    // Bit 2 Stage
    full_adder fa2 (.a(a[2]), .b(b[2]), .c_in(c2),   .sum(sum[2]), .c_out(c3));

    // Bit 3 Stage
    full_adder fa3 (.a(a[3]), .b(b[3]), .c_in(c3),   .sum(sum[3]), .c_out(c_out));

endmodule


// ============================================================
// ALTERNATIVE MODEL: Dataflow Vector Addition
// ============================================================
module ripple_carry_adder_dataflow #(
    parameter WIDTH = 4
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             c_in,
    output wire [WIDTH-1:0] sum,
    output wire             c_out
);

    assign {c_out, sum} = a + b + c_in;

endmodule
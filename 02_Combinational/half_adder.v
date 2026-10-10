// ============================================================
// Module      : half_adder
// File        : half_adder.v
// Description : Half Adder combinational logic circuit.
// ============================================================

`timescale 1ns/1ps

module half_adder (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire c_out
);

    assign sum   = a ^ b;  // Sum = A XOR B
    assign c_out = a & b;  // Carry = A AND B

endmodule

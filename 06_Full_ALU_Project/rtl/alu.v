// ============================================================
// Module      : alu
// File        : alu.v
// Description : 8-bit Parameterized ALU (8 operations, 5 flags)
// ============================================================
`timescale 1ns/1ps
`include "alu_pkg.vh"

module alu #(parameter WIDTH = `ALU_WIDTH)(
    input  wire [WIDTH-1:0] a, b,
    input  wire [2:0]       op,
    input  wire             cin,
    output reg  [WIDTH-1:0] result,
    output reg              cout,
    output wire             zero, negative, overflow, parity
);
    reg [WIDTH:0] temp;

    always @(*) begin
        {cout, result, temp} = 0;
        case (op)
            `ALU_ADD: {cout, result} = a + b + cin;
            `ALU_SUB: {cout, result} = {1'b0, a} - {1'b0, b};
            `ALU_AND:  result = a & b;
            `ALU_OR:   result = a | b;
            `ALU_XOR:  result = a ^ b;
            `ALU_NOT:  result = ~a;
            `ALU_SHL: {cout, result} = {a, 1'b0};
            `ALU_SHR: begin result = a >> 1; cout = a[0]; end
            default:   result = 0;
        endcase
    end

    assign zero     = ~(|result);
    assign negative = result[WIDTH-1];
    assign parity   = ^result;
    assign overflow = (op == `ALU_ADD) ?
                      ((~a[WIDTH-1] & ~b[WIDTH-1] & result[WIDTH-1]) |
                       ( a[WIDTH-1] &  b[WIDTH-1] & ~result[WIDTH-1])) :
                      (op == `ALU_SUB) ?
                      ((~a[WIDTH-1] &  b[WIDTH-1] & result[WIDTH-1]) |
                       ( a[WIDTH-1] & ~b[WIDTH-1] & ~result[WIDTH-1])) : 0;

endmodule

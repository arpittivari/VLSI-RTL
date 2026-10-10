// ============================================================
// Module      : mux_4to_1
// File        : mux_4to1.v
// Description : 4-to-1 Multiplexer Implementation & Verification
// ============================================================

/*
============================================================
YOUR CODE (Contains 2 Major Compiler Errors):
============================================================
module mux_4to_1(
    input wire [WIDTH-1:0] A,
    input wire [WIDTH-1:0] B,
    input wire [WIDTH-1:0] C,
    input wire [WIDTH-1:0] D,
    output reg [WIDTH-1:0] out
    );

    always @(*) begin
        case (sel) // <-- ERROR 2: 'sel' is NOT declared in port list!
            2'b00   : out = A;
            2'b01   : out = B;
            2'b10   : out = C;
            2'b11   : out = D;
            default : out = {WIDTH{1'bx}};
        endcase
    end
endmodule

============================================================
EXPLANATION OF MISTAKES IN YOUR CODE:
1. Error: 'WIDTH' is undeclared!
   - You used '[WIDTH-1:0]' for A, B, C, D, and out, but you did 
     not define 'parameter WIDTH = 1' in the module declaration.
   - Fix: Add '#(parameter WIDTH = 1)' before the port list.

2. Error: 'sel' is undeclared!
   - You used 'case (sel)', but 'sel' was never declared as an input port!
   - A 4:1 MUX needs a 2-bit select line to choose between A, B, C, and D.
   - Fix: Add 'input wire [1:0] sel' to your input ports.
============================================================
*/

// ============================================================
// CORRECTED CODE (Your module with fixed ports and parameter):
// ============================================================
`timescale 1ns/1ps

module mux_4to_1 #(
    parameter WIDTH = 1     // 1. Defined WIDTH parameter
)(
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire [WIDTH-1:0] C,
    input  wire [WIDTH-1:0] D,
    input  wire [1:0]       sel, // 2. Added 2-bit select input port
    output reg  [WIDTH-1:0] out
);

    always @(*) begin
        case (sel)
            2'b00   : out = A;
            2'b01   : out = B;
            2'b10   : out = C;
            2'b11   : out = D;
            default : out = {WIDTH{1'bx}};
        endcase
    end

endmodule


// ============================================================
// ALTERNATIVE MODEL 1: DATAFLOW (Ternary Operator)
// ============================================================
module mux_4to1_dataflow #(
    parameter WIDTH = 1
)(
    input  wire [WIDTH-1:0] in0,
    input  wire [WIDTH-1:0] in1,
    input  wire [WIDTH-1:0] in2,
    input  wire [WIDTH-1:0] in3,
    input  wire [1:0]       sel,
    output wire [WIDTH-1:0] out
);

    assign out = (sel == 2'b00) ? in0 :
                 (sel == 2'b01) ? in1 :
                 (sel == 2'b10) ? in2 : in3;

endmodule


// ============================================================
// ALTERNATIVE MODEL 2: STRUCTURAL (Using 2:1 MUX Hierarchy)
// ============================================================
module mux_4to1_structural #(
    parameter WIDTH = 1
)(
    input  wire [WIDTH-1:0] in0,
    input  wire [WIDTH-1:0] in1,
    input  wire [WIDTH-1:0] in2,
    input  wire [WIDTH-1:0] in3,
    input  wire [1:0]       sel,
    output wire [WIDTH-1:0] out
);

    wire [WIDTH-1:0] stage1_low;
    wire [WIDTH-1:0] stage1_high;

    mux_2to1 #(.WIDTH(WIDTH)) m0 (.in0(in0), .in1(in1), .sel(sel[0]), .out(stage1_low));
    mux_2to1 #(.WIDTH(WIDTH)) m1 (.in0(in2), .in1(in3), .sel(sel[0]), .out(stage1_high));
    mux_2to1 #(.WIDTH(WIDTH)) m2 (.in0(stage1_low), .in1(stage1_high), .sel(sel[1]), .out(out));

endmodule

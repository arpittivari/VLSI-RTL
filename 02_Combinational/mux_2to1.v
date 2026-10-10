// ============================================================
// Module      : mux_2to1
// File        : mux_2to1.v
// Description : 2-to-1 Multiplexer RTL implementation.
// ============================================================

`timescale 1ns/1ps

module mux_2to1 #(
    parameter WIDTH = 1
)(
    input  wire [WIDTH-1:0] in0,   // Selected when sel = 0
    input  wire [WIDTH-1:0] in1,   // Selected when sel = 1
    input  wire             sel,   // Select signal
    output wire [WIDTH-1:0] out    // Multiplexer output
);

    // Dataflow description using conditional (ternary) operator
    assign out = sel ? in1 : in0;

endmodule

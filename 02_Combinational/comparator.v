// ============================================================
// Module      : comparator
// File        : comparator.v
// Description : 4-bit Magnitude Comparator Module
// ============================================================

/*
============================================================
YOUR ORIGINAL CODE (Preserved):
============================================================
module comparator(
    input [3:0] a,
    input [3:0] b,
    output lt,eq,gt
)
    assign eq = (a==b);
    assign lt = (a<b);
    assign gt = (a>b);
endmodule

// ----------------------------------------------------------
// EXPECTED OUTPUT TRUTH TABLE:
// ----------------------------------------------------------
// a b | lt eq gt
// 0 0 |  0   1   0
// 0 1 |  1   0   0
// 1 0 |  0   0   1
// 1 1 |  0   1   0
// ----------------------------------------------------------

============================================================
EXPLANATION OF MISTAKES:
1. Syntax Error: Missing semicolon ';' after the module port declaration list!
   'output lt,eq,gt)' should be 'output lt,eq,gt);'
2. Truth Table Note: Your truth table comment lists 1-bit values (0, 1), but
   the module ports 'a' and 'b' are 4-bit vectors [3:0]. 
   The logic expressions (a == b), (a < b), and (a > b) correctly operate on 
   4-bit vectors as well as parameterized widths!
============================================================
*/

// ============================================================
// CORRECTED CODE:
// ============================================================
`timescale 1ns/1ps

module comparator #(
    parameter WIDTH = 4
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire             lt,  // Less Than    (a < b)
    output wire             eq,  // Equal        (a == b)
    output wire             gt   // Greater Than (a > b)
);

    assign eq = (a == b);
    assign lt = (a < b);
    assign gt = (a > b);

endmodule

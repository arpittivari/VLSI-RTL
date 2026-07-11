// -----------------------------------------------------------------------------
// File        : mux2to1.v
// Description : A 2-to-1 Multiplexer using a continuous assignment (ternary operator)
// -----------------------------------------------------------------------------

module mux2to1 (
    input  wire in0, // Data input 0
    input  wire in1, // Data input 1
    input  wire sel, // Select signal
    
    output wire out  // Data output
);

    // Using the ternary operator: condition ? true_case : false_case
    // If sel is 1, out = in1. If sel is 0, out = in0.
    assign out = sel ? in1 : in0;

endmodule

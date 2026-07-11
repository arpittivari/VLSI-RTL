// -----------------------------------------------------------------------------
// File        : basic_logic_unit.v
// Description : A simple combinational logic block demonstrating basic Verilog
//               bitwise operators (AND, OR, XOR).
// -----------------------------------------------------------------------------

module basic_logic_unit (
    input  wire a,
    input  wire b,
    
    output wire out_and,
    output wire out_or,
    output wire out_xor
);

    // Continuous assignments for combinational logic
    assign out_and = a & b;
    assign out_or  = a | b;
    assign out_xor = a ^ b;

endmodule

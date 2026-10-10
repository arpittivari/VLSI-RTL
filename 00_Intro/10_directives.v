// File: 10_directives.v
// Topic: Compiler Directives — instructions to the tool, not hardware

// ─── `timescale ──────────────────────────────────────────────
// Must be FIRST thing in file (before module)
// Sets: time_unit / time_precision
`timescale 1ns / 1ps
//         ^^^   ^^^
//    #1 = 1ns  precision = 1ps

// ─── `define ─────────────────────────────────────────────────
// Creates a text macro — like find+replace before compile
`define BUS_WIDTH  8
`define MAX_COUNT  255
`define RESET_VAL  8'h00
`define CLK_PERIOD 10        // 10ns clock period

// ─── `ifdef / `ifndef / `else / `endif ───────────────────────
// Conditional compilation — include code only if macro is defined
`define SIMULATION           // comment this out for synthesis

module directives_demo (
    input              clk,
    input              rst,
    output [`BUS_WIDTH-1:0] data_out   // using `define macro
);

    `ifdef SIMULATION
        // This block only compiles when SIMULATION is defined
        initial begin
            $display("Running in simulation mode");
            $display("Bus width = %0d", `BUS_WIDTH);
            $display("Max count = %0d", `MAX_COUNT);
        end
    `else
        // This compiles when SIMULATION is NOT defined (synthesis)
        // (synthesis specific code would go here)
    `endif

    reg [`BUS_WIDTH-1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= `RESET_VAL;       // using defined constant
        else if (count == `MAX_COUNT)
            count <= `RESET_VAL;
        else
            count <= count + 1;
    end

    assign data_out = count;

endmodule


// ─── `default_nettype ─────────────────────────────────────────
// Best practice: set to none so undeclared signals cause errors
// (Put at TOP of file, before module)

// `default_nettype none    // <-- uncomment in real projects!

// Without it: typo in signal name silently creates a new 1-bit wire
// With it:    typo becomes a compile ERROR — catches bugs early!

// ─── `include ────────────────────────────────────────────────
// Inserts contents of another file here (like #include in C)
// Example (don't run — just reference):
// `include "my_defines.v"
// `include "parameters.vh"   // .vh = verilog header (convention)

// ─── `undef ──────────────────────────────────────────────────
// Remove a previously defined macro
`undef SIMULATION           // SIMULATION no longer defined after this line

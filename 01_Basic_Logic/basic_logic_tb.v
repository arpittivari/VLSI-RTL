// ============================================================
// File        : basic_logic_tb.v
// Description : Testbench for basic_logic_dataflow module.
//               Applies all 4 input combinations and checks
//               outputs using $display and $monitor.
// ============================================================

// ----------------------------------------------------------
// WHAT IS A TESTBENCH?
// ----------------------------------------------------------
// A testbench is a Verilog module with NO PORTS.
// It is not real hardware — it only exists in SIMULATION.
// Its job: generate input stimuli, apply them to the DUT
// (Device Under Test), and observe/check the outputs.
// ----------------------------------------------------------

// `timescale <time_unit> / <time_precision>
// This tells the simulator what #10 means.
// `timescale 1ns/1ps = each time unit is 1ns, precision is 1ps.
// #10 means wait 10ns. Always put this at the TOP of the file.
`timescale 1ns/1ps

module basic_logic_tb;   // Testbench: NO ports — it drives itself

// ----------------------------------------------------------
// SIGNAL DECLARATIONS
// ----------------------------------------------------------
// Inputs to DUT  → declared as 'reg' in testbench
//   (we drive them manually in initial block = procedural)
// Outputs of DUT → declared as 'wire' in testbench
//   (they are continuously driven by the DUT module)
// ----------------------------------------------------------

reg  a, b;         // Inputs we will control

wire and_out;      // Outputs we will observe
wire or_out;
wire xor_out;
wire not_out;
wire nand_out;
wire nor_out;
wire xnor_out;

// ----------------------------------------------------------
// DUT INSTANTIATION (Device Under Test)
// ----------------------------------------------------------
// Connect testbench signals to the module being tested.
// Syntax: module_name  instance_name (.port(signal), ...);
// Using named port mapping (.port_name(tb_signal)) —
// ALWAYS prefer this over positional mapping for clarity.
// ----------------------------------------------------------

basic_logic_dataflow DUT (
    .a       (a),
    .b       (b),
    .and_out (and_out),
    .or_out  (or_out),
    .xor_out (xor_out),
    .not_out (not_out),
    .nand_out(nand_out),
    .nor_out (nor_out),
    .xnor_out(xnor_out)
);

// ----------------------------------------------------------
// WAVEFORM DUMP (for GTKWave / other waveform viewers)
// ----------------------------------------------------------
// $dumpfile  : creates a .vcd (Value Change Dump) file
// $dumpvars  : records all signal changes in the module
// Open the .vcd file in GTKWave to see waveforms visually.
// ----------------------------------------------------------
initial begin
    $dumpfile("basic_logic_tb.vcd");
    $dumpvars(0, basic_logic_tb);
end

// ----------------------------------------------------------
// STIMULUS BLOCK
// ----------------------------------------------------------
// 'initial' block runs ONCE at time 0 and executes
// sequentially top-to-bottom (like a program).
// '#10' = wait 10 time units (10ns with our timescale).
// We test all 4 combinations: 00, 01, 10, 11
// ----------------------------------------------------------
initial begin

    // Print a header line for readability
    $display("Time | a b | AND OR XOR NOT NAND NOR XNOR");
    $display("-----|-----|-------------------------------");

    // $monitor : prints a new line AUTOMATICALLY whenever
    // any listed signal changes. Set it once, runs forever.
    $monitor("%4t | %b %b |  %b   %b   %b   %b    %b    %b    %b",
              $time, a, b,
              and_out, or_out, xor_out, not_out,
              nand_out, nor_out, xnor_out);

    // --- Test Case 1: a=0, b=0 ---
    a = 0; b = 0;
    #10;    // Wait 10ns — let outputs settle and $monitor print

    // --- Test Case 2: a=0, b=1 ---
    a = 0; b = 1;
    #10;

    // --- Test Case 3: a=1, b=0 ---
    a = 1; b = 0;
    #10;

    // --- Test Case 4: a=1, b=1 ---
    a = 1; b = 1;
    #10;

    // $finish : Ends the simulation.
    // Without this, simulation runs forever!
    $finish;

end

// ----------------------------------------------------------
// EXPECTED OUTPUT TRUTH TABLE (verify manually):
// ----------------------------------------------------------
// a b | AND  OR  XOR  NOT  NAND  NOR  XNOR
// 0 0 |  0    0    0    1    1     1     1
// 0 1 |  0    1    1    1    1     0     0
// 1 0 |  0    1    1    0    1     0     0
// 1 1 |  1    1    0    0    0     0     1
//
// NOT column = ~a only (not ~b)
// NAND/NOR are universal gates — their outputs are
// simply the complement of AND/OR outputs.
// ----------------------------------------------------------

endmodule

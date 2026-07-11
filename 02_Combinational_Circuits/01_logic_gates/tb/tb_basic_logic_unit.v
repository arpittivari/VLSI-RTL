// -----------------------------------------------------------------------------
// File        : tb_basic_logic_unit.v
// Description : Testbench for basic_logic_unit to verify its functionality.
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps // Time unit / Time precision

module tb_basic_logic_unit();

    // 1. Declare signals to connect to the Design Under Test (DUT)
    // Inputs to DUT are declared as 'reg' in testbench so we can drive them in 'initial' blocks
    reg  tb_a;
    reg  tb_b;
    
    // Outputs from DUT are declared as 'wire' in testbench
    wire tb_out_and;
    wire tb_out_or;
    wire tb_out_xor;

    // 2. Instantiate the DUT
    basic_logic_unit uut (
        .a(tb_a),
        .b(tb_b),
        .out_and(tb_out_and),
        .out_or(tb_out_or),
        .out_xor(tb_out_xor)
    );

    // 3. Write the test stimulus
    initial begin
        // Print a header to the console
        $display("Starting Simulation...");
        $display("Time\ta\tb\t|\tAND\tOR\tXOR");
        $display("----------------------------------------------------");
        
        // Monitor changes and print them
        $monitor("%0t\t%b\t%b\t|\t%b\t%b\t%b", $time, tb_a, tb_b, tb_out_and, tb_out_or, tb_out_xor);

        // Apply test vectors with delays (#10 means delay 10 time units)
        tb_a = 0; tb_b = 0;
        #10;
        
        tb_a = 0; tb_b = 1;
        #10;
        
        tb_a = 1; tb_b = 0;
        #10;
        
        tb_a = 1; tb_b = 1;
        #10;
        
        // End simulation
        $display("Simulation Complete.");
        $finish;
    end

endmodule

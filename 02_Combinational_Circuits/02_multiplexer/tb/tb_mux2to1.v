// -----------------------------------------------------------------------------
// File        : tb_mux2to1.v
// Description : Testbench for mux2to1 to verify its functionality and generate
//               VCD waves for GTKWave.
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_mux2to1();

    // 1. Declare signals
    reg  tb_in0;
    reg  tb_in1;
    reg  tb_sel;
    wire tb_out;

    // 2. Instantiate DUT
    mux2to1 uut (
        .in0(tb_in0),
        .in1(tb_in1),
        .sel(tb_sel),
        .out(tb_out)
    );

    // 3. Test Stimulus
    initial begin
        // ---------------------------------------------------------
        // CRITICAL: Dump variables for GTKWave
        // ---------------------------------------------------------
        $dumpfile("waveform.vcd");  // The output wave file
        $dumpvars(0, tb_mux2to1);   // Dump all variables in this module
        
        $display("Starting MUX Simulation...");
        $display("Time\tsel\tin1\tin0\t|\tout");
        $display("--------------------------------------------");
        $monitor("%0t\t%b\t%b\t%b\t|\t%b", $time, tb_sel, tb_in1, tb_in0, tb_out);

        // Test vectors
        tb_sel = 0; tb_in1 = 0; tb_in0 = 0; #10;
        tb_sel = 0; tb_in1 = 0; tb_in0 = 1; #10;
        tb_sel = 0; tb_in1 = 1; tb_in0 = 0; #10;
        tb_sel = 0; tb_in1 = 1; tb_in0 = 1; #10;
        
        tb_sel = 1; tb_in1 = 0; tb_in0 = 0; #10;
        tb_sel = 1; tb_in1 = 0; tb_in0 = 1; #10;
        tb_sel = 1; tb_in1 = 1; tb_in0 = 0; #10;
        tb_sel = 1; tb_in1 = 1; tb_in0 = 1; #10;

        $display("Simulation Complete.");
        $finish;
    end

endmodule

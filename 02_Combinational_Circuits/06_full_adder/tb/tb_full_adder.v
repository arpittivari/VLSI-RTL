// -----------------------------------------------------------------------------
// File        : tb_full_adder.v
// Description : Testbench for Full Adder.
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_full_adder();

    reg tb_a;
    reg tb_b;
    reg tb_cin;
    wire tb_sum;
    wire tb_cout;

    // Instantiate the Unit Under Test (UUT)
    full_adder uut (
        .a(tb_a),
        .b(tb_b),
        .cin(tb_cin),
        .sum(tb_sum),
        .cout(tb_cout)
    );

    initial begin
        // Initialize Inputs
        tb_a = 0;
        tb_b = 0;
        tb_cin = 0;

        // Monitor changes
        $monitor("Time=%0t | a=%b b=%b cin=%b | sum=%b cout=%b", $time, tb_a, tb_b, tb_cin, tb_sum, tb_cout);

        // Wait 10 ns for global reset to finish
        #10;
        
        // Add stimulus here
        tb_a = 0; tb_b = 0; tb_cin = 0; #10;
        tb_a = 0; tb_b = 0; tb_cin = 1; #10;
        tb_a = 0; tb_b = 1; tb_cin = 0; #10;
        tb_a = 0; tb_b = 1; tb_cin = 1; #10;
        tb_a = 1; tb_b = 0; tb_cin = 0; #10;
        tb_a = 1; tb_b = 0; tb_cin = 1; #10;
        tb_a = 1; tb_b = 1; tb_cin = 0; #10;
        tb_a = 1; tb_b = 1; tb_cin = 1; #10;

        $display("Testbench completed.");
        $finish;
    end

endmodule

// -----------------------------------------------------------------------------
// File        : tb_half_adder.v
// Description : Testbench for Half Adder.
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps


module tb_half_adder();

    reg tb_a;
    reg tb_b;
    wire tb_sum;
    wire tb_carry;

    half_adder uut (
        .a(tb_a),
        .b(tb_b),
        .sum(tb_sum),
        .carry(tb_carry)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_half_adder);
        
        $display("Starting Half Adder Simulation...");
        $display("Time\ta\tb\t|\tsum\tcarry");
        $display("--------------------------------------------");
        $monitor("%0t\t%b\t%b\t|\t%b\t%b", $time, tb_a, tb_b, tb_sum, tb_carry);

        tb_a = 0; tb_b = 0; #10;
        tb_a = 0; tb_b = 1; #10;
        tb_a = 1; tb_b = 0; #10;
        tb_a = 1; tb_b = 1; #10;

        $display("Simulation Complete.");
        $finish;
    end

endmodule

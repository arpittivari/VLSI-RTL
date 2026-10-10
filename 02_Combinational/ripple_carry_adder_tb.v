// ============================================================
// File        : ripple_carry_adder_tb.v
// Description : Testbench for 4-bit Ripple Carry Adder
// ============================================================

`timescale 1ns/1ps

module ripple_carry_adder_tb;

    reg  [3:0] a, b;
    reg        c_in;
    wire [3:0] sum;
    wire       c_out;

    integer errors = 0;
    reg [4:0] expected;

    // Instantiate Structural DUT
    ripple_carry_adder dut (
        .a(a),
        .b(b),
        .c_in(c_in),
        .sum(sum),
        .c_out(c_out)
    );

    initial begin
        $dumpfile("ripple_carry_adder_tb.vcd");
        $dumpvars(0, ripple_carry_adder_tb);

        $display("=================================================");
        $display("       STARTING RIPPLE CARRY ADDER TEST          ");
        $display("=================================================");

        // Test 1: 5 + 3 + 0 = 8 (sum=8, c_out=0)
        a = 4'd5; b = 4'd3; c_in = 1'b0; #10;
        expected = a + b + c_in;
        $display("[Time %0t] a=%0d, b=%0d, c_in=%b | sum=%0d, c_out=%b", $time, a, b, c_in, sum, c_out);
        if ({c_out, sum} !== expected) begin
            $display("ERROR! Expected sum=%0d, c_out=%b", expected[3:0], expected[4]);
            errors = errors + 1;
        end

        // Test 2: 12 + 7 + 1 = 20 (sum=4, c_out=1)
        a = 4'd12; b = 4'd7; c_in = 1'b1; #10;
        expected = a + b + c_in;
        $display("[Time %0t] a=%0d, b=%0d, c_in=%b | sum=%0d, c_out=%b", $time, a, b, c_in, sum, c_out);
        if ({c_out, sum} !== expected) begin
            $display("ERROR! Expected sum=%0d, c_out=%b", expected[3:0], expected[4]);
            errors = errors + 1;
        end

        // Test 3: 15 + 15 + 1 = 31 (sum=15, c_out=1)
        a = 4'd15; b = 4'd15; c_in = 1'b1; #10;
        expected = a + b + c_in;
        $display("[Time %0t] a=%0d, b=%0d, c_in=%b | sum=%0d, c_out=%b", $time, a, b, c_in, sum, c_out);
        if ({c_out, sum} !== expected) begin
            $display("ERROR! Expected sum=%0d, c_out=%b", expected[3:0], expected[4]);
            errors = errors + 1;
        end

        $display("=================================================");
        if (errors == 0)
            $display("   RIPPLE CARRY ADDER TEST PASSED SUCCESSFULLY!  ");
        else
            $display("   RIPPLE CARRY ADDER TEST FAILED (%0d ERRORS)   ", errors);
        $display("=================================================");
        $finish;
    end

endmodule

// ============================================================
// File        : comparator_tb.v
// Description : Testbench for 4-bit Magnitude Comparator Module
// ============================================================

`timescale 1ns/1ps

module comparator_tb;

    parameter WIDTH = 4;

    reg  [WIDTH-1:0] a, b;
    wire             lt, eq, gt;

    integer errors = 0;

    // Instantiate DUT
    comparator #(.WIDTH(WIDTH)) dut (
        .a(a),
        .b(b),
        .lt(lt),
        .eq(eq),
        .gt(gt)
    );

    initial begin
        $dumpfile("comparator_tb.vcd");
        $dumpvars(0, comparator_tb);

        $display("=================================================");
        $display("           STARTING COMPARATOR TEST              ");
        $display("=================================================");

        // Test 1: Equal (a == b)
        a = 4'd5; b = 4'd5; #10;
        $display("[Time %0t] a=%0d, b=%0d | lt=%b, eq=%b, gt=%b", $time, a, b, lt, eq, gt);
        if (eq !== 1'b1 || lt !== 1'b0 || gt !== 1'b0) begin
            $display("ERROR: Expected eq=1, lt=0, gt=0!");
            errors = errors + 1;
        end

        // Test 2: Less than (a < b)
        a = 4'd3; b = 4'd9; #10;
        $display("[Time %0t] a=%0d, b=%0d | lt=%b, eq=%b, gt=%b", $time, a, b, lt, eq, gt);
        if (lt !== 1'b1 || eq !== 1'b0 || gt !== 1'b0) begin
            $display("ERROR: Expected lt=1, eq=0, gt=0!");
            errors = errors + 1;
        end

        // Test 3: Greater than (a > b)
        a = 4'd12; b = 4'd4; #10;
        $display("[Time %0t] a=%0d, b=%0d | lt=%b, eq=%b, gt=%b", $time, a, b, lt, eq, gt);
        if (gt !== 1'b1 || eq !== 1'b0 || lt !== 1'b0) begin
            $display("ERROR: Expected gt=1, eq=0, lt=0!");
            errors = errors + 1;
        end

        $display("=================================================");
        if (errors == 0)
            $display("    COMPARATOR TEST PASSED SUCCESSFULLY!         ");
        else
            $display("    COMPARATOR TEST FAILED WITH %0d ERRORS       ", errors);
        $display("=================================================");
        $finish;
    end

endmodule
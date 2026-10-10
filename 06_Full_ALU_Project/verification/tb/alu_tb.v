// ============================================================
// Module      : alu_tb
// File        : alu_tb.v
// Description : Self-checking testbench for 8-bit ALU
// Run         : iverilog -g2012 -I rtl -o sim/alu_sim.vvp rtl/alu.v verification/tb/alu_tb.v
//               vvp sim/alu_sim.vvp
// ============================================================
`timescale 1ns/1ps
`include "alu_pkg.vh"

module alu_tb;

    // ── DUT Signals ─────────────────────────────────────────
    reg  [7:0] a, b;
    reg  [2:0] op;
    reg        cin;
    wire [7:0] result;
    wire       cout, zero, negative, overflow, parity;

    // ── Counters ────────────────────────────────────────────
    integer pass = 0, fail = 0, n = 0;

    // ── DUT Instance ────────────────────────────────────────
    alu dut (.a(a), .b(b), .op(op), .cin(cin),
             .result(result), .cout(cout), .zero(zero),
             .negative(negative), .overflow(overflow), .parity(parity));

    // ── Waveform Dump ───────────────────────────────────────
    initial begin
        $dumpfile("sim/alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

    // ── Check Task ──────────────────────────────────────────
    task check;
        input [7:0]  exp_res;
        input        exp_cout, exp_zero;
        input [79:0] name;
        begin
            n = n + 1; #1;
            if (result===exp_res && cout===exp_cout && zero===exp_zero) begin
                $display("[PASS] #%0d %-10s | a=%3d b=%3d op=%b | res=%3d cout=%b zero=%b",
                          n, name, a, b, op, result, cout, zero);
                pass = pass + 1;
            end else begin
                $display("[FAIL] #%0d %-10s | a=%3d b=%3d op=%b", n, name, a, b, op);
                $display("       exp res=%3d cout=%b zero=%b", exp_res, exp_cout, exp_zero);
                $display("       got res=%3d cout=%b zero=%b", result, cout, zero);
                fail = fail + 1;
            end
        end
    endtask

    // ── Test Stimulus ───────────────────────────────────────
    initial begin
        {a, b, op, cin} = 0;
        $display("\n===== 8-bit ALU TESTBENCH =====\n");
        #10;

        // ADD
        a=5;   b=3;   op=`ALU_ADD; cin=0; #10; check(8,   0, 0, "ADD 5+3");
        a=255; b=1;   op=`ALU_ADD; cin=0; #10; check(0,   1, 1, "ADD ovf");
        a=5;   b=3;   op=`ALU_ADD; cin=1; #10; check(9,   0, 0, "ADD cin");
        a=0;   b=0;   op=`ALU_ADD; cin=0; #10; check(0,   0, 1, "ADD zero");

        // SUB
        a=10;  b=3;   op=`ALU_SUB; cin=0; #10; check(7,   0, 0, "SUB 10-3");
        a=5;   b=5;   op=`ALU_SUB; cin=0; #10; check(0,   0, 1, "SUB zero");
        a=3;   b=10;  op=`ALU_SUB; cin=0; #10; check(249, 1, 0, "SUB borrow");

        // AND
        a=8'hFF; b=8'h0F; op=`ALU_AND; cin=0; #10; check(8'h0F, 0, 0, "AND mask");
        a=8'hAA; b=8'h55; op=`ALU_AND; cin=0; #10; check(8'h00, 0, 1, "AND zero");

        // OR
        a=8'hAA; b=8'h55; op=`ALU_OR;  cin=0; #10; check(8'hFF, 0, 0, "OR full");
        a=0;     b=0;     op=`ALU_OR;  cin=0; #10; check(0,      0, 1, "OR zero");

        // XOR
        a=8'hAB; b=8'hAB; op=`ALU_XOR; cin=0; #10; check(0,      0, 1, "XOR self");
        a=8'hFF; b=8'h00; op=`ALU_XOR; cin=0; #10; check(8'hFF,  0, 0, "XOR FF");

        // NOT
        a=8'h00; b=0; op=`ALU_NOT; cin=0; #10; check(8'hFF, 0, 0, "NOT 00");
        a=8'hFF; b=0; op=`ALU_NOT; cin=0; #10; check(8'h00, 0, 1, "NOT FF");
        a=8'hAA; b=0; op=`ALU_NOT; cin=0; #10; check(8'h55, 0, 0, "NOT AA");

        // SHL
        a=8'h01; b=0; op=`ALU_SHL; cin=0; #10; check(8'h02, 0, 0, "SHL 01");
        a=8'h80; b=0; op=`ALU_SHL; cin=0; #10; check(8'h00, 1, 1, "SHL 80");
        a=8'h55; b=0; op=`ALU_SHL; cin=0; #10; check(8'hAA, 0, 0, "SHL 55");

        // SHR
        a=8'h80; b=0; op=`ALU_SHR; cin=0; #10; check(8'h40, 0, 0, "SHR 80");
        a=8'h01; b=0; op=`ALU_SHR; cin=0; #10; check(8'h00, 1, 1, "SHR 01");
        a=8'hAA; b=0; op=`ALU_SHR; cin=0; #10; check(8'h55, 0, 0, "SHR AA");

        // Summary
        #10;
        $display("\n===== RESULTS: %0d PASS | %0d FAIL | %0d TOTAL =====", pass, fail, n);
        $display(fail==0 ? "STATUS: ALL PASSED ✅" : "STATUS: FAILED ❌");
        $finish;
    end

    // Timeout
    initial begin #5000; $display("[TIMEOUT]"); $finish; end

endmodule

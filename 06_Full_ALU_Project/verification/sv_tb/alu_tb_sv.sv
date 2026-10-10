// ============================================================
// File        : alu_tb_sv.sv
// Description : SystemVerilog OOP-style testbench
//               — Interface, Transaction class, Driver,
//                 Monitor, Scoreboard, Test
// Run: iverilog -g2012 -I rtl -o sim/alu_sv_sim.vvp \
//       rtl/alu.v verification/sv_tb/alu_tb_sv.sv
//      vvp sim/alu_sv_sim.vvp
// ============================================================
`timescale 1ns/1ps
`include "alu_pkg.vh"

// ============================================================
// INTERFACE — bundles all DUT signals into one object
// WHY: Instead of passing 10 ports everywhere, pass 1 interface
// ============================================================
interface alu_if;
    logic [7:0] a, b;
    logic [2:0] op;
    logic       cin;
    logic [7:0] result;
    logic       cout, zero, negative, overflow, parity;
endinterface

// ============================================================
// TRANSACTION — one stimulus+response packet (like a struct)
// WHY: Groups related data together, easy to randomize
// ============================================================
class Transaction;
    // Stimulus fields
    rand logic [7:0] a, b;
    rand logic [2:0] op;
    rand logic       cin;
    // Response fields (filled by monitor)
    logic [7:0] result;
    logic       cout, zero, negative, overflow, parity;

    // Print method
    function void print(string tag);
        $display("[%s] a=%3d b=%3d op=%3b cin=%b | res=%3d cout=%b zero=%b",
                 tag, a, b, op, cin, result, cout, zero);
    endfunction
endclass

// ============================================================
// SCOREBOARD — golden reference model
// Receives transactions, computes expected, compares to DUT
// ============================================================
class Scoreboard;
    int pass_cnt = 0;
    int fail_cnt = 0;

    task check(Transaction tr);
        logic [8:0] exp;
        logic [7:0] exp_result;
        logic       exp_cout, exp_zero;
        logic [7:0] a_in, b_in;
        logic [2:0] op_in;
        logic       cin_in;

        // Copy out of class to local variables (avoids iverilog class slicing bug)
        a_in   = tr.a;
        b_in   = tr.b;
        op_in  = tr.op;
        cin_in = tr.cin;

        // Golden model — same logic as DUT
        case (op_in)
            `ALU_ADD: exp = {1'b0, a_in} + {1'b0, b_in} + cin_in;
            `ALU_SUB: exp = {1'b0, a_in} - {1'b0, b_in};
            `ALU_AND: exp = {1'b0, a_in & b_in};
            `ALU_OR:  exp = {1'b0, a_in | b_in};
            `ALU_XOR: exp = {1'b0, a_in ^ b_in};
            `ALU_NOT: exp = {1'b0, ~a_in};
            `ALU_SHL: exp = {a_in, 1'b0};
            `ALU_SHR: exp = {a_in[0], 1'b0, a_in[7:1]};
            default:  exp = 0;
        endcase

        exp_result = exp[7:0];
        exp_cout   = exp[8];
        exp_zero   = ~(|exp[7:0]);

        if (tr.result === exp_result &&
            tr.cout  === exp_cout   &&
            tr.zero  === exp_zero) begin
            pass_cnt = pass_cnt + 1;
        end else begin
            fail_cnt = fail_cnt + 1;
            $display("[FAIL] a=%3d b=%3d op=%3b | exp_res=%3d got_res=%3d | exp_cout=%b got_cout=%b",
                     a_in, b_in, op_in, exp_result, tr.result, exp_cout, tr.cout);
        end
    endtask

    function void report();
        $display("\n===== SCOREBOARD REPORT =====");
        $display("  PASS : %0d", pass_cnt);
        $display("  FAIL : %0d", fail_cnt);
        $display("  TOTAL: %0d", pass_cnt + fail_cnt);
        $display(fail_cnt == 0 ? "  STATUS: ALL PASSED ✅" : "  STATUS: FAILED ❌");
    endfunction
endclass

// ============================================================
// TESTBENCH TOP — wires everything together
// ============================================================
module alu_tb_sv;

    // Interface instance
    alu_if vif();

    // DUT connected via interface
    alu dut (
        .a        (vif.a),
        .b        (vif.b),
        .op       (vif.op),
        .cin      (vif.cin),
        .result   (vif.result),
        .cout     (vif.cout),
        .zero     (vif.zero),
        .negative (vif.negative),
        .overflow (vif.overflow),
        .parity   (vif.parity)
    );

    // Waveform
    initial begin
        $dumpfile("sim/alu_tb_sv.vcd");
        $dumpvars(0, alu_tb_sv);
    end

    // ── Main Test Program ────────────────────────────────────
    initial begin
        Transaction tr;
        Scoreboard  sb;
        sb = new();

        $display("\n===== SV OOP TESTBENCH — 8-bit ALU =====");

        // ── DIRECTED TESTS (corner cases) ───────────────────
        $display("\n[1] Directed Corner Cases...");

        // ADD overflow
        tr = new(); tr.a=8'hFF; tr.b=8'h01; tr.op=`ALU_ADD; tr.cin=0; #1;
        vif.a=tr.a; vif.b=tr.b; vif.op=tr.op; vif.cin=tr.cin; #10;
        tr.result=vif.result; tr.cout=vif.cout; tr.zero=vif.zero; sb.check(tr);

        // SUB underflow
        tr = new(); tr.a=0; tr.b=8'hFF; tr.op=`ALU_SUB; tr.cin=0;
        vif.a=tr.a; vif.b=tr.b; vif.op=tr.op; vif.cin=tr.cin; #10;
        tr.result=vif.result; tr.cout=vif.cout; tr.zero=vif.zero; sb.check(tr);

        // AND mask
        tr = new(); tr.a=8'hAA; tr.b=8'h55; tr.op=`ALU_AND; tr.cin=0;
        vif.a=tr.a; vif.b=tr.b; vif.op=tr.op; vif.cin=tr.cin; #10;
        tr.result=vif.result; tr.cout=vif.cout; tr.zero=vif.zero; sb.check(tr);

        // NOT all ones
        tr = new(); tr.a=8'hFF; tr.b=0; tr.op=`ALU_NOT; tr.cin=0;
        vif.a=tr.a; vif.b=tr.b; vif.op=tr.op; vif.cin=tr.cin; #10;
        tr.result=vif.result; tr.cout=vif.cout; tr.zero=vif.zero; sb.check(tr);

        // SHL MSB out
        tr = new(); tr.a=8'h80; tr.b=0; tr.op=`ALU_SHL; tr.cin=0;
        vif.a=tr.a; vif.b=tr.b; vif.op=tr.op; vif.cin=tr.cin; #10;
        tr.result=vif.result; tr.cout=vif.cout; tr.zero=vif.zero; sb.check(tr);

        // ── RANDOM TESTS ─────────────────────────────────────
        $display("[2] Running 500 random tests...");
        repeat(500) begin
            tr = new();
            // Unsigned random generator
            tr.a   = $urandom & 8'hFF;
            tr.b   = $urandom & 8'hFF;
            tr.op  = $urandom % 8;
            tr.cin = $urandom % 2;

            vif.a=tr.a; vif.b=tr.b; vif.op=tr.op; vif.cin=tr.cin;
            #10;
            tr.result=vif.result; tr.cout=vif.cout; tr.zero=vif.zero;
            sb.check(tr);
        end

        // ── OPCODE SWEEP (all ops, boundary values) ──────────
        $display("[3] Sweeping all opcodes with boundary values...");
        begin
            integer o;
            reg [7:0] vals [0:3];
            reg [7:0] val;
            vals[0]=8'h00; vals[1]=8'hFF; vals[2]=8'h55; vals[3]=8'hAA;
            for (int vi = 0; vi < 4; vi++) begin
                val = vals[vi];
                for (o = 0; o < 8; o++) begin
                    tr = new(); tr.a=val; tr.b=~val; tr.op=o[2:0]; tr.cin=0;
                    vif.a=tr.a; vif.b=tr.b; vif.op=tr.op; vif.cin=tr.cin; #10;
                    tr.result=vif.result; tr.cout=vif.cout; tr.zero=vif.zero;
                    sb.check(tr);
                end
            end
        end

        // Final report
        sb.report();
        $finish;
    end

    initial begin #50000; $display("[TIMEOUT]"); $finish; end

endmodule

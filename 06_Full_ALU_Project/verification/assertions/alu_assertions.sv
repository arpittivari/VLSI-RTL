// ============================================================
// File        : alu_assertions.sv
// Description : Assertions for 8-bit ALU (iverilog compatible)
//
// NOTE ON TOOLS:
//   Full concurrent SVA (assert property) needs commercial tools
//   (Questa, VCS, Xcelium). Icarus Verilog supports:
//   — Immediate assertions: assert(expr) inside always/initial
//   — We simulate concurrent behavior with always @(*)
// ============================================================
`timescale 1ns/1ps
`include "alu_pkg.vh"

module alu_assertions;

    // ── Signals ─────────────────────────────────────────────
    reg  [7:0] a, b;
    reg  [2:0] op;
    reg        cin;
    wire [7:0] result;
    wire       cout, zero, negative, overflow, parity;

    // ── DUT ─────────────────────────────────────────────────
    alu dut(.a(a),.b(b),.op(op),.cin(cin),
            .result(result),.cout(cout),.zero(zero),
            .negative(negative),.overflow(overflow),.parity(parity));

    // ── Assertion counters ───────────────────────────────────
    integer assert_pass = 0, assert_fail = 0;

    // ── Immediate Assertions — checked after every stimulus ──
    // These fire inside an always block triggered by output changes
    task check_assertions;
        input [7:0] a_in, b_in;
        input [2:0] op_in;
        begin
            #1; // let outputs settle

            // ASSERT 1: Zero flag == (result is all zeros)
            if (zero !== (~(|result))) begin
                $display("[ASSERT FAIL] Zero flag wrong | result=%b zero=%b", result, zero);
                assert_fail++;
            end else assert_pass++;

            // ASSERT 2: Negative flag == MSB of result
            if (negative !== result[7]) begin
                $display("[ASSERT FAIL] Negative flag wrong | result[7]=%b negative=%b", result[7], negative);
                assert_fail++;
            end else assert_pass++;

            // ASSERT 3: No X or Z in result
            if ($isunknown(result)) begin
                $display("[ASSERT FAIL] result has X/Z! op=%b a=%h b=%h result=%b", op_in, a_in, b_in, result);
                assert_fail++;
            end else assert_pass++;

            // ASSERT 4: AND result must be subset of A
            if (op_in == `ALU_AND && (result & a_in) !== result) begin
                $display("[ASSERT FAIL] AND result not subset of A | a=%h b=%h res=%h", a_in, b_in, result);
                assert_fail++;
            end else if (op_in == `ALU_AND) assert_pass++;

            // ASSERT 5: OR result must be superset of A
            if (op_in == `ALU_OR && (result | a_in) !== result) begin
                $display("[ASSERT FAIL] OR result not superset of A | a=%h b=%h res=%h", a_in, b_in, result);
                assert_fail++;
            end else if (op_in == `ALU_OR) assert_pass++;

            // ASSERT 6: XOR with same operands must give 0
            if (op_in == `ALU_XOR && a_in === b_in && result !== 8'h00) begin
                $display("[ASSERT FAIL] XOR A^A != 0 | a=%h result=%h", a_in, result);
                assert_fail++;
            end else if (op_in == `ALU_XOR && a_in === b_in) assert_pass++;

            // ASSERT 7: NOT result must be bitwise complement of A
            if (op_in == `ALU_NOT && result !== ~a_in) begin
                $display("[ASSERT FAIL] NOT result wrong | a=%h result=%h expected=%h", a_in, result, ~a_in);
                assert_fail++;
            end else if (op_in == `ALU_NOT) assert_pass++;

            // ASSERT 8: SHL result LSB must be 0
            if (op_in == `ALU_SHL && result[0] !== 1'b0) begin
                $display("[ASSERT FAIL] SHL result[0] != 0 | a=%h result=%h", a_in, result);
                assert_fail++;
            end else if (op_in == `ALU_SHL) assert_pass++;

            // ASSERT 9: SHR result MSB must be 0 (logical shift)
            if (op_in == `ALU_SHR && result[7] !== 1'b0) begin
                $display("[ASSERT FAIL] SHR result[7] != 0 | a=%h result=%h", a_in, result);
                assert_fail++;
            end else if (op_in == `ALU_SHR) assert_pass++;

            // ASSERT 10: ADD without cout: result >= a and >= b
            if (op_in == `ALU_ADD && cout === 1'b0) begin
                if (result < a_in || result < b_in) begin
                    $display("[ASSERT FAIL] ADD no-carry but result < operand | a=%0d b=%0d res=%0d", a_in, b_in, result);
                    assert_fail++;
                end else assert_pass++;
            end
        end
    endtask

    // ── Stimulus + Assertion Checks ─────────────────────────
    integer i, o;
    reg [7:0] test_vals [0:3];

    initial begin
        $dumpfile("sim/alu_assert.vcd");
        $dumpvars(0, alu_assertions);
        {a, b, op, cin} = 0;

        test_vals[0] = 8'h00; test_vals[1] = 8'hFF;
        test_vals[2] = 8'h55; test_vals[3] = 8'hAA;

        $display("\n===== SVA ASSERTIONS — 8-bit ALU =====\n");

        // ── Sweep all ops with boundary values ───────────────
        $display("[1] Boundary value sweep (all 8 ops x 4 values)...");
        for (i = 0; i < 4; i++) begin
            for (o = 0; o < 8; o++) begin
                a = test_vals[i]; b = ~test_vals[i];
                op = o[2:0]; cin = 0;
                check_assertions(a, b, op);
            end
        end

        // ── XOR self = 0 ────────────────────────────────────
        $display("[2] XOR self-check (a^a=0) x 20...");
        repeat(20) begin
            a = $random; b = a; op = `ALU_XOR; cin = 0;
            check_assertions(a, b, op);
        end

        // ── NOT inverse ─────────────────────────────────────
        $display("[3] NOT inverse check x 20...");
        repeat(20) begin
            a = $random; b = 0; op = `ALU_NOT; cin = 0;
            check_assertions(a, b, op);
        end

        // ── Random stimulus ─────────────────────────────────
        $display("[4] Random stimulus x 200...");
        repeat(200) begin
            a = $random; b = $random;
            op = $random % 8; cin = $random % 2;
            check_assertions(a, b, op);
        end

        // ── Report ──────────────────────────────────────────
        #10;
        $display("\n===== ASSERTION RESULTS =====");
        $display("  PASS: %0d", assert_pass);
        $display("  FAIL: %0d", assert_fail);
        $display(assert_fail == 0 ? "  ALL ASSERTIONS HOLD ✅" : "  ASSERTIONS FAILED ❌");
        $finish;
    end

    initial begin #50000; $display("[TIMEOUT]"); $finish; end

endmodule

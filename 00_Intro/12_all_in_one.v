// ============================================================
// File        : 12_all_in_one.v
// Description : ONE file that uses EVERYTHING —
//               number formats, data types, all operators,
//               gate primitives, directives, system tasks
// ============================================================

// ── 10: DIRECTIVES ──────────────────────────────────────────
`timescale 1ns/1ps
`define BUS_WIDTH  8
`define MAX_VAL    8'hFF
`define ZERO       8'h00

`ifdef SIMULATION
`endif


// ============================================================
//  DUT — Design module using all operators and constructs
// ============================================================
module all_in_one_dut (
    input  clk,
    input  rst,
    input  [`BUS_WIDTH-1:0] a,       // `define used in port
    input  [`BUS_WIDTH-1:0] b,
    input  sel,
    input  ctrl,

    // ── 02: DATA TYPES — port outputs ────────────────────
    output wire [`BUS_WIDTH-1:0] and_out,
    output wire [`BUS_WIDTH-1:0] or_out,
    output wire [`BUS_WIDTH-1:0] xor_out,
    output wire [`BUS_WIDTH-1:0] not_out,
    output wire [`BUS_WIDTH-1:0] nand_out,
    output wire [`BUS_WIDTH-1:0] nor_out,
    output wire [`BUS_WIDTH-1:0] xnor_out,
    output wire [`BUS_WIDTH-1:0] add_out,
    output wire [`BUS_WIDTH-1:0] sub_out,
    output wire [`BUS_WIDTH-1:0] mul_out,
    output wire [`BUS_WIDTH-1:0] div_out,
    output wire [`BUS_WIDTH-1:0] mod_out,
    output wire [`BUS_WIDTH-1:0] lshift_out,
    output wire [`BUS_WIDTH-1:0] rshift_out,
    output wire [`BUS_WIDTH-1:0] arshift_out,
    output wire [`BUS_WIDTH-1:0] mux_out,
    output wire [15:0]           concat_out,
    output wire [`BUS_WIDTH-1:0] replic_out,
    output wire                  and_red,
    output wire                  or_red,
    output wire                  xor_red,
    output wire                  eq_flag,
    output wire                  gt_flag,
    output wire                  lt_flag,
    output wire                  bufif1_out,
    output reg  [`BUS_WIDTH-1:0] reg_out
);

    // ── 02: DATA TYPES — internal signals ─────────────────
    wire        and_gate_out;
    wire        g_wire;
    wire        tri_wire;

    // ── 01: NUMBER FORMATS — constants in all bases ────────
    wire [3:0]  bin_val   = 4'b1010;          // Binary
    wire [7:0]  hex_val   = 8'hCA;            // Hexadecimal
    wire [7:0]  dec_val   = 8'd202;           // Decimal
    wire [5:0]  oct_val   = 6'o312;           // Octal
    wire [15:0] under_val = 16'b1010_1010_1100_0011; // underscore
    wire [3:0]  x_val     = 4'bxxxx;          // unknown X
    wire [3:0]  z_val     = 4'bzzzz;          // high-Z

    // ── 03: BITWISE OPERATORS ─────────────────────────────
    assign and_out  = a & b;           // AND
    assign or_out   = a | b;           // OR
    assign xor_out  = a ^ b;           // XOR
    assign not_out  = ~a;              // NOT
    assign nand_out = ~(a & b);        // NAND
    assign nor_out  = ~(a | b);        // NOR
    assign xnor_out = a ~^ b;          // XNOR (native operator)

    // ── 04: ARITHMETIC OPERATORS ──────────────────────────
    assign add_out  = a + b;           // Addition
    assign sub_out  = a - b;           // Subtraction
    assign mul_out  = a * b;           // Multiplication
    assign div_out  = a / b;           // Division (integer)
    assign mod_out  = a % b;           // Modulo (remainder)

    // ── 06: SHIFT OPERATORS ───────────────────────────────
    assign lshift_out  = a << 2;               // Logical left shift
    assign rshift_out  = a >> 2;               // Logical right shift
    assign arshift_out = $signed(a) >>> 2;     // Arithmetic right shift

    // ── 08: SPECIAL OPERATORS ─────────────────────────────
    assign mux_out   = sel ? a : b;            // Ternary = 2:1 MUX
    assign concat_out = {a, b};                // Concatenation = 16-bit
    assign replic_out = {2{a[3:0]}}}           // Replication

    // ── 07: REDUCTION OPERATORS ───────────────────────────
    assign and_red  = &a;              // 1 only if ALL bits of a are 1
    assign or_red   = |a;              // 1 if ANY bit of a is 1
    assign xor_red  = ^a;              // parity of a

    // ── 05: RELATIONAL OPERATORS ──────────────────────────
    assign eq_flag  = (a == b);        // equality
    assign gt_flag  = (a >  b);        // greater than
    assign lt_flag  = (a <  b);        // less than

    // ── 09: GATE PRIMITIVES ───────────────────────────────
    and   g_and  (and_gate_out, a[0], b[0]);   // AND primitive
    or    g_or   (g_wire,       a[1], b[1]);   // OR primitive
    bufif1 g_buf (bufif1_out,   a[0], ctrl);   // tri-state buffer

    // ── 02: DATA TYPES — reg driven by always block ───────
    always @(posedge clk or posedge rst) begin
        if (rst)
            reg_out <= `ZERO;                  // non-blocking <=
        else if (a == `MAX_VAL)
            reg_out <= `ZERO;
        else
            reg_out <= a + 8'd1;
    end

endmodule


// ============================================================
//  TESTBENCH — uses ALL system tasks and directives
// ============================================================
module all_in_one_tb;

    // ── 02: DATA TYPES — testbench signals ─────────────────
    reg        clk, rst, sel, ctrl;
    reg  [7:0] a, b;
    wire [7:0] and_out, or_out, xor_out, not_out;
    wire [7:0] nand_out, nor_out, xnor_out;
    wire [7:0] add_out, sub_out, mul_out, div_out, mod_out;
    wire [7:0] lshift_out, rshift_out, arshift_out;
    wire [7:0] mux_out, replic_out, reg_out;
    wire [15:0] concat_out;
    wire        and_red, or_red, xor_red;
    wire        eq_flag, gt_flag, lt_flag, bufif1_out;

    integer i;      // integer — for loop counter

    // ── DUT INSTANTIATION — . dot used for named ports ─────
    all_in_one_dut DUT (
        .clk       (clk),
        .rst       (rst),
        .a         (a),
        .b         (b),
        .sel       (sel),
        .ctrl      (ctrl),
        .and_out   (and_out),
        .or_out    (or_out),
        .xor_out   (xor_out),
        .not_out   (not_out),
        .nand_out  (nand_out),
        .nor_out   (nor_out),
        .xnor_out  (xnor_out),
        .add_out   (add_out),
        .sub_out   (sub_out),
        .mul_out   (mul_out),
        .div_out   (div_out),
        .mod_out   (mod_out),
        .lshift_out(lshift_out),
        .rshift_out(rshift_out),
        .arshift_out(arshift_out),
        .mux_out   (mux_out),
        .concat_out(concat_out),
        .replic_out(replic_out),
        .and_red   (and_red),
        .or_red    (or_red),
        .xor_red   (xor_red),
        .eq_flag   (eq_flag),
        .gt_flag   (gt_flag),
        .lt_flag   (lt_flag),
        .bufif1_out(bufif1_out),
        .reg_out   (reg_out)
    );

    // ── 11: WAVEFORM DUMP ──────────────────────────────────
    initial begin
        $dumpfile("all_in_one.vcd");
        $dumpvars(0, all_in_one_tb);
    end

    // ── 11: CLOCK GENERATION — forever loop ────────────────
    initial clk = 0;
    always #5 clk = ~clk;     // 10ns period

    // ── 11: $monitor — fires on every change ───────────────
    initial begin
        $monitor("t=%0t | a=%h b=%h | AND=%h OR=%h XOR=%h ADD=%h",
                  $time, a, b, and_out, or_out, xor_out, add_out);
    end

    // ── MAIN STIMULUS BLOCK ─────────────────────────────────
    initial begin
        // initialize
        rst  = 1; sel = 0; ctrl = 1;
        a    = `ZERO;          // using `define
        b    = `ZERO;

        // ── 11: $display ───────────────────────────────────
        $display("==========================================");
        $display("  ALL-IN-ONE VERILOG DEMO  ");
        $display("==========================================");

        #10; rst = 0;

        // ── 01: NUMBER FORMATS in stimulus ─────────────────
        a = 8'b10110011;       // binary
        b = 8'hAF;             // hex
        #10;

        a = 8'd175;            // decimal
        b = 8'o257;            // octal
        #10;

        // ── 11: $display with format specifiers ────────────
        $display("a=%b (bin)  a=%h (hex)  a=%0d (dec)", a, a, a);
        $display("b=%b (bin)  b=%h (hex)  b=%0d (dec)", b, b, b);

        // ── 03: BITWISE results ────────────────────────────
        $display("--- Bitwise Operators ---");
        $display("AND  : %b", and_out);
        $display("OR   : %b", or_out);
        $display("XOR  : %b", xor_out);
        $display("NOT a: %b", not_out);
        $display("NAND : %b", nand_out);
        $display("NOR  : %b", nor_out);
        $display("XNOR : %b", xnor_out);

        // ── 04: ARITHMETIC results ─────────────────────────
        $display("--- Arithmetic Operators ---");
        $display("ADD  : %0d + %0d = %0d", a, b, add_out);
        $display("SUB  : %0d - %0d = %0d", a, b, sub_out);
        $display("MUL  : %0d * %0d = %0d", a, b, mul_out);
        $display("DIV  : %0d / %0d = %0d", a, b, div_out);
        $display("MOD  : %0d %% %0d = %0d", a, b, mod_out);  // %% = literal %

        // ── 06: SHIFT results ──────────────────────────────
        $display("--- Shift Operators ---");
        $display("a<<2   : %b", lshift_out);
        $display("a>>2   : %b", rshift_out);
        $display("a>>>2  : %b (arithmetic)", arshift_out);

        // ── 07: REDUCTION results ──────────────────────────
        $display("--- Reduction Operators ---");
        $display("&a (all 1s?) : %b", and_red);
        $display("|a (any 1s?) : %b", or_red);
        $display("^a (parity)  : %b", xor_red);

        // ── 08: SPECIAL results ────────────────────────────
        $display("--- Special Operators ---");
        $display("MUX  (sel=0): %h", mux_out);
        $display("Concat {a,b}: %h", concat_out);
        $display("Replic {2{a[3:0]}}: %h", replic_out);

        sel = 1; #1;
        $display("MUX  (sel=1): %h", mux_out);
        sel = 0;

        // ── 05: RELATIONAL results ─────────────────────────
        $display("--- Relational Operators ---");
        $display("a==b: %b  a>b: %b  a<b: %b", eq_flag, gt_flag, lt_flag);

        // ── 11: $random ────────────────────────────────────
        $display("--- Random Test Cases ---");
        for (i = 0; i < 4; i = i + 1) begin
            a = {$random} % 256;
            b = {$random} % 256;
            if (b == 0) b = 1;   // avoid div by zero
            #10;
            $display("a=%0d b=%0d | add=%0d sub=%0d gt=%b eq=%b",
                      a, b, add_out, sub_out, gt_flag, eq_flag);
        end

        // ── 11: $time ──────────────────────────────────────
        $display("Simulation ended at time %0t ns", $time);

        // ── 11: $finish ────────────────────────────────────
        $finish;
    end

endmodule

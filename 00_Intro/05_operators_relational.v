// File: 05_operators_relational.v
// Topic: Relational and Equality Operators — all return 1-bit result

module operators_relational;

    reg [7:0] a = 8'd25;
    reg [7:0] b = 8'd10;

    initial begin
        $display("a=%0d  b=%0d", a, b);

        // ── RELATIONAL ──────────────────────────────────────
        $display("a > b  = %b", a > b);    // 1  (25 > 10)
        $display("a < b  = %b", a < b);    // 0
        $display("a >= b = %b", a >= b);   // 1
        $display("a <= b = %b", a <= b);   // 0

        // ── EQUALITY ────────────────────────────────────────
        $display("a == b = %b", a == b);   // 0  (25 != 10)
        $display("a != b = %b", a != b);   // 1

        // ── CASE EQUALITY (=== and !==) ──────────────────────
        // == returns X if either operand has X or Z bits
        // === compares EXACTLY including X and Z (sim only)
        begin
            reg [3:0] x_val = 4'bx01x;
            reg [3:0] same  = 4'bx01x;

            $display("x_val == same  : %b", x_val == same);    // x (unknown!)
            $display("x_val === same : %b", x_val === same);   // 1 (exact match)
            $display("x_val !== same : %b", x_val !== same);   // 0
        end

        $finish;
    end
endmodule


module relational_in_hardware (
    input  [7:0] a,
    input  [7:0] b,
    output       eq,      // a == b
    output       neq,     // a != b
    output       gt,      // a > b
    output       lt,      // a < b
    output       gte,     // a >= b
    output       lte      // a <= b
);
    assign eq  = (a == b);
    assign neq = (a != b);
    assign gt  = (a >  b);
    assign lt  = (a <  b);
    assign gte = (a >= b);
    assign lte = (a <= b);
endmodule

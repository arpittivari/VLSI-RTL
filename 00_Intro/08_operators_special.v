// File: 08_operators_special.v
// Topic: Ternary, Concatenation, Replication

module operators_special (
    input        sel,
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] mux_out,     // ternary (2:1 MUX)
    output [7:0] concat_out,  // concatenation
    output [7:0] replic_out,  // replication
    output [8:0] wide_out     // bit select + concat
);

    // ── TERNARY OPERATOR  ? : ──────────────────────────────
    // condition ? value_if_true : value_if_false
    // This IS a 2:1 MUX!
    assign mux_out = sel ? a : b;    // if sel=1, output a; else output b

    // ── CONCATENATION  { , } ───────────────────────────────
    // Joins multiple signals/bits into one wider signal
    assign concat_out = {a, b};      // {4'b1100, 4'b1010} = 8'b11001010

    // ── REPLICATION  { N{ } } ──────────────────────────────
    // Repeats a value N times
    assign replic_out = {2{a}};      // {2{4'b1010}} = 8'b10101010

    // ── BIT SELECT ─────────────────────────────────────────
    // Pick specific bits from a signal
    // a[3]     = single bit (bit 3)
    // a[3:1]   = 3-bit slice (bits 3 down to 1)
    assign wide_out = {1'b0, a[3:1], b[3:0]};  // mix and match bits

endmodule


module special_demo;
    reg [3:0] x = 4'b1010;
    reg [3:0] y = 4'b0101;

    initial begin
        // Ternary
        $display("1 ? x : y = %b", 1 ? x : y);   // 1010 (x)
        $display("0 ? x : y = %b", 0 ? x : y);   // 0101 (y)

        // Concatenation
        $display("{x,y} = %b", {x, y});            // 10100101 (8-bit)
        $display("{1'b1, x} = %b", {1'b1, x});     // 11010 (5-bit)

        // Replication
        $display("{4{1'b1}} = %b", {4{1'b1}});     // 1111
        $display("{2{x}}   = %b", {2{x}});          // 10101010

        // Bit select
        $display("x[3]   = %b", x[3]);             // 1 (MSB of 1010)
        $display("x[1:0] = %b", x[1:0]);           // 10 (lower 2 bits)

        // Common use: sign extension (extend 4-bit signed to 8-bit)
        $display("sign extend: %b", {{4{x[3]}}, x});  // repeat MSB 4 times

        $finish;
    end
endmodule

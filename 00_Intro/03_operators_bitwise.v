// File: 03_operators_bitwise.v
// Topic: Bitwise Operators — work on each bit independently

module operators_bitwise (
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] and_out,
    output [3:0] or_out,
    output [3:0] xor_out,
    output [3:0] not_out,
    output [3:0] nand_out,
    output [3:0] nor_out,
    output [3:0] xnor_out
);

    // & — AND each bit position independently
    // 4'b1100 & 4'b1010 = 4'b1000
    assign and_out  = a & b;

    // | — OR each bit position
    // 4'b1100 | 4'b1010 = 4'b1110
    assign or_out   = a | b;

    // ^ — XOR each bit position (1 when bits differ)
    // 4'b1100 ^ 4'b1010 = 4'b0110
    assign xor_out  = a ^ b;

    // ~ — NOT every bit (flip all bits)
    // ~4'b1010 = 4'b0101
    assign not_out  = ~a;

    // ~(a & b) — NAND (invert of AND)
    // 4'b1000 inverted = 4'b0111
    assign nand_out = ~(a & b);

    // ~(a | b) — NOR (invert of OR)
    assign nor_out  = ~(a | b);

    // ~^ or ^~ — XNOR (1 when bits are equal)
    // 4'b1100 ~^ 4'b1010 = 4'b1001
    assign xnor_out = a ~^ b;    // same as ~(a ^ b)

endmodule

// ─── DIFFERENCE: BITWISE vs LOGICAL ──────────────────────
module bitwise_vs_logical;
    reg [3:0] x = 4'b1010;
    reg [3:0] y = 4'b0101;
    reg bit_result;
    reg [3:0] bw_result;

    initial begin
        bw_result  = x & y;    // BITWISE AND → 4'b0000  (bit by bit)
        bit_result = x && y;   // LOGICAL AND → 1        (are both non-zero?)

        $display("Bitwise AND: %b", bw_result);   // 0000
        $display("Logical AND: %b", bit_result);  // 1  (both x,y are non-zero)
        $finish;
    end
endmodule

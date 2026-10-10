// File: 07_operators_reduction.v
// Topic: Reduction Operators — collapse a multi-bit value into 1 bit

module operators_reduction (
    input  [7:0] a,
    output and_red,    // AND all bits together
    output or_red,     // OR all bits together
    output xor_red,    // XOR all bits (= parity bit)
    output nand_red,
    output nor_red,
    output xnor_red
);

    assign and_red  =  &a;     // 1 only if ALL bits are 1
    assign or_red   =  |a;     // 1 if ANY bit is 1
    assign xor_red  =  ^a;     // 1 if ODD number of 1s (parity)
    assign nand_red = ~&a;     // 0 only if ALL bits are 1
    assign nor_red  = ~|a;     // 1 only if ALL bits are 0
    assign xnor_red = ~^a;     // 1 if EVEN number of 1s

endmodule


module reduction_demo;

    initial begin
        // & AND reduction
        $display("&8'b11111111 = %b  (all 1s)", &8'b11111111);  // 1
        $display("&8'b11110111 = %b  (one 0)", &8'b11110111);   // 0

        // | OR reduction
        $display("|8'b00000001 = %b  (one 1)", |8'b00000001);   // 1
        $display("|8'b00000000 = %b  (all 0)", |8'b00000000);   // 0

        // ^ XOR reduction = PARITY
        $display("^8'b10110001 = %b  (4 ones = even parity)", ^8'b10110001); // 0
        $display("^8'b10110011 = %b  (5 ones = odd parity)",  ^8'b10110011); // 1

        // Real use case: zero detection
        $display("is zero? %b", ~|8'b00000000);  // 1 = yes it's zero
        $display("is zero? %b", ~|8'b00000001);  // 0 = not zero

        $finish;
    end
endmodule

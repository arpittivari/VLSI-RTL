// File: 06_operators_shift.v
// Topic: Shift Operators

module operators_shift (
    input  [7:0] a,
    input  [2:0] n,          // shift amount
    output [7:0] lshift,     // logical left shift
    output [7:0] rshift,     // logical right shift
    output [7:0] arshift     // arithmetic right shift
);

    assign lshift  = a << n;    // logical left shift  — fills 0s from right
    assign rshift  = a >> n;    // logical right shift — fills 0s from left
    assign arshift = $signed(a) >>> n;  // arithmetic right shift — fills sign bit

endmodule


module shift_demo;
    reg [7:0] pos = 8'b00001000;  // = 8
    reg signed [7:0] neg = 8'b11111000;  // = -8 in 2's complement

    initial begin
        $display("Original positive: %b (%0d)", pos, pos);
        $display("pos << 2 : %b (%0d)", pos << 2, pos << 2);  // 00100000 = 32
        $display("pos >> 2 : %b (%0d)", pos >> 2, pos >> 2);  // 00000010 = 2

        $display("Original negative: %b (%0d)", neg, $signed(neg));
        $display("neg >> 2  (logical)    : %b", neg >> 2);          // fills 00 from left
        $display("neg >>> 2 (arithmetic) : %b", $signed(neg) >>> 2);// fills 11 from left (preserves sign)

        // Shift left by N = multiply by 2^N
        // Shift right by N = divide by 2^N (faster than division!)
        $display("8 << 3 = %0d  (8 * 2^3 = 64)", 8'd8 << 3);
        $display("64 >> 3 = %0d  (64 / 2^3 = 8)", 8'd64 >> 3);

        $finish;
    end
endmodule

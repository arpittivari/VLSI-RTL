// File: 04_operators_arithmetic.v
// Topic: Arithmetic Operators

module operators_arithmetic (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] add_out,
    output [7:0] sub_out,
    output [7:0] mul_out,
    output [7:0] div_out,
    output [7:0] mod_out
);

    assign add_out = a + b;    // Addition
    assign sub_out = a - b;    // Subtraction
    assign mul_out = a * b;    // Multiplication (be careful: result can overflow!)
    assign div_out = a / b;    // Division (integer — truncates remainder)
    assign mod_out = a % b;    // Modulo (remainder only)

endmodule


module arithmetic_demo;
    reg [7:0] a = 8'd17;
    reg [7:0] b = 8'd5;

    initial begin
        $display("a = %0d, b = %0d", a, b);
        $display("a + b = %0d", a + b);   // 22
        $display("a - b = %0d", a - b);   // 12
        $display("a * b = %0d", a * b);   // 85
        $display("a / b = %0d", a / b);   // 3  (not 3.4 — integer division!)
        $display("a %% b = %0d", a % b);  // 2  (17 = 3*5 + 2)

        // Power operator
        $display("2**8  = %0d", 2**8);    // 256

        // Overflow example — 8-bit can hold max 255
        $display("200+100 = %0d (overflowed!)", 8'd200 + 8'd100);
        // 200+100=300, but 300 mod 256 = 44 (wraps around)

        $finish;
    end
endmodule

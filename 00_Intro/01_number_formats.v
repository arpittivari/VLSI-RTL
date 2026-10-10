// File: 01_number_formats.v
// Topic: How to write numbers in Verilog

module number_formats;

    // FORMAT: <size>'<base><value>

    // BINARY (b)
    wire [3:0] bin1 = 4'b1010;      // = 10 decimal
    wire [3:0] bin2 = 4'b0000;      // = 0
    wire [7:0] bin3 = 8'b11001010;  // = 202 decimal

    // DECIMAL (d)
    wire [3:0] dec1 = 4'd10;        // = 10
    wire [7:0] dec2 = 8'd255;       // = 255 (max for 8-bit)
    wire [7:0] dec3 = 8'd0;         // = 0

    // HEXADECIMAL (h)
    wire [3:0] hex1 = 4'hA;         // = 10  (A=10 in hex)
    wire [7:0] hex2 = 8'hFF;        // = 255 (FF = 11111111)
    wire [7:0] hex3 = 8'hCA;        // = 202

    // OCTAL (o)
    wire [5:0] oct1 = 6'o17;        // = 15 decimal
    wire [5:0] oct2 = 6'o77;        // = 63 decimal

    // SPECIAL VALUES in number literals
    wire [3:0] unknown  = 4'bxxxx;  // x = unknown (don't care in sim)
    wire [3:0] highz    = 4'bzzzz;  // z = high impedance (floating)
    wire [3:0] mixed    = 4'b10xz;  // mix of known, unknown, float

    // WITHOUT SIZE (unsized — defaults to 32-bit)
    wire [31:0] no_size1 = 'b1010;  // 32-bit binary
    wire [31:0] no_size2 = 'd10;    // 32-bit decimal
    wire [31:0] no_size3 = 'hFF;    // 32-bit hex
    wire [31:0] plain    = 10;      // plain decimal, also 32-bit

    // SIGNED NUMBERS
    wire signed [7:0] pos = 8'sd50;  // +50
    wire signed [7:0] neg = -8'sd50; // -50  (stored as 2's complement)

    // SAME VALUE — 4 DIFFERENT WAYS TO WRITE IT
    wire [3:0] same_a = 4'b1010;    // binary
    wire [3:0] same_b = 4'd10;      // decimal
    wire [3:0] same_c = 4'hA;       // hex
    wire [3:0] same_d = 4'o12;      // octal
    // all four = 1010 in binary = value 10

    // UNDERSCORE for readability (ignored by compiler)
    wire [15:0] readable = 16'b1010_0101_1100_0011;  // same as without _
    wire [7:0]  hex_read = 8'hDE_AD;                  // also valid

endmodule

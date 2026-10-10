// ============================================================
// Module      : decoder_2to4
// File        : decoder_2to4.v
// Description : 2-to-4 Decoder with active-high Enable signal.
// ============================================================

`timescale 1ns/1ps

module decoder_2to4 (
    input  wire [1:0] in,   // 2-bit Binary Input
    input  wire       en,   // Active-High Enable
    output reg  [3:0] out   // 4-bit One-Hot Output
);

    always @(*) begin
        if (!en) begin
            out = 4'b0000;
        end else begin
            case (in)
                2'b00   : out = 4'b0001;
                2'b01   : out = 4'b0010;
                2'b10   : out = 4'b0100;
                2'b11   : out = 4'b1000;
                default : out = 4'b0000;
            endcase
        end
    end

endmodule

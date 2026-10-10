// ============================================================
// File        : mux_4to1_tb.v
// Description : Self-checking testbench for mux_4to_1
// ============================================================

`timescale 1ns/1ps

module mux_4to1_tb;

    parameter BUS_WIDTH = 8;

    reg [BUS_WIDTH-1:0] A, B, C, D;
    reg [1:0]           sel;
    wire [BUS_WIDTH-1:0] out;

    integer errors = 0;
    integer i;
    reg [BUS_WIDTH-1:0] expected;

    // Instantiate corrected mux_4to_1 DUT
    mux_4to_1 #(.WIDTH(BUS_WIDTH)) dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .sel(sel),
        .out(out)
    );

    initial begin
        $dumpfile("mux_4to1_tb.vcd");
        $dumpvars(0, mux_4to1_tb);

        $display("=================================================");
        $display("          STARTING MUX 4:1 VERIFICATION          ");
        $display("=================================================");

        A = 8'h11; B = 8'h22; C = 8'h33; D = 8'h44;

        for (i = 0; i < 4; i = i + 1) begin
            sel = i[1:0];
            #10;

            case (sel)
                2'b00 : expected = A;
                2'b01 : expected = B;
                2'b10 : expected = C;
                2'b11 : expected = D;
            endcase

            $display("[Time %0t ns] sel=%b | Expected=%h | Output=%h", $time, sel, expected, out);

            if (out !== expected) begin
                $display("ERROR: Output mismatch! Expected %h, Got %h", expected, out);
                errors = errors + 1;
            end
        end

        $display("=================================================");
        if (errors == 0)
            $display("    MUX 4:1 VERIFICATION PASSED SUCCESSFULLY!    ");
        else
            $display("    MUX 4:1 VERIFICATION FAILED WITH %0d ERRORS  ", errors);
        $display("=================================================");
        $finish;
    end

endmodule

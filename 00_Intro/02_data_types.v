// File: 02_data_types.v
// Topic: All Verilog data types with real usage examples

// ─── NET TYPES ─────────────────────────────────────────────
// Nets represent physical wires — driven by assign or module output
// They update continuously whenever their source changes

module data_types_nets (
    input  a, b,
    output wire  w_out,    // explicit wire (default anyway)
    output tri   t_out,    // tri-state wire (same as wire, different intent)
    output wand  wa_out,   // wired-AND: if multiple drivers, AND them
    output wor   wo_out,   // wired-OR:  if multiple drivers, OR them
    inout  bidi           // bidirectional port (e.g., SDA in I2C)
);

    assign w_out  = a & b;
    assign t_out  = a | b;
    assign wa_out = a ^ b;
    assign wo_out = ~a;

    // supply nets (constant — no driver needed)
    supply1 vdd;           // always logic 1  (VDD)
    supply0 gnd;           // always logic 0  (GND/VSS)

    // trireg: holds last value when driver goes Z (capacitive storage)
    trireg cap_node;

endmodule


// ─── VARIABLE TYPES ────────────────────────────────────────
// Variables hold values until explicitly changed
// Used inside always and initial blocks

module data_types_variables;

    // reg — most common variable type
    // NOT always a flip-flop! Depends on context.
    reg        single_bit;          // 1-bit
    reg [7:0]  byte_val;            // 8-bit unsigned
    reg [31:0] word_val;            // 32-bit
    reg signed [7:0] signed_byte;  // 8-bit signed (2's complement)

    // integer — 32-bit signed, mainly for loops and counters
    integer i;
    integer count;

    // real — 64-bit floating point (simulation only, not synthesizable)
    real voltage;
    real pi = 3.14159;

    // time — 64-bit unsigned, stores simulation time
    time stamp;

    // realtime — real-number version of time
    realtime exact_time;

    // localparam — named constant inside module, cannot be changed from outside
    localparam MAX = 255;
    localparam ZERO = 8'd0;

    // parameter — named constant, CAN be overridden when instantiating module
    parameter WIDTH = 8;
    parameter DEPTH = 16;

    initial begin
        // using reg
        single_bit    = 1'b0;
        byte_val      = 8'hAB;
        signed_byte   = -50;

        // using integer in a loop
        for (i = 0; i < 8; i = i + 1) begin
            count = i * 2;
        end

        // using real
        voltage = 1.8;

        // capturing simulation time
        stamp      = $time;
        exact_time = $realtime;

        $display("byte = %h, count = %d, voltage = %f", byte_val, count, voltage);
        $finish;
    end

endmodule


// ─── MEMORY / ARRAY ────────────────────────────────────────
module data_types_memory;

    // 2D array — reg array (memory)
    reg [7:0] mem [0:15];    // 16 locations, each 8-bit wide
                              // mem[0] to mem[15]

    integer i;

    initial begin
        // load memory from hex file
        $readmemh("data.hex", mem);

        // or manually write
        for (i = 0; i < 16; i = i + 1)
            mem[i] = i;      // fill with 0,1,2,...15

        $display("mem[0]=%h  mem[15]=%h", mem[0], mem[15]);
        $finish;
    end

endmodule

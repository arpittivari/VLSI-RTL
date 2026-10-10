// File: 09_gate_primitives.v
// Topic: All built-in Verilog gate primitives (Structural modeling)
// Syntax: gate_type  instance_name (OUTPUT, input1, input2, ...);
//         OUTPUT is ALWAYS FIRST

module gate_primitives (
    input  a, b, ctrl,
    output and_o, or_o, xor_o, not_o,
           nand_o, nor_o, xnor_o,
           buf_o,
           bufif1_o, bufif0_o,
           notif1_o, notif0_o
);

    // ── BASIC GATES ─────────────────────────────────────────
    and   g1  (and_o,  a, b);     // AND
    or    g2  (or_o,   a, b);     // OR
    xor   g3  (xor_o,  a, b);    // XOR
    not   g4  (not_o,  a);        // NOT — only 1 input!
    nand  g5  (nand_o, a, b);    // NAND
    nor   g6  (nor_o,  a, b);    // NOR
    xnor  g7  (xnor_o, a, b);   // XNOR
    buf   g8  (buf_o,  a);        // Buffer — output = input, no inversion

    // ── TRI-STATE GATES ─────────────────────────────────────
    // 3rd terminal is the enable/control
    bufif1 g9  (bufif1_o, a, ctrl);  // output=a when ctrl=1, else Z (floating)
    bufif0 g10 (bufif0_o, a, ctrl);  // output=a when ctrl=0, else Z

    notif1 g11 (notif1_o, a, ctrl);  // output=~a when ctrl=1, else Z
    notif0 g12 (notif0_o, a, ctrl);  // output=~a when ctrl=0, else Z

endmodule


// Multi-input gates — primitives can take any number of inputs
module multi_input_gates (
    input  a, b, c, d,
    output and4_out,
    output or4_out
);

    and  g_and4 (and4_out, a, b, c, d);   // 4-input AND
    or   g_or4  (or4_out,  a, b, c, d);   // 4-input OR

endmodule


// Intermediate wire connection example
// Building a 2-input NAND from AND + NOT primitives
module nand_from_and_not (
    input  a, b,
    output nand_out
);

    wire and_result;             // intermediate wire connecting two gates

    and  g1 (and_result, a, b); // AND first
    not  g2 (nand_out, and_result); // then invert = NAND!

endmodule

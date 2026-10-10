// ============================================================
// File        : basic_logic_all_models.v
// Description : All 3 Verilog modeling styles demonstrated
//               using the same 7 basic logic gates.
//               Multiple modules CAN exist in one .v file.
// ============================================================
//
// THE 3 MODELING STYLES AT A GLANCE:
// ┌─────────────────┬──────────────────┬────────────────────┐
// │   DATAFLOW      │   STRUCTURAL     │   BEHAVIORAL       │
// ├─────────────────┼──────────────────┼────────────────────┤
// │ assign x = a&b  │ and g1(out,a,b)  │ always @(*)        │
// │ Describes how   │ Describes how    │ Describes what     │
// │ data flows      │ parts connect    │ circuit does       │
// │ (expressions)   │ (schematic)      │ (algorithm)        │
// └─────────────────┴──────────────────┴────────────────────┘
// ALL THREE produce IDENTICAL hardware after synthesis!
// ============================================================


// ============================================================
//  MODULE 1 - DATAFLOW MODELING  (what YOU wrote originally)
// ============================================================
// Key construct : assign (continuous assignment)
// Signal type   : wire (implicit, no need to declare)
// Best for      : Simple combinational expressions
// ============================================================

module basic_logic_dataflow(
    input  a, b,
    output and_out, or_out, xor_out, not_out,
           nand_out, nor_out, xnor_out
    // All outputs are implicitly 'wire' — no declaration needed
    // because 'assign' always drives wire types.
);

assign and_out  =  a & b;      // AND  : HIGH only if both HIGH
assign or_out   =  a | b;      // OR   : HIGH if at least one HIGH
assign xor_out  =  a ^ b;      // XOR  : HIGH only if inputs DIFFER
assign not_out  = ~a;           // NOT  : Inverts 'a' (single input)
assign nand_out = ~(a & b);    // NAND : Inverse of AND (universal gate)
assign nor_out  = ~(a | b);    // NOR  : Inverse of OR  (universal gate)
assign xnor_out = ~(a ^ b);    // XNOR : HIGH only if inputs are EQUAL
                                //        same as: a ~^ b (native operator)
endmodule


// ============================================================
//  MODULE 2 - STRUCTURAL MODELING
// ============================================================
// Key construct : Gate primitives (and, or, xor, not, nand...)
// Signal type   : wire (outputs of primitives are wires)
// Best for      : Gate-level netlists, post-synthesis description
//
// SYNTAX RULE: gate_type  instance_name (OUTPUT_FIRST, in1, in2);
//              Output is ALWAYS the first port in primitives!
// ============================================================

module basic_logic_structural(
    input  a, b,
    output and_out, or_out, xor_out, not_out,
           nand_out, nor_out, xnor_out
);

//  Primitive    Instance   (Output   , Input1, Input2)
    and          g_and      (and_out  , a     , b     );
    or           g_or       (or_out   , a     , b     );
    xor          g_xor      (xor_out  , a     , b     );
    not          g_not      (not_out  , a             ); // NOT: only 1 input
    nand         g_nand     (nand_out , a     , b     );
    nor          g_nor      (nor_out  , a     , b     );
    xnor         g_xnor     (xnor_out , a     , b     );

// NOTES:
// - Instance names (g_and, g_or...) are MANDATORY and must be UNIQUE.
//   Think of them as labels on components in a physical schematic.
// - For complex circuits, connect gates via intermediate wires:
//     wire mid;
//     and g1 (mid,     a, b);   // AND feeds into...
//     not g2 (nand_out, mid);   // ...NOT gate = NAND!
// - Primitives support any number of inputs:
//     and g_wide (out, a, b, c, d);  // 4-input AND is valid!

endmodule


// ============================================================
//  MODULE 3 - BEHAVIORAL MODELING
// ============================================================
// Key construct : always @(*) block (procedural)
// Signal type   : reg (REQUIRED for signals assigned in always)
// Best for      : Complex logic, if-else, case statements,
//                 sequential circuits (with posedge clk)
//
// IMPORTANT: 'reg' does NOT mean flip-flop here!
//   - always @(*)           -> NO clock -> combinational logic
//   - always @(posedge clk) -> WITH clock -> flip-flops (sequential)
// ============================================================

module basic_logic_behavioral(
    input  a, b,
    output reg and_out, or_out, xor_out, not_out,
               nand_out, nor_out, xnor_out
    // 'reg' is required because outputs are driven inside always block.
);

// always @(*) — sensitivity list shorthand for ALL inputs.
// Equivalent older style: always @(a or b)
// SystemVerilog modern style: always_comb (preferred when available)
always @(*) begin

    // Blocking assignment '=' used for combinational logic.
    // Executes top to bottom, line by line (like C code).
    // NEVER use '<=' (non-blocking) in combinational always blocks!
    // '<=' is reserved for clocked/sequential always blocks.

    and_out  =  a & b;
    or_out   =  a | b;
    xor_out  =  a ^ b;
    not_out  = ~a;
    nand_out = ~(a & b);
    nor_out  = ~(a | b);
    xnor_out = ~(a ^ b);

end

// DANGER - LATCH INFERENCE (common beginner bug):
// If your sensitivity list is incomplete (e.g., always @(a) missing b),
// the simulator holds the OLD value of b when only a changes.
// This creates an UNINTENDED LATCH - a memory element you didn't want!
// always @(*) prevents this by auto-including ALL read signals.

endmodule

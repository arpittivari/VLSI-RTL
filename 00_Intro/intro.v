// ============================================================
// File        : intro.v
// Description : Essential 50 VLSI & RTL Keywords Reference
// ============================================================

/*
===============================================================================
               50 ESSENTIAL VLSI & RTL KEYWORDS & DICTIONARY
===============================================================================

--- CATEGORY 1: RTL DESIGN & HIERARCHY TERMS ---
 1. Instantiation  : Inserting a sub-module inside a parent module.
 2. Stimulus       : Test signals (inputs) applied to a design to test it.
 3. DUT / UUT      : Device/Unit Under Test (the module being verified).
 4. RTL            : Register Transfer Level design abstraction.
 5. Module         : Fundamental Verilog hardware container block.
 6. Port           : External input/output pin of a module.
 7. Port Mapping   : Connecting testbench wires to module pins (.port(signal)).
 8. Combinational  : Logic where output depends ONLY on current inputs.
 9. Sequential     : Logic that stores state over time using a clock.
10. Parameter      : Constant used to create reusable code (e.g. bus WIDTH).

--- CATEGORY 2: SIMULATION & TESTBENCH TERMS ---
11. Driver         : Testbench code that drives input signals.
12. Monitor        : Testbench code that observes and displays outputs.
13. Self-Checking  : Testbench that automatically checks outputs vs expected.
14. Assertion      : Statement checking if a condition is strictly TRUE.
15. Waveform       : Graphical representation of signals over time.
16. VCD            : Value Change Dump file (.vcd) for viewing waveforms.
17. Timescale      : Directive (`timescale 1ns/1ps) for delay units.
18. Delta Cycle    : Zero-delay simulation step for event evaluation.
19. Race Condition : Simulation bug where output depends on execution order.
20. Coverage       : Percentage of code or features tested in simulation.

--- CATEGORY 3: TIMING, CLOCKING & SEQUENTIAL TERMS ---
21. Clock (clk)    : Periodic square wave synchronizing hardware state.
22. Clock Edge     : Rising (posedge) or Falling (negedge) clock transition.
23. Sync Reset     : Reset that updates state ONLY on a clock edge.
24. Async Reset    : Reset that updates state IMMEDIATELY on reset assertion.
25. Setup Time     : Minimum time data must be stable BEFORE clock edge.
26. Hold Time      : Minimum time data must remain stable AFTER clock edge.
27. Slack          : Difference between required and actual arrival time.
28. Propagation    : Time delay for logic gate output to update.
29. Metastability  : Unstable signal state caused by setup/hold violation.
30. CDC            : Clock Domain Crossing between independent clocks.

--- CATEGORY 4: SYNTHESIS & ASIC/FPGA TERMS ---
31. Synthesis      : Translating Verilog RTL into gate-level standard cells.
32. Netlist        : Text file describing gates and interconnecting wires.
33. GLS            : Gate-Level Simulation on post-synthesis netlist.
34. Latch          : Unintended memory inferred from incomplete if/case.
35. Fan-In         : Number of inputs connected to a logic gate.
36. Fan-Out        : Number of inputs driven by a single gate output.
37. Critical Path  : Longest delay path between registers (sets max freq).
38. STA            : Static Timing Analysis without needing simulation.
39. FPGA           : Field Programmable Gate Array reconfigurable chip.
40. LUT            : Look-Up Table used in FPGAs to implement logic functions.

--- CATEGORY 5: ADVANCED ARCHITECTURE & VERIFICATION ---
41. Pipelining     : Breaking logic into multiple clock stages for speed.
42. FSM            : Finite State Machine (Moore vs Mealy state models).
43. Handshake      : Ready/Valid signaling protocol between modules.
44. FIFO           : First-In-First-Out memory buffer queue.
45. High-Z (1'bz)  : Disconnected/floating tri-state buffer state.
46. Unknown (1'bx) : Uninitialized or conflicting signal state.
47. Formal Verif   : Mathematical proof checking RTL against spec.
48. UVM            : Universal Verification Methodology framework.
49. DFT            : Design for Testability (scan chains for silicon).
50. BIST           : Built-In Self-Test hardware embedded on chip.
===============================================================================
*/

`timescale 1ns/1ps

module intro (
    input  wire a,
    input  wire b,
    output wire out
);
    assign out = a & b;
endmodule

# Digital VLSI & RTL Design - Master Notes

*Comprehensive notes for M.Tech NIT Jaipur students targeting Top MNCs (Intel, AMD, NVIDIA, Qualcomm, TI).*

---

## 1. The ASIC/FPGA Design Flow
In a top MNC, you are a tiny cog in a massive machine. You must understand the entire flow, even if your job is just RTL design.

1. **Architecture/Microarchitecture Specification:** System architects define what the chip should do.
2. **RTL Design (Your Role):** Writing Verilog/SystemVerilog to model the hardware.
3. **Functional Verification (Your Role / Verification Engg):** Writing SystemVerilog/UVM testbenches to ensure the RTL is logically correct. No timing is considered here.
4. **Logic Synthesis (Yosys / Design Compiler):** Converting RTL code into a netlist of actual physical logic gates (AND, OR, Flip-Flops) from a standard cell library.
5. **Static Timing Analysis (STA / OpenSTA):** Ensuring all signals arrive on time (Setup time and Hold time checks).
6. **Place & Route (Backend):** Physically placing the gates on the silicon floorplan and routing the copper wires between them.
7. **Sign-off:** Final physical verification before sending it to the fab (TSMC, Samsung, Intel).

---

## 2. Combinational vs. Sequential Circuits

### Combinational Circuits
- **Definition:** Outputs depend **ONLY** on the current inputs.
- **Memory:** Zero memory. No state. No clock.
- **Examples:** Logic Gates, Multiplexers, Decoders, Encoders, Adders, ALUs.
- **Verilog Rule:** Use `assign` statements OR `always @(*)` blocks with blocking assignments (`=`).

### Sequential Circuits
- **Definition:** Outputs depend on current inputs **AND** past inputs (state).
- **Memory:** Has memory elements (Flip-Flops / Latches). Driven by a Clock (`clk`).
- **Examples:** Counters, Shift Registers, State Machines (FSMs), FIFOs.
- **Verilog Rule:** Use `always @(posedge clk)` blocks with non-blocking assignments (`<=`).

---

## 3. Top MNC Interview Favorites

When you interview at top product companies, they almost always grill you on these four topics:

### A. Setup and Hold Time
- **Setup Time ($T_{setup}$):** The minimum amount of time the data must be stable **BEFORE** the clock edge arrives. If data changes in this window, the flip-flop goes metastable.
- **Hold Time ($T_{hold}$):** The minimum amount of time the data must be stable **AFTER** the clock edge. 

### B. Clock Domain Crossing (CDC)
- **Problem:** When data travels from one clock speed (e.g., 100MHz) to a totally asynchronous clock (e.g., 33MHz), the flip-flops can capture changing data (metastability).
- **Solution 1:** 2-Flop Synchronizers (for single bits).
- **Solution 2:** Asynchronous FIFOs (for large data buses).

### C. Finite State Machines (FSMs)
- **Mealy Machine:** Output depends on current state **and** inputs. (Faster, but can create combinational loops).
- **Moore Machine:** Output depends **only** on current state. (Safer, preferred in industry).
- Always code FSMs using the 3-always-block method (Next State Logic, State Register, Output Logic).

### D. Blocking vs. Non-Blocking Assignments
- **`=` (Blocking):** Executes sequentially. Used for combinational logic.
- **`<=` (Non-Blocking):** Executes concurrently. Used for sequential logic (Flip-Flops).
- **Interview Trap:** Never mix `=` and `<=` in the same `always` block!

---

## 4. How to practice for interviews
1. **Draw it first:** Never write Verilog without drawing the logic gates or flip-flops on paper first.
2. **Think about hardware, not software:** Verilog is not C. `if-else` statements create Multiplexers, they do not create branches.
3. **Corner Cases:** When writing testbenches, always test what happens at reset, at maximum value, and when inputs change at the exact same time.

# 🎓 Digital VLSI & RTL Design - Master Notes

> [!NOTE]
> *Comprehensive notes for M.Tech NIT Jaipur students targeting Top MNCs (Intel, AMD, NVIDIA, Qualcomm, TI).*

---

## 🏭 1. The ASIC/FPGA Design Flow
In a top MNC, you are a tiny cog in a massive machine. You must understand the entire flow, even if your job is just RTL design.

1. **Architecture/Microarchitecture Specification:** System architects define what the chip should do.
2. **RTL Design (Your Role):** Writing Verilog/SystemVerilog to model the hardware.
3. **Functional Verification (Your Role / Verification Engg):** Writing SystemVerilog/UVM testbenches to ensure the RTL is logically correct. No timing is considered here.
4. **Logic Synthesis (Yosys / Design Compiler):** Converting RTL code into a netlist of actual physical logic gates (AND, OR, Flip-Flops) from a standard cell library.
5. **Static Timing Analysis (STA / OpenSTA):** Ensuring all signals arrive on time (Setup time and Hold time checks).
6. **Place & Route (Backend):** Physically placing the gates on the silicon floorplan and routing the copper wires between them.
7. **Sign-off:** Final physical verification before sending it to the fab (TSMC, Samsung, Intel).

---

## 🔀 2. Combinational vs. Sequential Circuits

| Feature | Combinational Circuits | Sequential Circuits |
| :--- | :--- | :--- |
| **Definition** | Outputs depend **ONLY** on current inputs. | Outputs depend on current **AND** past inputs. |
| **Memory** | Zero memory. No state. No clock. | Has memory (Flip-Flops/Latches). Driven by a Clock (`clk`). |
| **Examples** | Logic Gates, MUX, Decoders, Encoders, Adders, ALUs. | Counters, Shift Registers, State Machines (FSMs), FIFOs. |
| **Verilog Rule** | Use `assign` or `always @(*)` with blocking (`=`). | Use `always @(posedge clk)` with non-blocking (`<=`). |

---

## ⭐ 3. Top MNC Interview Favorites

When you interview at top product companies, they almost always grill you on these four topics:

### A. Setup and Hold Time
- **Setup Time ($T_{setup}$):** The minimum time data must be stable **BEFORE** the clock edge. If data changes here, the flip-flop goes metastable.
- **Hold Time ($T_{hold}$):** The minimum time data must be stable **AFTER** the clock edge. 

### B. Clock Domain Crossing (CDC)
- **Problem:** When data travels from one clock speed (e.g., 100MHz) to a totally asynchronous clock (e.g., 33MHz), the receiving flip-flops can capture changing data (metastability).
- **Solution 1:** 2-Flop Synchronizers (for single bit control signals).
- **Solution 2:** Asynchronous FIFOs (for large data buses).

### C. Finite State Machines (FSMs)
- **Mealy Machine:** Output depends on current state **and** inputs. (Faster, but can create combinational loops).
- **Moore Machine:** Output depends **only** on current state. (Safer, preferred in industry).

> [!TIP]
> Always code FSMs using the industry-standard 3-always-block method:
> 1. Next State Logic (Combinational)
> 2. State Register (Sequential)
> 3. Output Logic (Combinational)

### D. Blocking vs. Non-Blocking Assignments
- **`=` (Blocking):** Executes sequentially. Used for combinational logic.
- **`<=` (Non-Blocking):** Executes concurrently. Used for sequential logic (Flip-Flops).

> [!CAUTION]
> **Interview Trap:** Never mix `=` and `<=` in the same `always` block!

---

## 💡 4. How to Practice for Interviews

1. **Draw it first:** Never write Verilog without drawing the logic gates or flip-flops on paper first.
2. **Think Hardware, Not Software:** Verilog is not C. `if-else` statements create Multiplexers, they do not create code branches.
3. **Corner Cases:** When writing testbenches, always test what happens at reset, at maximum values, and when inputs change at the exact same time.

# ============================================================
# File        : synth.tcl
# Project     : 8-bit ALU ASIC Flow
# Description : Synthesis script in TCL for Yosys
# Run with    : yosys -c scripts/tcl/synth.tcl
# ============================================================

puts "\n============================================================"
puts "       SYNTHESIS FLOW: RTL -> GATE-LEVEL NETLIST            "
puts "============================================================\n"

# 1. Read Verilog RTL
puts "\[SYNTH STEP 1\] Reading Verilog RTL..."
yosys read_verilog -I rtl rtl/alu.v

# 2. Elaborate Design Hierarchy
puts "\n\[SYNTH STEP 2\] Elaborating top module 'alu'..."
yosys hierarchy -check -top alu

# 3. High-level synthesis optimizations
puts "\n\[SYNTH STEP 3\] High-level synthesis (proc, opt, memory)..."
yosys proc
yosys opt
yosys fsm
yosys opt
yosys memory
yosys opt

# 4. Tech mapping to basic logic gates
puts "\n\[SYNTH STEP 4\] Mapping to logic gates..."
yosys techmap
yosys opt

# 5. Clean up unused nets & check design
puts "\n\[SYNTH STEP 5\] Checking design..."
yosys check

# 6. Report Area Statistics
puts "\n\[SYNTH STEP 6\] Synthesis Statistics Report:"
yosys tee -o synthesis/reports/area_report.txt stat

# 7. Write out synthesized gate-level netlist
puts "\n\[SYNTH STEP 7\] Writing gate-level netlist -> synthesis/alu_netlist.v"
yosys write_verilog -noattr synthesis/alu_netlist.v

puts "\n============================================================"
puts "       SYNTHESIS COMPLETED SUCCESSFULLY! ✅                 "
puts "============================================================\n"

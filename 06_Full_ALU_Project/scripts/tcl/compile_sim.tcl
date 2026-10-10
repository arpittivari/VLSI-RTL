# ============================================================
# File        : compile_sim.tcl
# Project     : 8-bit ALU Automation
# Description : TCL script to compile and run all verification suites
# Run with    : tclsh scripts/tcl/compile_sim.tcl
# ============================================================

puts "============================================================"
puts "       TCL AUTOMATION ENGINE - ALU VERIFICATION             "
puts "============================================================"

# Define project directories
set ROOT_DIR   "."
set RTL_DIR    "$ROOT_DIR/rtl"
set TB_DIR     "$ROOT_DIR/verification/tb"
set SV_DIR     "$ROOT_DIR/verification/sv_tb"
set ASSERT_DIR "$ROOT_DIR/verification/assertions"
set SIM_DIR    "$ROOT_DIR/sim"

# Ensure output directory exists
file mkdir $SIM_DIR

# Define test suites to execute: {Name OutputVVP SourceFiles}
set test_suites [list \
    [list "Basic Verilog TB"  "$SIM_DIR/alu_sim.vvp"    [list "$RTL_DIR/alu.v" "$TB_DIR/alu_tb.v"]] \
    [list "SV OOP Testbench"  "$SIM_DIR/alu_sv_sim.vvp" [list "$RTL_DIR/alu.v" "$SV_DIR/alu_tb_sv.sv"]] \
    [list "SVA Assertions"    "$SIM_DIR/alu_assert.vvp" [list "$RTL_DIR/alu.v" "$ASSERT_DIR/alu_assertions.sv"]] \
]

set total_passed 0
set total_failed 0

# Loop through each suite and execute
foreach suite $test_suites {
    set name    [lindex $suite 0]
    set out_vvp [lindex $suite 1]
    set sources [lindex $suite 2]

    puts "\n\[TCL\] Compiling: $name..."
    set cmd [concat [list exec iverilog -g2012 -I $RTL_DIR -o $out_vvp] $sources]
    
    if {[catch {eval $cmd} compile_err]} {
        puts "\[TCL ERROR\] Compilation failed for $name:"
        puts $compile_err
        incr total_failed
        continue
    }

    puts "\[TCL\] Running Simulation: $name..."
    if {[catch {exec vvp $out_vvp} sim_out]} {
        puts "\[TCL ERROR\] Simulation failed for $name:"
        puts $sim_out
        incr total_failed
    } else {
        # Check simulation output for errors
        if {[string match "*FAIL*" $sim_out] || [string match "*ERROR*" $sim_out]} {
            puts "\[TCL STATUS\] $name completed with ERRORS."
            incr total_failed
        } else {
            puts "\[TCL STATUS\] $name PASSED cleanly! ✅"
            incr total_passed
        }
    }
}

puts "\n============================================================"
puts " TCL REGRESSION SUMMARY: $total_passed PASSED | $total_failed FAILED"
puts "============================================================"

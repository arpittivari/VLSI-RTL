# -----------------------------------------------------------------------------
# File        : run_sim.do
# Description : ModelSim execution script (Tcl/Do file)
# -----------------------------------------------------------------------------

# 1. Create a logical working library named 'work'
vlib work
vmap work work

# 2. Compile the Verilog source files (RTL first, then Testbench)
vlog ../rtl/basic_logic_unit.v
vlog ../tb/tb_basic_logic_unit.v

# 3. Load the testbench module for simulation
# -voptargs=+acc ensures optimization doesn't hide signals so we can view them in the wave
vsim -voptargs=+acc work.tb_basic_logic_unit

# 4. Add all signals in the testbench to the waveform viewer
add wave -position insertpoint sim:/tb_basic_logic_unit/*

# 5. Run the simulation for a specific amount of time or until $finish
run -all

# 6. Zoom the waveform window to fit all waves
wave zoom full

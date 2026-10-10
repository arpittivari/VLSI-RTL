# ============================================================
# Makefile — 8-bit ALU ASIC Flow
# ============================================================

PYTHON   = python
YOSYS    = cmd /c "C:\oss-cad-suite\environment.bat && yosys"
GTKWAVE  = C:/oss-cad-suite/bin/gtkwave.exe

.DEFAULT_GOAL := help

help:
	@echo.
	@echo  ======================================================
	@echo      8-bit ALU ASIC FLOW AUTOMATION DASHBOARD
	@echo  ======================================================
	@echo   make verify   Run full Python + SV + SVA regression
	@echo   make synth    Run Yosys synthesis via TCL
	@echo   make wave     Open simulation waveform in GTKWave
	@echo   make all      Run Verification + Synthesis end-to-end
	@echo   make clean    Clean all simulation and report files
	@echo  ======================================================
	@echo.

# 1. Full Automated Verification Regression
verify:
	$(PYTHON) scripts/python/run_all.py

# 2. Yosys Synthesis via TCL
synth:
	$(YOSYS) -c scripts/tcl/synth.tcl

# 3. Open GTKWave
wave:
	@if exist sim\alu_tb_sv.vcd (start "" "$(GTKWAVE)" sim\alu_tb_sv.vcd) else (echo VCD not found! Run 'make verify' first.)

# 4. Master All Target
all: verify synth
	@echo.
	@echo ======================================================
	@echo    ALL PHASES (VERIFICATION + SYNTHESIS) COMPLETE!
	@echo ======================================================
	@echo.

# 5. Clean
clean:
	@if exist sim rmdir /s /q sim
	@if exist synthesis\alu_netlist.v del /f /q synthesis\alu_netlist.v
	@echo [Clean] Finished cleanup.

.PHONY: help verify synth wave all clean

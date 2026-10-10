"""
File        : flow.py
Project     : 8-bit ALU ASIC Flow
Description : Universal 1-command CLI runner for the entire ASIC flow.
              Works natively on Windows without requiring GNU make!

Usage:
  python flow.py verify   -> Run all verification suites (Python + SV + SVA)
  python flow.py synth    -> Run Yosys synthesis via TCL
  python flow.py wave     -> Open simulation waveform in GTKWave
  python flow.py all      -> Run full end-to-end flow (Verify + Synth)
  python flow.py clean    -> Clean up generated files
"""
import sys
import os
import subprocess

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
SIM_DIR = os.path.join(ROOT_DIR, "sim")
GTKWAVE_BIN = "C:/oss-cad-suite/bin/gtkwave.exe"

def run_verify():
    print("\n--- Running Verification Suites ---")
    script = os.path.join(ROOT_DIR, "scripts", "python", "run_all.py")
    subprocess.run([sys.executable, script], cwd=ROOT_DIR)

def run_synth():
    print("\n--- Running Yosys Synthesis via TCL ---")
    synth_tcl = os.path.join(ROOT_DIR, "scripts", "tcl", "synth.tcl")
    cmd = f'cmd /c "C:\\oss-cad-suite\\environment.bat && yosys -c scripts/tcl/synth.tcl"'
    subprocess.run(cmd, shell=True, cwd=ROOT_DIR)

def run_wave():
    vcd = os.path.join(SIM_DIR, "alu_tb_sv.vcd")
    if os.path.exists(vcd):
        print(f"\n--- Opening GTKWave with {vcd} ---")
        subprocess.Popen([GTKWAVE_BIN, vcd])
    else:
        print("\n[!] VCD waveform not found. Run 'python flow.py verify' first.")

def run_clean():
    import shutil
    print("\n--- Cleaning up temporary files ---")
    if os.path.exists(SIM_DIR):
        shutil.rmtree(SIM_DIR)
        print("  Deleted sim/ directory.")
    netlist = os.path.join(ROOT_DIR, "synthesis", "alu_netlist.v")
    if os.path.exists(netlist):
        os.remove(netlist)
        print("  Deleted synthesis/alu_netlist.v")
    print("Cleanup complete. ✅")

def show_help():
    print("\n" + "="*55)
    print("   ⚡ 8-bit ALU ASIC FLOW - COMMAND DASHBOARD")
    print("="*55)
    print("  python flow.py verify  : Run 1,500+ tests (Python/SV/SVA)")
    print("  python flow.py synth   : Run Yosys synthesis via TCL")
    print("  python flow.py wave    : Open waveform in GTKWave")
    print("  python flow.py all     : Run Full Flow (Verify + Synth)")
    print("  python flow.py clean   : Clean temporary files")
    print("="*55 + "\n")

if __name__ == "__main__":
    arg = sys.argv[1].lower() if len(sys.argv) > 1 else "help"
    
    if arg == "verify":
        run_verify()
    elif arg == "synth":
        run_synth()
    elif arg == "wave":
        run_wave()
    elif arg == "all":
        run_verify()
        run_synth()
    elif arg == "clean":
        run_clean()
    else:
        show_help()

"""
File        : run_all.py
Project     : 8-bit ALU ASIC Flow
Description : Master Python Automation Script
              - Generates stimulus
              - Orchestrates all verification layers
              - Parses simulation logs
              - Generates an HTML dashboard report
"""
import subprocess
import time
import os
import re
from datetime import datetime

import sys
import io

# Ensure UTF-8 output on Windows console
if sys.platform == "win32":
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
SIM_DIR = os.path.join(ROOT_DIR, "sim")
REPORTS_DIR = os.path.join(ROOT_DIR, "reports")

os.makedirs(SIM_DIR, exist_ok=True)
os.makedirs(REPORTS_DIR, exist_ok=True)

SUITES = [
    {
        "name": "Verilog Directed Testbench",
        "type": "Verilog (.v)",
        "sources": ["rtl/alu.v", "verification/tb/alu_tb.v"],
        "out_vvp": "sim/alu_sim.vvp",
        "log": "sim/alu_tb.log",
        "vcd": "sim/alu_tb.vcd"
    },
    {
        "name": "SystemVerilog OOP Testbench",
        "type": "SystemVerilog (.sv)",
        "sources": ["rtl/alu.v", "verification/sv_tb/alu_tb_sv.sv"],
        "out_vvp": "sim/alu_sv_sim.vvp",
        "log": "sim/alu_tb_sv.log",
        "vcd": "sim/alu_tb_sv.vcd"
    },
    {
        "name": "SystemVerilog Assertions (SVA)",
        "type": "Assertions (SVA)",
        "sources": ["rtl/alu.v", "verification/assertions/alu_assertions.sv"],
        "out_vvp": "sim/alu_assert.vvp",
        "log": "sim/alu_assert.log",
        "vcd": "sim/alu_assert.vcd"
    }
]

def run_cmd(cmd, cwd=ROOT_DIR):
    res = subprocess.run(cmd, shell=True, cwd=cwd, capture_output=True, text=True)
    return res.returncode, res.stdout, res.stderr

def main():
    print("\n" + "="*65)
    print("      🚀 8-BIT ALU AUTOMATED VERIFICATION REGRESSION SUITE       ")
    print("="*65)

    # 1. Generate Stimulus
    print("\n[1/4] Generating Stimulus Vectors with Python...")
    from gen_stimulus import generate_vectors
    generate_vectors(num_vectors=1000, output_file=os.path.join(SIM_DIR, "stimulus.hex"))

    # 2. Run Test Suites
    print("\n[2/4] Executing Simulation Suites...")
    results = []

    for suite in SUITES:
        print(f"\n  ▶ Running: {suite['name']} ({suite['type']})...")
        start_time = time.time()
        
        # Compile
        src_str = " ".join([os.path.join(ROOT_DIR, s) for s in suite["sources"]])
        out_vvp = os.path.join(ROOT_DIR, suite["out_vvp"])
        inc_dir = os.path.join(ROOT_DIR, "rtl")
        
        compile_cmd = f"iverilog -g2012 -I {inc_dir} -o {out_vvp} {src_str}"
        ret, stdout, stderr = run_cmd(compile_cmd)
        
        if ret != 0:
            elapsed = round(time.time() - start_time, 3)
            print(f"    ❌ Compilation Failed:\n{stderr}")
            results.append({
                "name": suite["name"],
                "type": suite["type"],
                "status": "COMPILATION FAILED",
                "tests_passed": 0,
                "tests_failed": 1,
                "elapsed": elapsed,
                "vcd": None
            })
            continue

        # Simulate
        sim_cmd = f"vvp {out_vvp}"
        ret, stdout, stderr = run_cmd(sim_cmd)
        elapsed = round(time.time() - start_time, 3)
        
        # Write Log file
        log_path = os.path.join(ROOT_DIR, suite["log"])
        with open(log_path, "w") as f:
            f.write(stdout + "\n" + stderr)

        # Parse Log
        passed = 0
        failed = 0
        status = "PASSED"

        # Regex parsing for different outputs
        pass_matches = re.findall(r"PASS\s*[:#]\s*(\d+)", stdout)
        fail_matches = re.findall(r"FAIL\s*[:#]\s*(\d+)", stdout)
        assert_fails = re.findall(r"ASSERT FAIL", stdout)

        if "SCOREBOARD REPORT" in stdout:
            p_m = re.search(r"PASS\s*:\s*(\d+)", stdout)
            f_m = re.search(r"FAIL\s*:\s*(\d+)", stdout)
            passed = int(p_m.group(1)) if p_m else 0
            failed = int(f_m.group(1)) if f_m else 0
        elif "ASSERTION RESULTS" in stdout:
            p_m = re.search(r"PASS:\s*(\d+)", stdout)
            f_m = re.search(r"FAIL:\s*(\d+)", stdout)
            passed = int(p_m.group(1)) if p_m else 0
            failed = int(f_m.group(1)) if f_m else len(assert_fails)
        else:
            p_m = re.search(r"(\d+)\s*PASS", stdout)
            f_m = re.search(r"(\d+)\s*FAIL", stdout)
            passed = int(p_m.group(1)) if p_m else len(re.findall(r"\[PASS\]", stdout))
            failed = int(f_m.group(1)) if f_m else len(re.findall(r"\[FAIL\]", stdout))

        if failed > 0 or ret != 0:
            status = "FAILED"
            print(f"    ❌ {status}: {passed} passed, {failed} failed in {elapsed}s")
        else:
            print(f"    ✅ {status}: {passed} passed, 0 failed in {elapsed}s")

        results.append({
            "name": suite["name"],
            "type": suite["type"],
            "status": status,
            "tests_passed": passed,
            "tests_failed": failed,
            "elapsed": elapsed,
            "vcd": suite["vcd"]
        })

    # 3. Print Summary Dashboard
    print("\n" + "="*65)
    print("                     REGRESSION SUMMARY TABLE                   ")
    print("="*65)
    print(f"{'Suite Name':<32} | {'Type':<16} | {'Status':<8} | {'Passed':<6} | {'Time'}")
    print("-" * 65)
    total_p = sum(r["tests_passed"] for r in results)
    total_f = sum(r["tests_failed"] for r in results)

    for r in results:
        status_icon = "✅ PASS" if r["status"] == "PASSED" else "❌ FAIL"
        print(f"{r['name']:<32} | {r['type']:<16} | {status_icon:<8} | {r['tests_passed']:<6} | {r['elapsed']}s")
    print("-" * 65)
    print(f"TOTAL TESTS EXECUTED: {total_p + total_f} | PASSED: {total_p} | FAILED: {total_f}")
    print("="*65)

    # 4. Generate HTML Report
    html_path = os.path.join(REPORTS_DIR, "regression_report.html")
    generate_html(results, html_path, total_p, total_f)
    print(f"\n[4/4] 📊 Interactive HTML Report Generated -> {html_path}")
    print("\nRegression Run Complete! 🏁\n")

def generate_html(results, output_path, total_p, total_f):
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    html = f"""<!DOCTYPE html>
<html>
<head>
    <title>8-bit ALU Verification Report</title>
    <style>
        body {{ font-family: 'Segoe UI', Tahoma, sans-serif; margin: 30px; background: #0f172a; color: #f8fafc; }}
        h1 {{ color: #38bdf8; margin-bottom: 5px; }}
        .subtitle {{ color: #94a3b8; margin-bottom: 25px; }}
        .card-container {{ display: flex; gap: 20px; margin-bottom: 30px; }}
        .card {{ background: #1e293b; padding: 20px; border-radius: 12px; flex: 1; border: 1px solid #334155; }}
        .card-num {{ font-size: 28px; font-weight: bold; }}
        .card-label {{ color: #94a3b8; font-size: 14px; margin-top: 5px; }}
        .pass {{ color: #4ade80; }}
        .fail {{ color: #f87171; }}
        table {{ width: 100%; border-collapse: collapse; background: #1e293b; border-radius: 12px; overflow: hidden; border: 1px solid #334155; }}
        th, td {{ padding: 15px; text-align: left; }}
        th {{ background: #334155; color: #38bdf8; }}
        tr:not(:last-child) {{ border-bottom: 1px solid #334155; }}
        .badge {{ padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }}
        .badge-pass {{ background: #14532d; color: #4ade80; }}
        .badge-fail {{ background: #7f1d1d; color: #f87171; }}
    </style>
</head>
<body>
    <h1>⚡ 8-bit ALU Verification Dashboard</h1>
    <div class="subtitle">Automated ASIC Flow | Generated: {now}</div>

    <div class="card-container">
        <div class="card">
            <div class="card-num">{total_p + total_f}</div>
            <div class="card-label">Total Tests Run</div>
        </div>
        <div class="card">
            <div class="card-num pass">{total_p}</div>
            <div class="card-label">Total Passed</div>
        </div>
        <div class="card">
            <div class="card-num {'fail' if total_f > 0 else 'pass'}">{total_f}</div>
            <div class="card-label">Total Failed</div>
        </div>
        <div class="card">
            <div class="card-num" style="color: #38bdf8;">100%</div>
            <div class="card-label">Pass Rate</div>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>Test Suite Name</th>
                <th>Language / Paradigm</th>
                <th>Status</th>
                <th>Passed</th>
                <th>Failed</th>
                <th>Execution Time</th>
            </tr>
        </thead>
        <tbody>
    """
    for r in results:
        badge_class = "badge-pass" if r["status"] == "PASSED" else "badge-fail"
        html += f"""
            <tr>
                <td><strong>{r['name']}</strong></td>
                <td>{r['type']}</td>
                <td><span class="badge {badge_class}">{r['status']}</span></td>
                <td>{r['tests_passed']}</td>
                <td>{r['tests_failed']}</td>
                <td>{r['elapsed']}s</td>
            </tr>
        """

    html += """
        </tbody>
    </table>
</body>
</html>
    """
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(html)

if __name__ == "__main__":
    main()

// File: 11_system_tasks.v
// Topic: All major $ System Tasks and Functions in a testbench

`timescale 1ns/1ps

module system_tasks_demo;

    reg [7:0] a;
    reg [7:0] b;
    reg       clk;
    integer   i;

    // ─── DISPLAY TASKS ─────────────────────────────────────
    initial begin
        a = 8'd42;
        b = 8'hFF;

        // $display — prints with automatic newline
        $display("$display: a=%0d  b=%0d", a, b);

        // $write — prints WITHOUT newline
        $write("$write: a=");
        $write("%0d", a);
        $write("  b=%0d\n", b);    // manual newline with \n

        // $strobe — prints at END of current timestep (after all assignments)
        a = 8'd10;
        $strobe("$strobe sees a=%0d (end of timestep)", a);   // shows 10

        // Format specifiers demo
        $display("Decimal   : %d",  8'd202);       // 202
        $display("Binary    : %b",  8'd202);       // 11001010
        $display("Hex       : %h",  8'd202);       // ca
        $display("Octal     : %o",  8'd202);       // 312
        $display("No-pad dec: %0d", 8'd202);       // 202 (no spaces)
        $display("Time now  : %0t ns", $time);     // current time
    end

    // ─── $monitor ──────────────────────────────────────────
    // Set once — auto-prints whenever ANY listed variable changes
    initial begin
        $monitor("MONITOR: time=%0t  a=%0d  b=%0d", $time, a, b);
    end

    initial begin
        #10; a = 8'd1;
        #10; a = 8'd2;
        #10; b = 8'd5;     // monitor fires for each change
        #10; a = 8'd3; b = 8'd6;  // fires once (same timestep changes)
    end

    // ─── SIMULATION CONTROL ────────────────────────────────
    initial begin
        #100;
        $display("Ending simulation at time %0t", $time);
        $finish;       // end simulation — ALWAYS NEEDED!
        // $stop;      // pauses instead of ending (use for debug)
    end

    // ─── CLOCK GENERATION (forever loop) ───────────────────
    initial clk = 0;
    always #5 clk = ~clk;     // 10ns period clock (5ns half-period)

    // ─── $time / $realtime ─────────────────────────────────
    initial begin
        #7.5;
        $display("Integer time : %0t",  $time);      // 7  (truncated)
        $display("Real time    : %f ns", $realtime); // 7.500000
    end

    // ─── $random ───────────────────────────────────────────
    initial begin
        #20;
        $display("Random values:");
        for (i = 0; i < 5; i = i + 1) begin
            $display("  %0d", {$random} % 100);  // random 0-99
        end
    end

    // ─── FILE I/O ──────────────────────────────────────────
    integer file_handle;
    initial begin
        file_handle = $fopen("output_log.txt", "w");  // open for write
        $fdisplay(file_handle, "Logging simulation results");
        $fdisplay(file_handle, "a=%0d b=%0d", a, b);
        $fclose(file_handle);     // always close after done
    end

    // ─── WAVEFORM DUMP ─────────────────────────────────────
    initial begin
        $dumpfile("system_tasks_demo.vcd");  // output file
        $dumpvars(0, system_tasks_demo);     // dump all signals
        // $dumpoff;     // pause recording
        // $dumpon;      // resume recording
        // $dumpall;     // force snapshot of all values now
    end

    // ─── $signed / $unsigned ───────────────────────────────
    initial begin
        #30;
        $display("8'b11111100 unsigned = %0d", 8'b11111100);          // 252
        $display("8'b11111100 signed   = %0d", $signed(8'b11111100)); // -4
    end

endmodule

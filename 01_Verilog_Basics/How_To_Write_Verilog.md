# How to Write Code in Verilog Basics

This guide will teach you the fundamental syntax and concepts for writing RTL (Register Transfer Level) code in Verilog.

## 1. The `module` Block
Everything in Verilog is wrapped in a `module` and `endmodule`. A module represents a piece of physical hardware.

```verilog
module my_first_circuit (
    // Inputs
    input  wire a,
    input  wire b,
    
    // Outputs
    output wire y
);
    // Logic goes here
endmodule
```

## 2. Vectors (Buses)
Instead of a single wire, hardware often uses buses (vectors) to pass multiple bits at once.
```verilog
input wire [7:0] data_in;  // An 8-bit bus (MSB is bit 7, LSB is bit 0)
output wire [3:0] data_out; // A 4-bit bus (MSB is bit 3, LSB is bit 0)
```

## 3. Continuous Assignments (`assign`)
For **Combinational Circuits** (circuits with no memory or clocks, like logic gates, multiplexers, adders), we usually use the `assign` keyword. This continuously drives the output wire with the result of the logic.

```verilog
assign y = a & b;        // AND logic
assign sum = a ^ b;      // XOR logic (used in adders)
assign carry = a & b;    // AND logic (used in adders)
```

## 4. Conditional (Ternary) Operator (`? :`)
Extremely useful for routing signals, like in Multiplexers.
```verilog
// If 'sel' is 1, y = in1. If 'sel' is 0, y = in0.
assign y = sel ? in1 : in0;
```

## 5. Numbers in Verilog
Numbers are written in a specific format: `<size>'<base><value>`
- `1'b0` : 1 bit wide, binary, value 0.
- `4'b1010` : 4 bits wide, binary, value 1010 (decimal 10).
- `8'hFF` : 8 bits wide, hexadecimal, value FF (decimal 255).
- `32'd100` : 32 bits wide, decimal, value 100.

## 6. Concatenation `{}`
You can glue multiple signals together into a wider bus.
```verilog
wire [3:0] combined;
assign combined = {a, b, c, d}; // Glues 4 individual 1-bit wires into a 4-bit bus
```

## 7. Basic Testbench Template
To simulate your circuit, you need a testbench. A testbench is a Verilog file that applies inputs to your module and checks the outputs.

```verilog
`timescale 1ns / 1ps

module tb_my_circuit();
    // 1. Declare signals (inputs are reg, outputs are wire)
    reg tb_a;
    reg tb_b;
    wire tb_y;

    // 2. Instantiate the module you are testing
    my_circuit uut (
        .a(tb_a),
        .b(tb_b),
        .y(tb_y)
    );

    // 3. Apply Test Vectors
    initial begin
        // Setup GTKWave dumping
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_my_circuit);

        // Apply inputs and wait (#10 means delay 10 time units)
        tb_a = 0; tb_b = 0; #10;
        tb_a = 0; tb_b = 1; #10;
        tb_a = 1; tb_b = 0; #10;
        tb_a = 1; tb_b = 1; #10;

        $finish; // End simulation
    end
endmodule
```

## 8. Open-Source Simulation Workflow (Terminal / CMD)
To compile and simulate your RTL and Testbench, you don't *need* a heavy GUI tool like ModelSim. You can do it right from your IDE's built-in terminal (or Windows Command Prompt/PowerShell).

Assuming your terminal is currently located in your `sim` directory, run these commands:

### Step 1: Compile the Code
We use **Icarus Verilog** (`iverilog`) to compile the RTL and the Testbench together into a simulation executable (`.vvp` file).
```powershell
# iverilog -o <output_name> <path_to_rtl> <path_to_tb>
iverilog -o sim.vvp ../rtl/my_circuit.v ../tb/tb_my_circuit.v
```

### Step 2: Run the Simulation
We use the Icarus runtime engine (`vvp`) to execute the compiled file. This will print any `$display` messages and generate the `waveform.vcd` file.
```powershell
vvp sim.vvp
```

### Step 3: View the Waveforms
We use **GTKWave** to open the generated `.vcd` file and visually inspect the digital signals.
```powershell
gtkwave waveform.vcd
```

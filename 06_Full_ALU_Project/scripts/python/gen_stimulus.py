"""
File        : gen_stimulus.py
Description : Generates 1,000 random/corner-case test vectors for the ALU
              and writes them to a formatted hex file for Verilog $readmemh.
"""
import random
import os

def generate_vectors(num_vectors=1000, output_file="sim/stimulus.hex"):
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    
    # Predefined corner cases: (A, B, OP, CIN)
    corners = [
        (0x00, 0x00, 0, 0), # ADD zero
        (0xFF, 0x01, 0, 0), # ADD overflow
        (0xFF, 0xFF, 0, 1), # ADD max
        (0x00, 0xFF, 1, 0), # SUB underflow
        (0xAA, 0x55, 2, 0), # AND mask
        (0xAA, 0x55, 3, 0), # OR mask
        (0xFF, 0xFF, 4, 0), # XOR self
        (0x00, 0x00, 5, 0), # NOT zeros
        (0x80, 0x00, 6, 0), # SHL MSB out
        (0x01, 0x00, 7, 0), # SHR LSB out
    ]
    
    vectors = []
    
    # 1. Add corners first
    for a, b, op, cin in corners:
        vectors.append((a, b, op, cin))
        
    # 2. Fill the rest with random values
    for _ in range(num_vectors - len(corners)):
        a = random.randint(0, 255)
        b = random.randint(0, 255)
        op = random.randint(0, 7)
        cin = random.randint(0, 1)
        vectors.append((a, b, op, cin))
        
    # Write in Hex format: A[2 hex] B[2 hex] OP[1 hex] CIN[1 hex]
    with open(output_file, "w") as f:
        f.write("// Formatted ALU Stimulus: {A[7:0], B[7:0], OP[2:0], CIN}\n")
        for a, b, op, cin in vectors:
            f.write(f"{a:02X}{b:02X}{op:01X}{cin:01X}\n")
            
    print(f"[Python] Generated {len(vectors)} test vectors saved to -> {output_file}")

if __name__ == "__main__":
    generate_vectors()

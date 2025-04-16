# Minimal Assembler for Alpha CPU
import sys

opcode_map = {
    "ADD":  0b0000,
    "SUB":  0b0001,
    "AND":  0b0010,
    "XOR":  0b0011,
    "NOT":  0b0100,
    "SHL":  0b0101,
    "SHR":  0b0110,
    "CMP":  0b0111,
    "ADDI": 0b1000,
    "SUBI": 0b1001,
    "LD":   0b1010,
    "ST":   0b1011,
    "BR":   0b1100,
    "BZ":   0b1101,
    "BNZ":  0b1110
}

reg_map = {
    "R0": 0b00,
    "R1": 0b01,
    "R2": 0b10,
    "R3": 0b11
}

def assemble_line(line):
    parts = line.strip().replace(',', '').split()
    if not parts or parts[0].startswith(';'):
        return None

    instr = parts[0].upper()
    op = opcode_map[instr] << 12

    if instr in ["ADD", "SUB", "AND", "XOR"]:
        rd = reg_map[parts[1]] << 10
        rs1 = reg_map[parts[2]] << 8
        rs2 = reg_map[parts[3]] << 6
        return op | rd | rs1 | rs2

    elif instr in ["ADDI", "SUBI"]:
        rd = reg_map[parts[1]] << 10
        rs1 = reg_map[parts[2]] << 8
        imm4 = int(parts[3], 0) & 0b1111
        return op | rd | rs1 | (imm4 << 4)

    elif instr in ["LD", "ST"]:
        rd = reg_map[parts[1]] << 10
        base = reg_map[parts[2]] << 8
        offset = int(parts[3], 0) & 0b111111
        return op | rd | base | (offset << 2)

    elif instr in ["BR"]:
        imm8 = int(parts[1], 0) & 0xFF
        return op | imm8

    elif instr in ["BZ", "BNZ"]:
        rs = reg_map[parts[1]] << 10
        imm6 = int(parts[2], 0) & 0b111111
        return op | rs | (imm6 << 2)

    elif instr == "NOT":
        rd = reg_map[parts[1]] << 10
        return op | rd

    elif instr == "CMP":
        rs1 = reg_map[parts[1]] << 10
        rs2 = reg_map[parts[2]] << 8
        return op | rs1 | rs2

    else:
        raise ValueError(f"Unknown instruction: {instr}")

def main():
    lines = []
    with open("program.alpha", "r") as f:
        for line in f:
            code = assemble_line(line)
            if code is not None:
                print(bin(code))
                lines.append(f'{str(bin(code))[2:10]}')
                lines.append(f'{str(bin(code))[10:]}')


    with open("program.bin", "w") as f:
        for l in lines:
            f.write(l + "\n")

if __name__ == "__main__":
    main()

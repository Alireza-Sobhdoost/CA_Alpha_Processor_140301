#!/bin/bash

# Clean up previous builds
rm -f *.o *.cf *.vcd alu_tb

# Assemble the code
python3 alpha_assembler.py

# Compile
ghdl -a sign_extend.vhd
ghdl -a instruction_decoder.vhd
ghdl -a control_unit.vhd
ghdl -a register_file.vhd
ghdl -a alu.vhd
ghdl -a pc.vhd
ghdl -a -fsynopsys memory.vhd     # 👈 With this flag
ghdl -a -fsynopsys cpu.vhd         # 👈 After fixing alu_op signal
ghdl -a  -fsynopsys cpu_tb.vhd

# Elaborate and run
ghdl -e -fsynopsys  cpu_tb
ghdl -r -fsynopsys  cpu_tb --vcd=cpu.vcd

# Launch GTKWave
gtkwave cpu.vcd

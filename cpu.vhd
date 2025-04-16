library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu is
    Port (
        clk     : in  std_logic;
        reset   : in  std_logic
    );
end cpu;

architecture Structural of cpu is

    -- Signal declarations
    signal instr        : std_logic_vector(15 downto 0);
    signal opcode       : std_logic_vector(3 downto 0);
    signal rd, rs1, rs2 : std_logic_vector(1 downto 0);
    signal imm4         : std_logic_vector(3 downto 0);
    signal imm6         : std_logic_vector(5 downto 0);
    signal imm8         : std_logic_vector(7 downto 0);
    signal se_imm8      : std_logic_vector(7 downto 0);

    signal pc_val       : std_logic_vector(7 downto 0);
    signal pc_next      : std_logic_vector(7 downto 0);
    signal pc_enable    : std_logic;
    signal pc_load      : std_logic;

    signal reg_data1, reg_data2 : std_logic_vector(7 downto 0);
    signal alu_in2      : std_logic_vector(7 downto 0);
    signal alu_op : std_logic_vector(3 downto 0);
    signal alu_result   : std_logic_vector(7 downto 0);
    signal zero, carry, sign : std_logic;

    signal mem_data_out : std_logic_vector(7 downto 0);
    signal mem_data_in  : std_logic_vector(7 downto 0);
    signal mem_addr     : std_logic_vector(7 downto 0);
    signal mem_read, mem_write : std_logic;

    signal reg_write, alu_src, branch, branch_zero, branch_nz : std_logic;

begin

    -- Instantiate PC
    pc_inst: entity work.pc
        port map (
            clk => clk,
            reset => reset,
            pc_enable => pc_enable,
            pc_load => pc_load,
            load_val => pc_next,
            pc_out => pc_val
        );

    -- Memory (Instruction/Data)
    mem_inst: entity work.memory
        port map (
            clk => clk,
            addr => mem_addr,
            data_in => mem_data_in,
            data_out => mem_data_out,
            mem_read => mem_read,
            mem_write => mem_write
        );

    -- Fetch instruction
    instr(15 downto 8) <= mem_data_out; -- First byte (MSB)
    mem_addr <= pc_val;
    mem_read <= '1';

    -- Sign Extend IMM8
    signext: entity work.sign_extend
        port map (
            imm_in => imm8,
            imm_out => se_imm8
        );

    -- Decode instruction
    decoder: entity work.instruction_decoder
        port map (
            instr => instr,
            opcode => opcode,
            rd => rd,
            rs1 => rs1,
            rs2 => rs2,
            imm4 => imm4,
            imm6 => imm6,
            imm8 => imm8
        );

    -- Control unit
    control: entity work.control_unit
        port map (
            opcode => opcode,
            reg_write => reg_write,
            mem_read => mem_read,
            mem_write => mem_write,
            alu_src => alu_src,
            alu_op => alu_op,
            branch => branch,
            branch_zero => branch_zero,
            branch_nz => branch_nz
        );

    -- Register File
    regfile: entity work.register_file
        port map (
            clk => clk,
            rs1 => rs1,
            rs2 => rs2,
            rd => rd,
            we => reg_write,
            data_in => mem_data_out,
            data_out1 => reg_data1,
            data_out2 => reg_data2
        );

    -- ALU operand mux
    alu_in2 <= reg_data2 when alu_src = '0' else std_logic_vector(resize(unsigned(imm4), 8));

    -- ALU
    alu: entity work.alu
        port map (
            A => reg_data1,
            B => alu_in2,
            alu_op => alu_op,
            result => alu_result,
            zero => zero,
            carry => carry,
            sign => sign
        );

    -- Branching logic
    pc_enable <= '1';
    pc_load <= (branch or (branch_zero and zero) or (branch_nz and not zero));
    pc_next <= std_logic_vector(unsigned(pc_val) + unsigned(se_imm8));

    -- Store path
    mem_data_in <= reg_data1;
    mem_addr <= alu_result;

end Structural;

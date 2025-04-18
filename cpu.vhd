-- ===========================
-- cpu.vhd (Top-level CPU with support for LD and ST)
-- ===========================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic
    );
end cpu;

architecture Structural of cpu is

    type state_type is (FETCH1, FETCH2, EXECUTE);
    signal state       : state_type := FETCH1;

    signal pc_val      : std_logic_vector(7 downto 0) := (others => '0');
    signal instr       : std_logic_vector(15 downto 0);

    signal opcode       : std_logic_vector(3 downto 0);
    signal rd, rs1, rs2 : std_logic_vector(1 downto 0);
    signal imm4         : std_logic_vector(3 downto 0);
    signal imm6         : std_logic_vector(5 downto 0);
    signal imm8         : std_logic_vector(7 downto 0);
    signal se_imm8      : std_logic_vector(7 downto 0);

    signal mem_addr     : std_logic_vector(7 downto 0);
    signal mem_data_in  : std_logic_vector(7 downto 0);
    signal mem_data_out : std_logic_vector(7 downto 0);
    signal mem_write    : std_logic := '0';
    signal fetch_mem_read : std_logic := '0';
    signal data_mem_read  : std_logic := '0';
    signal mem_read       : std_logic;

    signal reg_data1, reg_data2 : std_logic_vector(7 downto 0);
    signal alu_in2              : std_logic_vector(7 downto 0);
    signal alu_result           : std_logic_vector(7 downto 0);
    signal alu_op               : std_logic_vector(3 downto 0);
    signal zero, carry, sign    : std_logic;

    signal reg_write, alu_src, branch, branch_zero, branch_nz : std_logic;
    signal pc_load     : std_logic;
    signal pc_next     : std_logic_vector(7 downto 0);

    signal writeback_data : std_logic_vector(7 downto 0);

    component memory is
        Port (
            clk       : in  std_logic;
            addr      : in  std_logic_vector(7 downto 0);
            data_in   : in  std_logic_vector(7 downto 0);
            data_out  : out std_logic_vector(7 downto 0);
            mem_read  : in  std_logic;
            mem_write : in  std_logic
        );
    end component;

    component instruction_decoder is
        Port (
            instr   : in  std_logic_vector(15 downto 0);
            opcode  : out std_logic_vector(3 downto 0);
            rd      : out std_logic_vector(1 downto 0);
            rs1     : out std_logic_vector(1 downto 0);
            rs2     : out std_logic_vector(1 downto 0);
            imm4    : out std_logic_vector(3 downto 0);
            imm6    : out std_logic_vector(5 downto 0);
            imm8    : out std_logic_vector(7 downto 0)
        );
    end component;

    component control_unit is
        Port (
            opcode      : in  std_logic_vector(3 downto 0);
            reg_write   : out std_logic;
            mem_read    : out std_logic;
            mem_write   : out std_logic;
            alu_src     : out std_logic;
            alu_op      : out std_logic_vector(3 downto 0);
            branch      : out std_logic;
            branch_zero : out std_logic;
            branch_nz   : out std_logic
        );
    end component;

    component register_file is
        Port (
            clk        : in  std_logic;
            rs1        : in  std_logic_vector(1 downto 0);
            rs2        : in  std_logic_vector(1 downto 0);
            rd         : in  std_logic_vector(1 downto 0);
            we         : in  std_logic;
            data_in    : in  std_logic_vector(7 downto 0);
            data_out1  : out std_logic_vector(7 downto 0);
            data_out2  : out std_logic_vector(7 downto 0)
        );
    end component;

    component alu is
        Port (
            A      : in  std_logic_vector(7 downto 0);
            B      : in  std_logic_vector(7 downto 0);
            alu_op : in  std_logic_vector(3 downto 0);
            result : out std_logic_vector(7 downto 0);
            zero   : out std_logic;
            carry  : out std_logic;
            sign   : out std_logic
        );
    end component;

    component sign_extend is
        Port (
            imm_in  : in  std_logic_vector(7 downto 0);
            imm_out : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    mem_read <= fetch_mem_read or data_mem_read;

    mem_inst: memory port map (
        clk => clk,
        addr => mem_addr,
        data_in => mem_data_in,
        data_out => mem_data_out,
        mem_read => mem_read,
        mem_write => mem_write
    );

    decoder: instruction_decoder port map (
        instr => instr,
        opcode => opcode,
        rd => rd,
        rs1 => rs1,
        rs2 => rs2,
        imm4 => imm4,
        imm6 => imm6,
        imm8 => imm8
    );

    control: control_unit port map (
        opcode => opcode,
        reg_write => reg_write,
        mem_read => data_mem_read,
        mem_write => mem_write,
        alu_src => alu_src,
        alu_op => alu_op,
        branch => branch,
        branch_zero => branch_zero,
        branch_nz => branch_nz
    );

    writeback_data <= alu_result when opcode /= "1010" else mem_data_out;

    regfile: register_file port map (
        clk => clk,
        rs1 => rs1,
        rs2 => rs2,
        rd => rd,
        we => reg_write,
        data_in => writeback_data,
        data_out1 => reg_data1,
        data_out2 => reg_data2
    );

    alu_in2 <= reg_data2 when alu_src = '0' else std_logic_vector(resize(unsigned(imm4), 8));

    alu_inst: alu port map (
        A => reg_data1,
        B => alu_in2,
        alu_op => alu_op,
        result => alu_result,
        zero => zero,
        carry => carry,
        sign => sign
    );

    signext: sign_extend port map (
        imm_in => imm8,
        imm_out => se_imm8
    );

    process(clk, reset)
    begin
        if reset = '1' then
            state   <= FETCH1;
            pc_val  <= (others => '0');
            instr   <= (others => '0');
        elsif rising_edge(clk) then
            case state is
                when FETCH1 =>
                    mem_addr       <= pc_val;
                    fetch_mem_read <= '1';
                    mem_write      <= '0';
                    state          <= FETCH2;

                when FETCH2 =>
                    instr(15 downto 8) <= mem_data_out;
                    mem_addr       <= std_logic_vector(unsigned(pc_val) + 1);
                    state          <= EXECUTE;

                when EXECUTE =>
                    instr(7 downto 0) <= mem_data_out;
                    fetch_mem_read <= '0';

                    pc_load <= branch or (branch_zero and zero) or (branch_nz and (not zero));
                    pc_next <= std_logic_vector(unsigned(pc_val) + unsigned(se_imm8));
                    if pc_load = '1' then
                        pc_val <= pc_next;
                    else
                        pc_val <= std_logic_vector(unsigned(pc_val) + 2);
                    end if;

                    -- Address for LD/ST comes from ALU
                    if opcode = "1010" or opcode = "1011" then
                        mem_addr <= alu_result;
                    end if;

                    state <= FETCH1;
            end case;
        end if;
    end process;

    mem_data_in <= reg_data1;

end Structural;

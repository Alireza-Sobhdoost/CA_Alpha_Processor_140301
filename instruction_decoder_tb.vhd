library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_decoder_tb is
end instruction_decoder_tb;

architecture Behavioral of instruction_decoder_tb is
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

    signal instr   : std_logic_vector(15 downto 0);
    signal opcode  : std_logic_vector(3 downto 0);
    signal rd, rs1, rs2 : std_logic_vector(1 downto 0);
    signal imm4    : std_logic_vector(3 downto 0);
    signal imm6    : std_logic_vector(5 downto 0);
    signal imm8    : std_logic_vector(7 downto 0);

begin
    uut: instruction_decoder port map (
        instr => instr, opcode => opcode,
        rd => rd, rs1 => rs1, rs2 => rs2,
        imm4 => imm4, imm6 => imm6, imm8 => imm8
    );

    process
    begin
        -- Test 1: ADD R1, R2, R3 (opcode = 0000)
        -- encoding: opcode=0000, rd=01, rs1=10, rs2=11
        instr <= "0000011011000000"; -- binary
        wait for 10 ns;
        -- Expected:
        -- opcode = "0000"
        -- rd = "01", rs1 = "10", rs2 = "11"
        -- imm4 = "1100", imm6 = "110000", imm8 = "11000000"

        -- Test 2: ADDI R2, R0, imm4=0101
        instr <= "1000100001010000";
        wait for 10 ns;
        -- opcode = "1000"
        -- rd = "10", rs1 = "00", imm4 = "0101"

        -- Test 3: LD R1, [R2, 101010]
        instr <= "1010011010100000";
        wait for 10 ns;
        -- opcode = "1010"
        -- rd = "01", rs1 = "10", imm6 = "101010"

        wait;
    end process;
end Behavioral;

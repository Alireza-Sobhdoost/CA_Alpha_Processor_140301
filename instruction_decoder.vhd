library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_decoder is
    Port (
        instr      : in  std_logic_vector(15 downto 0);
        opcode     : out std_logic_vector(3 downto 0);
        rd         : out std_logic_vector(1 downto 0);
        rs1        : out std_logic_vector(1 downto 0);
        rs2        : out std_logic_vector(1 downto 0);
        imm4       : out std_logic_vector(3 downto 0);
        imm6       : out std_logic_vector(5 downto 0);
        imm8       : out std_logic_vector(7 downto 0)
    );
end instruction_decoder;

architecture Behavioral of instruction_decoder is
begin
    process(instr)
    begin
        opcode <= instr(15 downto 12);
        rd     <= instr(11 downto 10);
        rs1    <= instr(9 downto 8);
        rs2    <= instr(7 downto 6);
        imm4   <= instr(7 downto 4);  -- for ADDI/SUBI
        imm6   <= instr(7 downto 2);  -- for LD/ST
        imm8   <= instr(7 downto 0);  -- for BR, BZ, BNZ
    end process;
end Behavioral;

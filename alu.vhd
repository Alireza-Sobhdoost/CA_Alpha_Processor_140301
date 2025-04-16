library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
        A        : in  std_logic_vector(7 downto 0);  -- First operand
        B        : in  std_logic_vector(7 downto 0);  -- Second operand or extended imm
        alu_op   : in  std_logic_vector(3 downto 0);  -- Operation selector
        result   : out std_logic_vector(7 downto 0);  -- ALU result
        zero     : out std_logic;                     -- Zero flag
        carry    : out std_logic;                     -- Carry flag
        sign     : out std_logic                      -- Sign flag (MSB)
    );
end alu;

architecture Behavioral of alu is
    signal temp_result : unsigned(8 downto 0);  -- 9-bit result to capture carry
begin
    process(A, B, alu_op)
    begin
        temp_result <= (others => '0');
        
        case alu_op is
            when "0000" =>  -- ADD: A + B
                temp_result <= ("0" & unsigned(A)) + ("0" & unsigned(B));

            when "0001" =>  -- SUB: A - B
                temp_result <= ("0" & unsigned(A)) - ("0" & unsigned(B));

            when "0010" =>  -- AND
                temp_result(7 downto 0) <= unsigned(A and B);
                temp_result(8) <= '0';

            when "0011" =>  -- XOR
                temp_result(7 downto 0) <= unsigned(A xor B);
                temp_result(8) <= '0';

            when "0100" =>  -- NOT A
                temp_result(7 downto 0) <= unsigned(not A);
                temp_result(8) <= '0';

            when "0101" =>  -- SHL A (Logical left shift by 1)
                temp_result <= ("0" & unsigned(A(6 downto 0) & '0'));

            when "0110" =>  -- SHR A (Logical right shift by 1)
                temp_result <= unsigned("0" & ('0' & A(7 downto 1)));

            when "0111" =>  -- CMP: A - B (flags only)
                temp_result <= ("0" & unsigned(A)) - ("0" & unsigned(B));

            when "1000" =>  -- ADDI: A + imm4 (in lower 4 bits of B)
                temp_result <= ("0" & unsigned(A)) + ("0" & unsigned(B));

            when "1001" =>  -- SUBI: A - imm4
                temp_result <= ("0" & unsigned(A)) - ("0" & unsigned(B));

            when others =>
                temp_result <= (others => '0');
        end case;
    end process;

    result <= std_logic_vector(temp_result(7 downto 0));
    zero   <= '1' when temp_result(7 downto 0) = "00000000" else '0';
    sign   <= temp_result(7); -- MSB is sign
    carry  <= temp_result(8); -- carry out from 8th bit
end Behavioral;

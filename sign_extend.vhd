library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sign_extend is
    Port (
        imm_in  : in  std_logic_vector(7 downto 0);
        imm_out : out std_logic_vector(7 downto 0)
    );
end sign_extend;

architecture Behavioral of sign_extend is
begin
    process(imm_in)
    begin
        if imm_in(7) = '1' then
            imm_out <= std_logic_vector(signed(imm_in));
        else
            imm_out <= imm_in;
        end if;
    end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc is
    Port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        pc_enable : in  std_logic;  -- Enable increment
        pc_load   : in  std_logic;  -- Enable direct load (branch/jump)
        load_val  : in  std_logic_vector(7 downto 0);  -- New PC value if pc_load = 1
        pc_out    : out std_logic_vector(7 downto 0)   -- Current PC value
    );
end pc;

architecture Behavioral of pc is
    signal pc_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');
        elsif rising_edge(clk) then
            if pc_load = '1' then
                pc_reg <= load_val;
            elsif pc_enable = '1' then
                pc_reg <= std_logic_vector(unsigned(pc_reg) + 2); -- Next instruction (2 bytes)
            end if;
        end if;
    end process;

    pc_out <= pc_reg;
end Behavioral;

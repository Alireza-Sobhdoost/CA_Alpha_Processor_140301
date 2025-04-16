library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port (
        clk        : in  std_logic;
        rs1        : in  std_logic_vector(1 downto 0); -- 2-bit selector
        rs2        : in  std_logic_vector(1 downto 0);
        rd         : in  std_logic_vector(1 downto 0);
        we         : in  std_logic;
        data_in    : in  std_logic_vector(7 downto 0);
        data_out1  : out std_logic_vector(7 downto 0);
        data_out2  : out std_logic_vector(7 downto 0)
    );
end register_file;

architecture Behavioral of register_file is
    type reg_array is array (0 to 3) of std_logic_vector(7 downto 0);
    signal regs : reg_array := (others => (others => '0'));
begin
    -- Read (combinational)
    data_out1 <= regs(to_integer(unsigned(rs1)));
    data_out2 <= regs(to_integer(unsigned(rs2)));

    -- Write (synchronous)
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                regs(to_integer(unsigned(rd))) <= data_in;
            end if;
        end if;
    end process;
end Behavioral;

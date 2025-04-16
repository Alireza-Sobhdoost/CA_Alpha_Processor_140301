library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity memory is
    Port (
        clk       : in  std_logic;
        addr      : in  std_logic_vector(7 downto 0);
        data_in   : in  std_logic_vector(7 downto 0);
        data_out  : out std_logic_vector(7 downto 0);
        mem_read  : in  std_logic;
        mem_write : in  std_logic
    );
end memory;

architecture Behavioral of memory is
    type mem_type is array (0 to 255) of std_logic_vector(7 downto 0);
    signal mem : mem_type := (others => (others => '0'));

    -- Initialize specific memory locations for testing
    function init_memory return mem_type is
        variable temp_mem : mem_type;
    begin
        temp_mem := (others => (others => '0'));
        -- Set test values
        temp_mem(0) := "10000100";  
        temp_mem(1) := "01010000";  
        temp_mem(2) := "10110110";  
        temp_mem(3) := "00101000";  
        temp_mem(4) := "10101110";  
        temp_mem(5) := "00101000";  
        temp_mem(6) := "10000101";  
        temp_mem(7) := "00010000";  



        return temp_mem;
    end function;

begin
    -- Initialize memory with test values
    mem <= init_memory;

    -- Read logic with synchronous reset
    process(clk)
    begin
        if rising_edge(clk) then
            if mem_read = '1' then
                data_out <= mem(to_integer(unsigned(addr)));
                report "Reading from address: " & integer'image(to_integer(unsigned(addr)));
                report "Value: " & integer'image(to_integer(unsigned(mem(to_integer(unsigned(addr))))));
            else
                data_out <= (others => 'Z');
            end if;
        end if;
    end process;
    
    -- Rest of the architecture remains the same

end Behavioral;

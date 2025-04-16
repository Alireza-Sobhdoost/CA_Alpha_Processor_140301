library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;  -- Add this package for hread

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

    -- Load program.hex at startup
    procedure load_memory(signal mem_inout : inout mem_type) is
        file hex_file : text open read_mode is "program.hex";
        variable linebuf : line;
        variable hex_val : std_logic_vector(7 downto 0);
        variable i      : integer := 0;
    begin
        while not endfile(hex_file) and i < 256 loop
            readline(hex_file, linebuf);
            hread(linebuf, hex_val);  -- Now hread is available
            mem_inout(i) <= hex_val;
            i := i + 1;
        end loop;
    end procedure;

begin

    -- Memory init block (simulation only)
    init: process
    begin
        load_memory(mem);
        wait;
    end process;

    -- Write logic
    process(clk)
    begin
        if rising_edge(clk) then
            if mem_write = '1' then
                mem(to_integer(unsigned(addr))) <= data_in;
            end if;
        end if;
    end process;

    -- Read logic
    data_out <= mem(to_integer(unsigned(addr))) when mem_read = '1' else (others => 'Z');

end Behavioral;

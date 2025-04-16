library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory_tb is
end memory_tb;

architecture Behavioral of memory_tb is
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

    signal clk : std_logic := '0';
    signal addr : std_logic_vector(7 downto 0);
    signal data_in : std_logic_vector(7 downto 0);
    signal data_out : std_logic_vector(7 downto 0);
    signal mem_read, mem_write : std_logic;

    constant clk_period : time := 10 ns;
begin
    -- Clock process
    clk_process : process
    begin
        while now < 100 ns loop
            clk <= '0'; wait for clk_period / 2;
            clk <= '1'; wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Instantiate memory
    uut: memory port map (
        clk => clk, addr => addr, data_in => data_in,
        data_out => data_out, mem_read => mem_read, mem_write => mem_write
    );

    -- Stimulus
    stim_proc: process
    begin
        -- Wait for memory initialization to complete:
        wait for 2 ns;  -- Adjust as necessary based on simulation delta cycles
    
        -- Now perform read operations, for instance:
        addr <= x"00";  -- Read memory at address 0
        mem_read <= '1';
        mem_write <= '0';
        wait for clk_period;
    
        addr <= x"01";  -- Read memory at address 1
        wait for clk_period;
    
        addr <= x"02";  -- Read memory at address 2
        wait for clk_period;
    
        wait;
    end process;
    
end Behavioral;

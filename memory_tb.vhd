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
        -- Write 0xAB to memory[10]
        addr <= x"0A";
        data_in <= x"AB";
        mem_write <= '1';
        mem_read <= '0';
        wait for clk_period;

        mem_write <= '0';

        -- Read from memory[10]
        mem_read <= '1';
        wait for clk_period;

        wait;
    end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu_tb is
end cpu_tb;

architecture Behavioral of cpu_tb is

    component cpu is
        Port (
            clk   : in  std_logic;
            reset : in  std_logic
        );
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';

    constant clk_period : time := 10 ns;

begin

    -- Instantiate the CPU
    uut: cpu port map (
        clk => clk,
        reset => reset
    );

    -- Clock generation
    clk_process : process
    begin
        while now < 1 ms loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply reset
        reset <= '1';
        wait for 2 * clk_period;
        reset <= '0';

        -- Let the CPU run
        wait for 500 ns;

        -- Stop simulation
        assert false report "Simulation finished." severity failure;
    end process;

end Behavioral;
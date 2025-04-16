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

        -- Hardcoded memory init
        -- Example instructions:
        -- ADDI R1, R0, 5   → 8805
        -- ST R1, R2, 10    → B4A8
        -- LD R3, R2, 10    → D6A8
        -- CMP R3, R1       → 7A40
        -- BZ R3, 2         → D302
        -- ADDI R1, R1, 1   → 8C11

        wait for 500 ns;

        -- Stop simulation
        assert false report "Simulation finished." severity failure;
    end process;

end Behavioral;

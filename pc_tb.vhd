library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc_tb is
end pc_tb;

architecture Behavioral of pc_tb is
    -- Component declaration
    component pc is
        Port (
            clk       : in  std_logic;
            reset     : in  std_logic;
            pc_enable : in  std_logic;
            pc_load   : in  std_logic;
            load_val  : in  std_logic_vector(7 downto 0);
            pc_out    : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal pc_enable : std_logic := '0';
    signal pc_load   : std_logic := '0';
    signal load_val  : std_logic_vector(7 downto 0) := (others => '0');
    signal pc_out    : std_logic_vector(7 downto 0);

    -- Clock generation
    constant clk_period : time := 10 ns;
begin
    -- Instantiate PC
    uut: pc port map (
        clk       => clk,
        reset     => reset,
        pc_enable => pc_enable,
        pc_load   => pc_load,
        load_val  => load_val,
        pc_out    => pc_out
    );

    -- Clock process
    clk_process : process
    begin
        while now < 200 ns loop
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
        -- Test reset
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        -- Increment PC normally (expect PC = 2, 4, 6)
        pc_enable <= '1';
        wait for 3 * clk_period;

        -- Jump to address 40
        pc_enable <= '0';
        pc_load   <= '1';
        load_val  <= x"28";  -- decimal 40
        wait for clk_period;

        pc_load <= '0';
        pc_enable <= '1';
        wait for 2 * clk_period;  -- PC = 42, 44

        -- Stop
        wait;
    end process;

end Behavioral;

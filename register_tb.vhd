library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_tb is
end register_tb;

architecture Behavioral of register_tb is
    component register_file is
        Port (
            clk        : in  std_logic;
            rs1        : in  std_logic_vector(1 downto 0);
            rs2        : in  std_logic_vector(1 downto 0);
            rd         : in  std_logic_vector(1 downto 0);
            we         : in  std_logic;
            data_in    : in  std_logic_vector(7 downto 0);
            data_out1  : out std_logic_vector(7 downto 0);
            data_out2  : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal rs1, rs2, rd : std_logic_vector(1 downto 0);
    signal we : std_logic;
    signal data_in : std_logic_vector(7 downto 0);
    signal data_out1, data_out2 : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;
begin
    -- Clock
    clk_process : process
    begin
        while now < 100 ns loop
            clk <= '0'; wait for clk_period / 2;
            clk <= '1'; wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Instantiate register file
    uut: register_file port map (
        clk => clk, rs1 => rs1, rs2 => rs2, rd => rd, we => we,
        data_in => data_in, data_out1 => data_out1, data_out2 => data_out2
    );

    -- Stimulus
    stim_proc: process
    begin
        -- Write 0xAA to R1
        rd <= "01"; data_in <= x"AA"; we <= '1';
        wait for clk_period;

        -- Write 0x55 to R2
        rd <= "10"; data_in <= x"55"; we <= '1';
        wait for clk_period;

        -- Read R1 and R2
        we <= '0';
        rs1 <= "01"; rs2 <= "10";
        wait for clk_period;

        wait;
    end process;
end Behavioral;

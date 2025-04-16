library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_tb is
end alu_tb;

architecture Behavioral of alu_tb is
    -- Component Declaration
    component alu is
        Port (
            A      : in  std_logic_vector(7 downto 0);
            B      : in  std_logic_vector(7 downto 0);
            alu_op : in  std_logic_vector(3 downto 0);
            result : out std_logic_vector(7 downto 0);
            zero   : out std_logic;
            carry  : out std_logic;
            sign   : out std_logic
        );
    end component;

    -- Signals
    signal A, B, result : std_logic_vector(7 downto 0);
    signal alu_op       : std_logic_vector(3 downto 0);
    signal zero, carry, sign : std_logic;

begin
    -- Instantiate ALU
    uut: alu port map (
        A      => A,
        B      => B,
        alu_op => alu_op,
        result => result,
        zero   => zero,
        carry  => carry,
        sign   => sign
    );

    -- Stimulus Process
    process
    begin
        -- ADD: 10 + 20 = 30
        A <= "00001010";  -- 10
        B <= "00010100";  -- 20
        alu_op <= "0000"; -- ADD
        wait for 10 ns;

        -- SUB: 10 - 20 = -10 (246 as unsigned)
        A <= "00001010";  -- 10
        B <= "00010100";  -- 20
        alu_op <= "0001"; -- SUB
        wait for 10 ns;

        -- AND: 10101010 and 11001100 = 10001000
        A <= "10101010";
        B <= "11001100";
        alu_op <= "0010"; -- AND
        wait for 10 ns;

        -- XOR: 10101010 xor 11001100 = 01100110
        A <= "10101010";
        B <= "11001100";
        alu_op <= "0011"; -- XOR
        wait for 10 ns;

        -- NOT: ~10101010 = 01010101
        A <= "10101010";
        B <= (others => '0'); -- Not used
        alu_op <= "0100"; -- NOT
        wait for 10 ns;

        -- SHL: 10000001 << 1 = 00000010
        A <= "10000001";
        alu_op <= "0101"; -- SHL
        wait for 10 ns;

        -- SHR: 10000001 >> 1 = 01000000
        A <= "10000001";
        alu_op <= "0110"; -- SHR
        wait for 10 ns;

        -- CMP: 40 - 40 = 0, zero = 1
        A <= "00101000"; -- 40
        B <= "00101000"; -- 40
        alu_op <= "0111"; -- CMP
        wait for 10 ns;

        -- ADDI: 15 + 4 = 19
        A <= "00001111";  -- 15
        B <= "00000100";  -- imm = 4 (already extended)
        alu_op <= "1000"; -- ADDI
        wait for 10 ns;

        -- SUBI: 15 - 5 = 10
        A <= "00001111";  -- 15
        B <= "00000101";  -- imm = 5
        alu_op <= "1001"; -- SUBI
        wait for 10 ns;

        -- Finish simulation
        wait;
    end process;

end Behavioral;

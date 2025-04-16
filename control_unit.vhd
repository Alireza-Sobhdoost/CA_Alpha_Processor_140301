library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port (
        opcode     : in  std_logic_vector(3 downto 0);
        reg_write  : out std_logic;
        mem_read   : out std_logic;
        mem_write  : out std_logic;
        alu_src    : out std_logic; -- 0: reg, 1: immediate
        alu_op     : out std_logic_vector(3 downto 0);
        branch     : out std_logic;
        branch_zero: out std_logic;
        branch_nz  : out std_logic
    );
end control_unit;

architecture Behavioral of control_unit is
begin
    process(opcode)
    begin
        -- Default signals
        reg_write   <= '0';
        mem_read    <= '0';
        mem_write   <= '0';
        alu_src     <= '0';
        alu_op      <= (others => '0');
        branch      <= '0';
        branch_zero <= '0';
        branch_nz   <= '0';

        case opcode is
            when "0000" => -- ADD
                reg_write <= '1';
                alu_op <= "0000";

            when "0001" => -- SUB
                reg_write <= '1';
                alu_op <= "0001";

            when "0010" => -- AND
                reg_write <= '1';
                alu_op <= "0010";

            when "0011" => -- XOR
                reg_write <= '1';
                alu_op <= "0011";

            when "0100" => -- NOT
                reg_write <= '1';
                alu_op <= "0100";

            when "0101" => -- SHL
                reg_write <= '1';
                alu_op <= "0101";

            when "0110" => -- SHR
                reg_write <= '1';
                alu_op <= "0110";

            when "0111" => -- CMP
                reg_write <= '0'; -- flags only
                alu_op <= "0111";

            when "1000" => -- ADDI
                reg_write <= '1';
                alu_src <= '1';
                alu_op <= "1000";

            when "1001" => -- SUBI
                reg_write <= '1';
                alu_src <= '1';
                alu_op <= "1001";

            when "1010" => -- LD
                reg_write <= '1';
                mem_read <= '1';
                alu_src <= '1'; -- Use immediate offset

            when "1011" => -- ST
                mem_write <= '1';
                alu_src <= '1'; -- Use immediate offset

            when "1100" => -- BR zz
                branch <= '1';

            when "1101" => -- BZ R1, zz
                branch_zero <= '1';

            when "1110" => -- BNZ R1, zz
                branch_nz <= '1';

            when others =>
                -- NOP or invalid
                null;
        end case;
    end process;
end Behavioral;

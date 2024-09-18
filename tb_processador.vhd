library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_CPU is
end entity tb_CPU;

architecture Behavioral of tb_CPU is
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal opcode   : std_logic_vector(6 downto 0) := (others => '0');
    signal pc_out   : std_logic_vector(31 downto 0);
    signal mem_out  : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin
    -- Instantiate the CPU
    uut: entity work.CPU
        port map (
            clock   => clk
        );

    -- Clock generation process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    stim_proc : process
    begin
        
        report "mem_out value: " & std_logic_vector'IMAGE(mem_out);

        wait for 100 ns;

    end process;

end architecture Behavioral;

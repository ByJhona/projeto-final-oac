library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity CPU_tb is
end entity CPU_tb;

architecture behavior of CPU_tb is

    signal clk : std_logic := '0';
    signal instruction_p : std_logic_vector(31 downto 0) := (others => '0');
    signal instruction_address_p : std_logic_vector(31 downto 0) := (others => '0');
    signal ula_out_p  : std_logic_vector(31 downto 0) := (others => '0');
    signal OrigAULA_p : std_logic_vector(1 downto 0);
    signal OrigBULA_p : std_logic_vector(1 downto 0);
    signal OrigPC_p   : std_logic;


    constant clk_period : time := 100 ns;

begin
    -- Instantiate the CPU
    uut: entity work.CPU
        port map (
            cpu_clock => clk,
            instruction_p => instruction_p,
            instruction_address_p => instruction_address_p,
            ula_out_p => ula_out_p,
            OrigAULA_p => OrigAULA_p,
            OrigBULA_p => OrigBULA_p,
            OrigPC_p => OrigPC_p
        );

    -- Clock generation process with limited cycles
    clk_process : process
        constant num_cycles : integer := 10;  -- Number of clock cycles you want to run
        variable cycle_count : integer := 0;  -- Internal counter
    begin
        
        while cycle_count < num_cycles loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;

            cycle_count := cycle_count + 1;
        end loop;

        -- Hold the clock low after reaching the desired cycles
        clk <= '0';
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        FOR i IN 0 TO 150 LOOP
            report "---------------------------------------";
            report "instruction_address: " & to_hstring(instruction_address_p);
            report "instrcution: " & to_hstring(instruction_p);
            report "ula out: " & to_hstring(ula_out_p);
            report "orig aula: " & to_string(OrigAULA_p);
            report "orig bula: " & to_string(OrigBULA_p);
            report "orig pc: " & to_string(OrigPC_p);
            wait for clk_period;
        END LOOP;
        wait;
    end process;

end architecture behavior;

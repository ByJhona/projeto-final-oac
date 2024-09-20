library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity CPU_tb is
end entity CPU_tb;

architecture behavior of CPU_tb is

    signal clk : std_logic := '0';
    signal cpu_in : std_logic_vector(31 downto 0) := (others => '0');
    signal cpu_out : std_logic_vector(31 downto 0);
    signal opcode : std_logic_vector(6 downto 0);

    constant clk_period : time := 100 ns;

begin
    -- Instantiate the CPU
    uut: entity work.CPU
        port map (
            cpu_clock => clk,
            cpu_in    => cpu_in,
            cpu_out   => cpu_out,
            opcode    => opcode 
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

            -- Increment the counter at each rising edge
            cycle_count := cycle_count + 1;
        end loop;

        -- Hold the clock low after reaching the desired cycles
        clk <= '0';
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Initialize with some inputs and wait for the clock to stabilize
        wait for 50 ns;
        
        -- First input
        cpu_in <= x"00000000";  
        wait for clk_period;  -- Wait for the next clock cycle
        report "mem_out value after first input: " & to_hstring(cpu_out);
        report "opcode value after first input: " & to_string(opcode);

        -- Second input
        cpu_in <= x"00000001";  
        wait for clk_period;
        report "mem_out value after second input: " & to_hstring(cpu_out);
        report "opcode value after second input: " & to_string(opcode);

        -- Third input
        cpu_in <= x"00000002";  
        wait for clk_period;
        report "mem_out value after third input: " & to_hstring(cpu_out);
        report "opcode value after third input: " & to_string(opcode);

        -- End simulation
        wait;
    end process;

end architecture behavior;

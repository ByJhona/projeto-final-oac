library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Reg_File_tb is
end Reg_File_tb;

architecture behavior of Reg_File_tb is

  -- Constants
  constant WSIZE : natural := 32;

  -- Signals for driving the unit under test (UUT)
  signal clk     : std_logic := '0';
  signal wren    : std_logic := '0';
  signal rs1, rs2, rd : std_logic_vector(4 downto 0) := (others => '0');
  signal data    : std_logic_vector(WSIZE-1 downto 0) := (others => '0');
  signal ro1, ro2 : std_logic_vector(WSIZE-1 downto 0);

  -- Instance of the register file
  component Reg_File
    generic (WSIZE : natural := 32);
    port (
      clk, wren     : in std_logic;
      rs1, rs2, rd  : in std_logic_vector(4 downto 0);
      data          : in std_logic_vector(WSIZE-1 downto 0);
      ro1, ro2      : out std_logic_vector(WSIZE-1 downto 0)
    );
  end component;

begin

  -- Instantiate the Unit Under Test (UUT)
  UUT: Reg_File
    generic map (WSIZE => WSIZE)
    port map (
      clk => clk,
      wren => wren,
      rs1 => rs1,
      rs2 => rs2,
      rd => rd,
      data => data,
      ro1 => ro1,
      ro2 => ro2
    );

  -- Clock process
  clk_process :process
  begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
  end process;

  -- Test process
  stimulus_process: process
  begin
    -- Fill all registers with sequential values
    for i in 1 to 31 loop
      wren <= '1';
      rd <= std_logic_vector(to_unsigned(i, 5));  -- Register address
      data <= std_logic_vector(to_unsigned(i, WSIZE));  -- Sequential value
      wait for 10 ns;
    end loop;
    
    -- Disable write enable
    wren <= '0';

    -- Test that all registers have the correct sequential values
    for i in 1 to 31 loop
      rs1 <= std_logic_vector(to_unsigned(i, 5));
      rs2 <= std_logic_vector(to_unsigned(31 - i + 1, 5));  -- Access in reverse order
      wait for 10 ns;
      assert ro1 = std_logic_vector(to_unsigned(i, WSIZE))
      report "Test failed: ro1 should be " & integer'image(i) severity error;
      assert ro2 = std_logic_vector(to_unsigned(31 - i + 1, WSIZE))
      report "Test failed: ro2 should be " & integer'image(31 - i + 1) severity error;
    end loop;

    -- Test that register 0 always reads as zero
    wren <= '1';
    rd <= "00000";           -- Attempt to write to register 0
    data <= x"FFFFFFFF";
    wait for 10 ns;

    -- Read from register 0
    wren <= '0';
    rs1 <= "00000";
    rs2 <= "00000";
    wait for 10 ns;
    assert ro1 = x"00000000"
    report "Test failed: ro1 should be 0x00000000" severity error;
    assert ro2 = x"00000000"
    report "Test failed: ro2 should be 0x00000000" severity error;

    -- Stop simulation
    wait;
  end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity Reg_File is
  generic (WSIZE : natural := 32);
    port (

      clk  : in std_logic;
      wren : in std_logic;
      rs1  : in std_logic_vector(4 downto 0);
      rs2  : in std_logic_vector(4 downto 0);
      rd   : in std_logic_vector(4 downto 0);
      data : in std_logic_vector(WSIZE-1 downto 0);
      
      ro1  : out std_logic_vector(WSIZE-1 downto 0);
      ro2  : out std_logic_vector(WSIZE-1 downto 0)

    );
end Reg_File;

architecture behavior of Reg_File is
  type reg_file_type is array (0 to 31) of std_logic_vector(WSIZE-1 downto 0);
  signal reg_file : reg_file_type := (others => (others => '0'));
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if wren = '1' and rd /= "00000" then
        reg_file(to_integer(unsigned(rd))) <= data;
      end if;
    end if;
  end process;

  ro1 <= reg_file(to_integer(unsigned(rs1)));
  ro2 <= reg_file(to_integer(unsigned(rs2)));

end behavior;

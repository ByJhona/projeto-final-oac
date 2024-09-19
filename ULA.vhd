library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity ula_RV is
	generic (WIDTH : natural := 32);
	port (
		opcode : in STD_LOGIC_VECTOR(3 downto 0); 
		A, B   : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0); 
		Z      : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0); 
		cond   : out STD_LOGIC;
    );
end ula_RV ;

architecture behav of ula_RV  is
	constant zeros : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
begin
	process (A, B, opcode, Z, cond) is
	begin

        -- Default to inactive cond for all non-comparison ops
        cond <= '0';

		case opcode is
			when "0000" => Z <= std_logic_vector(signed(A) + signed(B));
			when "0001" => Z <= std_logic_vector(signed(A) - signed(B));
            when "0010" => Z <= A and B;
            when "0011" => Z <= A or B;
            when "0100" => Z <= A xor B;
			when "0101" => Z <= A sll to_integer(unsigned(B));
            when "0110" => Z <= A srl to_integer(unsigned(B));
            when "0111" => Z <= std_logic_vector(signed(A) sra to_integer(unsigned(B)));
			when "1000" => 
                Z <= std_logic_vector(to_signed(1, 32)) when signed(A) < signed(B) 
                else std_logic_vector(to_signed(0, 32));
            when "1001" => 
                Z <= std_logic_vector(to_signed(1, 32)) when unsigned(A) < unsigned(B) 
                else std_logic_vector(to_signed(0, 32));
            when "1010" => 
                if signed(A) >= signed(B) then
                    Z <= std_logic_vector(to_signed(1, 32));
                    cond <= '1';  
                else
                    Z <= std_logic_vector(to_signed(0, 32));
                    cond <= '0';  
                end if;
            when "1011" => 
                if unsigned(A) >= unsigned(B) then
                    Z <= std_logic_vector(to_signed(1, 32));
                    cond <= '1';  
                else
                    Z <= std_logic_vector(to_signed(0, 32));
                    cond <= '0';  
                end if;
            when "1100" =>
                if A = B then
                    Z <= std_logic_vector(to_signed(1, 32));
                    cond <= '1';  
                else
                    Z <= std_logic_vector(to_signed(0, 32));
                    cond <= '0';  
                end if;
            when "1101" => 
                if A /= B then
                    Z <= std_logic_vector(to_signed(1, 32));
                    cond <= '1';  
                else
                    Z <= std_logic_vector(to_signed(0, 32));
                    cond <= '0';  
                end if;
			when others => Z <= (others => '0');
		end case;
	end process;
 
end behav;
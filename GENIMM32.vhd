library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity GENIMM32 is 
	port(
    	instr : in std_logic_vector(31 downto 0);
        imm32: out STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end GENIMM32;

architecture arc_GENIMM32 of GENIMM32 is
    type FORMAT_RV is ( R_type, I_type, I_type_especial, S_type, SB_type, UJ_type, U_type, UNDEFINED);
    signal instr_format: FORMAT_RV;
    signal funct3: std_logic_vector(2 downto 0);
    signal funct7: std_logic_vector(6 downto 0);
    signal opcode: std_logic_vector(6 downto 0);
    signal extended_opcode: std_logic_vector(7 downto 0);
begin

-- Definição do tipo da instrução 
	opcode <= instr(6 downto 0);
   	funct3 <= instr(14 downto 12);
    funct7 <= instr(31 downto 25);
    extended_opcode <= '0' & opcode;


    DEF_FORMAT: process(instr, extended_opcode) is
    begin
    	case extended_opcode is
            when "00110011" =>
            	instr_format <= R_type;
                
        	when x"03" | x"13" | x"67" =>
            	case funct3 is
               		when "101" => 
                    	instr_format <= I_type_especial;
                        
                    when others => instr_format <= I_type;
                end case;
            when x"23" =>
            	instr_format <= S_type;
                
            when x"63" =>
            	instr_format <= SB_type;
                
            when x"37" =>
            	instr_format <= U_type;
                
            when x"6F" =>
            	instr_format <= UJ_type;
                
            when others => 
            	instr_format <= UNDEFINED;
        end case;
        
        
    end process;

    process(instr_format) is
    begin
        case instr_format is
        	when R_type =>
    	        imm32 <= x"00000000";
                
            when I_type =>
    	        imm32 <= std_logic_vector(resize(signed(instr(31 downto 20)), 32));
                
            when I_type_especial =>
    	        imm32 <= std_logic_vector(resize(signed('0' & instr(24 downto 20)), 32));
                
            when S_type =>
    	        imm32 <= std_logic_vector(resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32));
                
            when SB_type =>
    	        imm32 <= std_logic_vector(resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8)  & '0'), 32));
                
            when U_type =>
    	        imm32 <= std_logic_vector(signed(instr(31 downto 12) & x"000"));
                
            when UJ_type =>
    	        imm32 <= std_logic_vector(resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21)  & '0'), 32));   
            when others =>
                imm32 <= x"00000000";
        end case;
    end process;
end arc_GENIMM32;
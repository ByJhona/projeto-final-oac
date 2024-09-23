LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity ULA is
    PORT (
        ALUOp  : in std_logic_vector(1 downto 0);
        funct3 : in std_logic_vector(2 downto 0);
        funct7 : in std_logic_vector(6 downto 0);
        A      : in std_logic_vector(31 downto 0);
        B      : in std_logic_vector(31 downto 0);
        Z      : out std_logic_vector(31 downto 0);
        cond   : out std_logic
    );
end ULA;

architecture behavior of ULA is
    type operation_t IS (ADD_oper, SUB_oper, AND_oper, OR_oper, XOR_oper, SLL_oper, SRL_oper, SRA_oper, SLT_oper, SLTU_oper, SGE_oper, SGEU_oper, SEQ_oper, SNE_oper, UNDEFINED);
    signal operation : operation_t;
begin

    DEFINE_OPERATION : process (ALUOp, funct3, funct7) is
    begin
        case ALUOp is
            when "00" =>  
                case funct3 is
                    when "000" =>
                        if funct7 = "0000000" then
                            operation <= ADD_oper;  -- ADD
                        elsif funct7 = "0100000" then
                            operation <= SUB_oper;  -- SUB
                        else
                            operation <= UNDEFINED;
                        end if;
                    when others =>
                        operation <= UNDEFINED;
                end case;

            when "01" =>  
                case funct3 is
                    when "111" => operation <= AND_oper;  -- AND
                    when "110" => operation <= OR_oper;   -- OR
                    when "100" => operation <= XOR_oper;  -- XOR
                    when "001" => operation <= SLL_oper;  -- SLL (Shift Left Logical)
                    when "101" =>
                        if funct7 = "0000000" then
                            operation <= SRL_oper;  -- SRL (Shift Right Logical)
                        elsif funct7 = "0100000" then
                            operation <= SRA_oper;  -- SRA (Shift Right Arithmetic)
                        else
                            operation <= UNDEFINED;
                        end if;
                    when others =>
                        operation <= UNDEFINED;
                end case;

            when "10" =>  
                case funct3 is
                    when "010" => operation <= SLT_oper;   -- SLT (Set Less Than, signed)
                    when "011" => operation <= SLTU_oper;  -- SLTU (Set Less Than, unsigned)
                    when "101" => operation <= SGE_oper;   -- SGE (Set Greater Equal, signed)
                    when "110" => operation <= SGEU_oper;  -- SGEU (Set Greater Equal, unsigned)
                    when "001" => operation <= SEQ_oper;   -- SEQ (Set Equal)
                    when "000" => operation <= SNE_oper;   -- SNE (Set Not Equal)
                    when others =>
                        operation <= UNDEFINED;
                end case;

            when others =>
                operation <= UNDEFINED;
        end case;
    end process;

    MAIN : PROCESS (A, B, operation) IS
    BEGIN
    
        cond <= '0';  -- Default condition output

        case operation is
            when ADD_oper =>
                Z <= std_logic_vector(signed(A) + signed(B));
            when SUB_oper =>
                Z <= std_logic_vector(signed(A) - signed(B));
            when AND_oper =>
                Z <= A and B;
            when OR_oper =>
                Z <= A or B;
            when XOR_oper =>
                Z <= A xor B;
            when SLL_oper =>
                Z <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
            when SRL_oper =>
                Z <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
            when SRA_oper =>
                Z <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B(4 downto 0)))));
            when SLT_oper =>
                if signed(A) < signed(B) then
                    Z <= (others => '0');  
                    Z(0) <= '1'; 
                    cond <= '1';
                else
                    Z <= (others => '0');
                end if;
            when SLTU_oper =>
                if unsigned(A) < unsigned(B) then
                    Z <= (others => '0');  
                    Z(0) <= '1'; 
                    cond <= '1';
                else
                    Z <= (others => '0');
                end if;
            when SGE_oper =>
                if signed(A) >= signed(B) then
                    Z <= (others => '0');  
                    Z(0) <= '1'; 
                    cond <= '1';
                else
                    Z <= (others => '0');
                end if;
            when SGEU_oper =>
                if unsigned(A) >= unsigned(B) then
                    Z <= (others => '0');  
                    Z(0) <= '1'; 
                    cond <= '1';
                else
                    Z <= (others => '0');
                end if;
            when SEQ_oper =>
                if A = B then
                    Z <= (others => '0');  
                    Z(0) <= '1'; 
                    cond <= '1';
                else
                    Z <= (others => '0');
                end if;
            when SNE_oper =>
                if A /= B then
                    Z <= (others => '0');  
                    Z(0) <= '1';
                    cond <= '1';
                else
                    Z <= (others => '0');
                end if;
            when others =>
                Z <= (others => '0');  
        end case;
    end process;

end behavior;

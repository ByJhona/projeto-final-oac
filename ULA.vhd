LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity ULA is
    PORT (
        ALUOp : in std_logic_vector(1 downto 0);
        funct3 : in std_logic_vector(2 downto 0);
        funct7 : in std_logic_vector(6 downto 0);
        A : in std_logic_vector(31 downto 0);
        B : in std_logic_vector(31 downto 0);
        Z : out std_logic_vector(31 downto 0);
        cond : out std_logic
    );
end ULA;

architecture behavior of ULA is
    type operation_t IS (ADD_oper, SUB_oper, AND_oper, OR_oper, XOR_oper, SLL_oper, SRL_oper, SRA_oper, SLT_oper, SLTU_oper, SGE_oper, SGEU_oper, SEQ_oper, SNE_oper, UNDEFINED);
    signal operation : operation_t;
begin

    DEFINE_OPERATION : process (ALUOp, funct3, funct7) is
    begin
        case (ALUOp) is
            when "00" => operation <= ADD_oper;
            when "01" => operation <= SUB_oper;
            when "10" => operation <= AND_oper; 

            when others => operation <= UNDEFINED;
        end case;
    end process;

    MAIN : PROCESS (A, B, operation) IS
    BEGIN
        cond <= '0';

        CASE(oper) IS
            WHEN ADD_oper => Z <= STD_LOGIC_VECTOR(signed(A) + signed(B));
            WHEN SUB_oper => Z <= STD_LOGIC_VECTOR(signed(A) - signed(B));
            when others => Z <= x"00000000";
        END CASE;
    END PROCESS;

END arc_ULA;
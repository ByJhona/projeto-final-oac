LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processador IS
        PORT (
                clock : IN STD_LOGIC := 0;
                address : IN STD_LOGIC_VECTOR(31 DOWNTO 0):= (others => '0')
        );

END processador;

ARCHITECTURE behavior OF processador IS

        COMPONENT PC
                PORT (
                        clock : IN STD_LOGIC;
                        enable : STD_LOGIC;
                        endereco_entrada : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        endereco_saida : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0'));
        END COMPONENT;

        COMPONENT MUX01
                PORT (
                        selecao : STD_LOGIC := '0';
                        A :  STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
                        B :  STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
                        saida :  STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0'));
        END COMPONENT;

        COMPONENT CONTROL
                PORT (
                        clock : IN STD_LOGIC;
                        opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
                        EscrevePCCond : OUT STD_LOGIC;
                        EscrevePC : OUT STD_LOGIC;
                        IouD : OUT STD_LOGIC;
                        EscreveMem : OUT STD_LOGIC;
                        LeMem : OUT STD_LOGIC;
                        EscreveIR : OUT STD_LOGIC;
                        OrigPC : OUT STD_LOGIC;
                        ALUOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        OrigAULA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        OrigBULA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        EscrevePCB : OUT STD_LOGIC;
                        EscreveReg : OUT STD_LOGIC;
                        Mem2Reg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
                );
        END COMPONENT;

        COMPONENT MEM
                PORT (
                        clock : IN STD_LOGIC;
                        we : IN STD_LOGIC;
                        re : IN STD_LOGIC;
                        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
                        datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
        END COMPONENT;

        COMPONENT REG_INSTRUCTION
                PORT (
                        clock : IN STD_LOGIC;
                        EscreveIR : IN STD_LOGIC;
                        instrucao : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
                        opcode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
                        rs1 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
                        rs2 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
                        rd : OUT STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
                        imediato : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
                        controle_ULA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); -- rever
        END COMPONENT;
        -- Configuração Controle

        SIGNAL endereco_entrada : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

        SIGNAL EscrevePCCond : STD_LOGIC := '0';
        SIGNAL EscrevePC : STD_LOGIC := '0';
        SIGNAL IouD : STD_LOGIC := '0';
        SIGNAL EscreveMem : STD_LOGIC := '0';
        SIGNAL proc_LeMem : STD_LOGIC := '0';
        SIGNAL EscreveIR : STD_LOGIC := '0';
        SIGNAL OrigPC : STD_LOGIC := '0';
        SIGNAL ALUOp : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
        SIGNAL OrigAULA : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
        SIGNAL OrigBULA : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
        SIGNAL EscrevePCB : STD_LOGIC := '0';
        SIGNAL EscreveReg : STD_LOGIC := '0';
        SIGNAL Mem2Reg : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');

        -- Configurção REG Instruction
        SIGNAL entrada_REG_INSTRUCTION : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL opcode : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
        SIGNAL rs1 : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        SIGNAL rs2 : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        SIGNAL rd : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        SIGNAL imediato : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL controle_ULA : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0'); -- rever

        -- Configuração PC
        SIGNAL enable_PC : STD_LOGIC := '0';
        SIGNAL saida_PC : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

        -- Configuração ULA
        SIGNAL zero : STD_LOGIC := '0';

        -- Configuração MUX01
        signal saida_MUX01 : std_logic_vector(31 downto 0);

        -- Configuração MEM
        SIGNAL endereco_MEM : STD_LOGIC_VECTOR(11 DOWNTO 0);
        SIGNAL entrada_MEM : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL saida_MEM : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
        enable_PC <= (EscrevePC) OR (EscrevePCCond AND zero);

        uut_PC : PC PORT MAP(
                clock,
                enable_PC,
                address,
                saida_PC
        );

        uut_MUX01 : MUX01 PORT MAP(
                IouD ,
		saida_PC,
		x"00000000" ,
		saida_MUX01 
        ); 
        

        endereco_MEM <= saida_MUX01(13 DOWNTO 2);
        uut_MEM : MEM PORT MAP(
                clock,
                EscreveMem,
                proc_LeMem,
                saida_PC(11 DOWNTO 0),
                entrada_MEM,
                saida_MEM
        );

        uut_CONTROL : CONTROL PORT MAP(
                clock,
                opcode,
                EscrevePCCond => EscrevePCCond,
                EscrevePC => EscrevePC,
                IouD => IouD,
                EscreveMem => EscreveMem,
                LeMem => proc_LeMem,
                EscreveIR => EscreveIR,
                OrigPC => OrigPC,
                ALUOp => ALUOp,
                OrigAULA => OrigAULA,
                OrigBULA => OrigBULA,
                EscrevePCB => EscrevePCB,
                EscreveReg => EscreveReg,
                Mem2Reg => Mem2Reg
        );


        uut_REG_INSTRUCTION : REG_INSTRUCTION PORT MAP(
                clock,
                EscreveIR,
                saida_MEM,
                opcode,
                rs1,
                rs2,
                rd,
                imediato,
                controle_ULA -- rever
        );

END;
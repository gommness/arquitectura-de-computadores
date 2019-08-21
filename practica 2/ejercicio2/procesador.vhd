----------------------------------------------------------------------
-- Fichero: procesador.vhd
-- Descripción: procesador segmentado
-- Autores: Javier Gómez Martínez//Carlos Li Hu
-- Asignatura: ARQO 3º grado
-- Grupo de Prácticas: 1311
-- Grupo de Teoría: 130
-- Práctica: 2
-- Ejercicio: 2
----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity procesador is
    Port ( Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
			  
           I_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
			  I_Addr : out  STD_LOGIC_VECTOR (31 downto 0);
              
           D_WrEn : out  STD_LOGIC;
			  D_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           D_Addr : out  STD_LOGIC_VECTOR (31 downto 0);
           D_DataOut : out  STD_LOGIC_VECTOR (31 downto 0));
end procesador;

architecture Behavioral of procesador is
--instanciamos todos los componentes
component ALU
port
(
Op1 : in std_logic_vector(31 downto 0); -- Operando
Op2 : in std_logic_vector(31 downto 0); -- Operando
ALUControl : in std_logic_vector (2 downto 0); --seleccion de operacion

Res : out std_logic_vector(31 downto 0) -- Resultado
);
end component;

component registros --definimos la entidad del registro con sus puertos de entrada y salida
    port (
        Clk : in std_logic; -- Reloj
        NRst : in std_logic; -- Reset asíncrono a nivel bajo
        Wd3 : in std_logic_vector(31 downto 0); -- Dato de entrada RT
        A3 : in std_logic_vector(4  downto 0); -- Dirección A3
        A1 : in std_logic_vector(4 downto 0); -- Dirección A1
        A2 : in std_logic_vector(4 downto 0); -- Dirección A2
        We3 : in std_logic;-- write enable
        
        Rd1 : out std_logic_vector(31 downto 0); -- Salida Rd1
        Rd2 : out std_logic_vector(31 downto 0) -- Salida Rd2
        
    );
end component;

component control 
    Port ( OPCode : in  STD_LOGIC_VECTOR (5 downto 0);
           Funct : in  STD_LOGIC_VECTOR (5 downto 0);
              
           MemToReg : out  STD_LOGIC;
           MemWrite : out  STD_LOGIC; 
			  MemRead : out STD_LOGIC;
           ALUControl : out  STD_LOGIC_VECTOR (2 downto 0); 
           ALUSrc : out  STD_LOGIC; 
           RegDest : out  STD_LOGIC; 
           RegWrite : out  STD_LOGIC; 
           ExtCero : out  STD_LOGIC
			  );
end component;

component BJLU
	Port (
		Clk : in std_logic; -- Reloj
		NRST : in std_logic; --reset
		I_DataIn : in  STD_LOGIC_VECTOR (31 downto 0); -- la instruccion leida de memoria
		nextPC : in  STD_LOGIC_VECTOR (31 downto 0); -- la direccion de instruccion siguiente
      reg1 : in  STD_LOGIC_VECTOR (31 downto 0); -- registro uno para comparacion
      reg2 : in  STD_LOGIC_VECTOR (31 downto 0); -- registro dos para comparacion
      JumpTo : out  STD_LOGIC_VECTOR (31 downto 0); -- salida que indica la direccion a la que se saltara
      PCSrc : out  STD_LOGIC
	);
end component;

component HDU
	Port(
	   A1 : in  STD_LOGIC_VECTOR (4 downto 0);--registro que queremos leer
      A2 : in  STD_LOGIC_VECTOR (4 downto 0);--registro que queremos leer
      EX_RegWrite : in  STD_LOGIC;--boolean de escritura de registro ETAPA EX
      EX_A3 : in  STD_LOGIC_VECTOR (4 downto 0);--registro en el que querriamos escribir ETAPA EX
      MEM_RegWrite : in  STD_LOGIC;--boolean de escritura de registro ETAPA MEM
      MEM_A3 : in  STD_LOGIC_VECTOR (4 downto 0);--registro en el que querriamos escribir
      EX_MemRead : in  STD_LOGIC;--boolean de lectura de memoria
			  
      PC_ChipEnable : out  STD_LOGIC;
		IFID_ChipEnable : out  STD_LOGIC;
		IDEX_ChipEnable : out  STD_LOGIC;
		IFID_Bubble : out STD_LOGIC;
		IDEX_Bubble : out STD_LOGIC;
      EXMEM_ChipEnable : out  STD_LOGIC;
		EXMEM_Bubble: out STD_LOGIC
	);
end component;

component FU
	Port(
		MEM_D_addr : in  STD_LOGIC_VECTOR (31 downto 0);
      Wd3 : in  STD_LOGIC_VECTOR (31 downto 0);
      EX_A1 : in  STD_LOGIC_VECTOR (4 downto 0);
      EX_A2 : in  STD_LOGIC_VECTOR (4 downto 0);
      MEM_A3 : in  STD_LOGIC_VECTOR (4 downto 0);
      MEM_RegWrite : in  STD_LOGIC;
      WB_A3 : in  STD_LOGIC_VECTOR (4 downto 0);
      WB_RegWrite : in  STD_LOGIC;
      MEM_MemRead : in  STD_LOGIC;
      ForwardData1 : out  STD_LOGIC_VECTOR (31 downto 0);
      ForwardData2 : out  STD_LOGIC_VECTOR (31 downto 0);
      ForwardControl1 : out  STD_LOGIC;
      ForwardControl2 : out  STD_LOGIC
	);
end component;

--AQUI EMPEZAMOS A INSTANCIAR LAS SEÑALES ENTRE REGISTROS--

-------------------------------------registro IF-------------------------------------
	--señales entrada
	signal IF_I_Addr : std_logic_vector(31 downto 0);

	--señales intermedias
	signal PC_ChipEnable : std_logic;--indica al pc si puede o no seguir
	signal pcinput : std_logic_vector(31 downto 0);
	signal pcoutput : std_logic_vector(31 downto 0);

	--señales salida
	signal IF_I_DataIn : std_logic_vector(31 downto 0);
	signal IF_nextpc_OUT : std_logic_vector(31 downto 0);
	
	signal IFID_ChipEnable : std_logic;--indica al registro IFID si puede o no seguir
	signal IFID_Bubble : std_logic;

-------------------------------------registro ID-------------------------------------
	--señales entrada
	signal ID_I_DataIn : std_logic_vector(31 downto 0);
	signal ID_nextpc_In : std_logic_vector(31 downto 0);
	signal A1 : std_logic_vector(4 downto 0);
	signal A2 : std_logic_vector(4 downto 0);
	--señales intermedias
	signal OPCode : std_logic_vector(5 downto 0);
	signal Funct : std_logic_vector(5 downto 0);
	--señales salida
	signal ID_RD1 : std_logic_vector(31 downto 0);
	signal ID_RD2 : std_logic_vector(31 downto 0);
	signal ID_cero : std_logic_vector(31 downto 0);
	signal ID_signo : std_logic_vector(31 downto 0);
	signal ID_A3 : std_logic_vector(4 downto 0);
	signal PCSrc : std_logic;
	signal JumpTo : std_logic_vector(31 downto 0);
	--señales Control
	signal ID_ALUControl : std_logic_vector(2 downto 0);
	signal ID_MemToReg: std_logic;
	signal ID_ALUSrc: std_logic;
	signal ID_MemWrite: std_logic;
	signal ID_MemRead: std_logic;
	signal ID_RegDest: std_logic;
	signal ID_RegWrite: std_logic;
	signal ID_ExtCero: std_logic;
	
	signal IDEX_ChipEnable : std_logic;--indica al registro IDEX si puede o no seguir
	signal IDEX_Bubble : std_logic;

-------------------------------------registro EX-------------------------------------
	--señales entrada
	signal EX_D_DataOut : std_logic_vector(31 downto 0);
	signal EX_cero : std_logic_vector(31 downto 0);
	signal EX_signo : std_logic_vector(31 downto 0);
	signal EX_RD1 : std_logic_vector(31 downto 0);
	signal EX_RD2 : std_logic_vector(31 downto 0);
	--señales intermedias
	signal OP1 : std_logic_vector(31 downto 0);
	signal OP2 : std_logic_vector(31 downto 0);
	signal inm : std_logic_vector(31 downto 0);
	signal EX_A3 : std_logic_vector(4 downto 0);
	signal EX_A1 : std_logic_vector(4 downto 0);
	signal EX_A2 : std_logic_vector(4 downto 0);
	--señales salida
	signal EX_D_Addr : std_logic_vector(31 downto 0);


	--señales control
	signal EX_ALUControl : std_logic_vector(2 downto 0);
	signal EX_ALUSrc : std_logic;
	signal EX_MemToReg: std_logic;
	signal EX_MemWrite: std_logic;
	signal EX_MemRead: std_logic;
	signal EX_RegWrite: std_logic;
	signal EX_ExtCero: std_logic;
	
	signal EXMEM_ChipEnable : std_logic;--indica al registro EXMEM si puede o no seguir
	signal EXMEM_Bubble : std_logic;

	--señales FU
	signal ForwardData1 : std_logic_vector(31 downto 0);
	signal ForwardData2 : std_logic_vector(31 downto 0);	
	signal ForwardControl1: std_logic;
	signal ForwardControl2: std_logic;
	
-------------------------------------registro MEM-------------------------------------
	signal MEM_D_addr : std_logic_vector(31 downto 0);
	signal MEM_D_DataOut : std_logic_vector(31 downto 0);

	--señales intermedias
	signal MEM_A3 : std_logic_vector(4 downto 0);

	--señales salida
	signal MEM_D_DataIn : std_logic_vector(31 downto 0);

	--señales control
	signal MEM_MemToReg: std_logic;
	signal MEM_MemWrite: std_logic;
	signal MEM_MemRead: std_logic;
	signal MEM_RegWrite: std_logic;
	
	signal MEMWB_ChipEnable : std_logic;--indica al registro MEMWB si puede o no seguir

-------------------------------------registro WB-------------------------------------
	--señales entrada
	signal WB_D_addr : std_logic_vector(31 downto 0);
	signal WB_D_DataIn : std_logic_vector(31 downto 0);

	--señales salida
	signal Wd3 : std_logic_vector(31 downto 0);
	signal A3 : std_logic_vector(4 downto 0);
	--señales control
	signal WB_MemToReg: std_logic;
	signal WB_RegWrite: std_logic;


begin

--conectamos las señales y sus componentes
MiBJLU: BJLU PORT MAP(
	Clk => Clk,
	NRST => Reset,
	I_DataIn => ID_I_DataIn,
   nextPC => ID_nextpc_IN,
   reg1 => ID_RD1,
   reg2 => ID_RD2,
   JumpTo => JumpTo,
   PCSrc => PCSrc
);

MiALU: ALU PORT MAP(
    Op1 => Op1,
    Op2 => Op2,
    ALUControl => EX_ALUControl,
    Res => EX_D_Addr
);

MiRegistros: registros PORT MAP(
    Clk => Clk,
    NRst => Reset,
    Wd3 => Wd3,
    A3 => A3,
    A2 => A2,
    A1 => A1,
    Rd1 => ID_Rd1,
    Rd2 => ID_Rd2,
    We3 => WB_RegWrite
);

MiControl:control PORT MAP(
    OPCode => OPcode,
    Funct => Funct,
   MemToReg => ID_MemToReg,
   MemWrite => ID_MemWrite,
	MemRead => ID_MemRead,
   ALUControl => ID_ALUControl,
   ALUSrc => ID_ALUSrc,
   RegDest => ID_RegDest,
   RegWrite => ID_RegWrite,
   ExtCero => ID_ExtCero
);

MiHDU:HDU PORT MAP(
	A1 => A1,
   A2 => A2,
   EX_RegWrite => EX_RegWrite,
   EX_A3 => EX_A3,
   MEM_RegWrite => MEM_RegWrite,
   MEM_A3 => MEM_A3,
   EX_MemRead => EX_MemRead,
	
    PC_ChipEnable => PC_ChipEnable,
	 IFID_ChipEnable => IFID_ChipEnable,
	 IDEX_ChipEnable => IDEX_ChipEnable,
    EXMEM_ChipEnable => EXMEM_ChipEnable,
	 IFID_Bubble => IFID_Bubble,
	 IDEX_Bubble => IDEX_Bubble,
	 EXMEM_Bubble => EXMEM_Bubble
);

MiFu:FU PORT MAP(
	MEM_D_addr => MEM_D_Addr,
   Wd3 => Wd3,
   EX_A1 => EX_A1,
   EX_A2 => EX_A2,
   MEM_A3 => MEM_A3,
   MEM_RegWrite => MEM_RegWrite,
   WB_A3 => A3,
   WB_RegWrite => WB_RegWrite,
   MEM_MemRead => MEM_MemRead,
   ForwardData1 => ForwardData1,
   ForwardData2 => ForwardData2,
   ForwardControl1 => ForwardControl1,
   ForwardControl2 => ForwardControl2
	);

--AQUI EMPEZAMOS A CONECTAR LAS SEÑALES ENTRE LOS REGISTROS SINCRONOS

--PROCESO DEL REGISTRO IF/ID
process(clk,Reset)
begin
	if(Reset = '1') then
		ID_nextpc_IN <= (others => '0');
		ID_I_DataIN <= (others => '0');
	elsif(rising_edge(clk)) then
		if (IFID_Bubble = '1') then
			ID_nextpc_IN <= (others => '0');
			ID_I_DataIN <= (others => '0');
		elsif(IFID_ChipEnable = '1') then
			ID_nextpc_IN <= IF_nextpc_OUT;
			ID_I_DataIN <= IF_I_DataIN;
		end if;
	end if;
end process;

--PROCESO DEL REGISTRO ID/EX
process(clk,Reset)
begin
	if(Reset = '1') then
		EX_RD1 <= (others => '0');
		EX_RD2 <= (others => '0');
		EX_A3 <= (others => '0');
		EX_A2 <= (others => '0');
		EX_A1 <= (others => '0');
		EX_cero <= (others => '0');
		EX_signo <= (others => '0');
		--señales de control
		EX_MemToReg <= '0';
		EX_MemWrite <= '0';
		EX_MemRead <= '0';
		EX_ALUControl <= (others => '0');
		EX_ALUSrc <= '0';
		EX_RegWrite <= '0';
		EX_ExtCero <= '0';
	elsif(rising_edge(clk)) then
		if (IDEX_Bubble = '1') then
			EX_RD1 <= (others => '0');
			EX_RD2 <= (others => '0');
			EX_A3 <= (others => '0');
			EX_A2 <= (others => '0');
			EX_A1 <= (others => '0');
			EX_cero <= (others => '0');
			EX_signo <= (others => '0');
			--señales de control
			EX_MemToReg <= '0';
			EX_MemWrite <= '0';
			EX_MemRead <= '0';
			EX_ALUControl <= (others => '0');
			EX_ALUSrc <= '0';
			EX_RegWrite <= '0';
			EX_ExtCero <= '0';
		elsif(IDEX_ChipEnable = '1') then
			EX_RD1 <= ID_RD1;
			EX_RD2 <= ID_RD2;
			EX_A3 <= ID_A3;
			EX_A2 <= A2;
			EX_A1 <= A1;
			EX_cero <= ID_cero;
			EX_signo <= ID_signo;
			--señales de control
			EX_MemToReg <= ID_MemToReg;
			EX_MemWrite <= ID_MemWrite;
			EX_MemRead <= ID_MemRead;
			EX_ALUControl <= ID_ALUControl;
			EX_ALUSrc <= ID_ALUSrc;
			EX_RegWrite <= ID_RegWrite;
			EX_ExtCero <= ID_ExtCero;
		end if;
	end if;
end process;

--PROCESO DEL REGISTRO EX/MEM
process(clk,Reset)
begin
	if(Reset = '1') then
		MEM_D_addr <= (others => '0');
		MEM_D_DataOut <= (others => '0');
		MEM_A3 <= (others => '0');
		--señales de control
		MEM_MemToReg <= '0';
		MEM_MemWrite <= '0';
		MEM_MemRead <= '0';
		MEM_RegWrite <= '0';
	elsif(rising_edge(clk)) then
		if(EXMEM_Bubble = '1') then
			MEM_D_addr <= (others => '0');
			MEM_D_DataOut <= (others => '0');
			MEM_A3 <= (others => '0');
			--señales de control
			MEM_MemToReg <= '0';
			MEM_MemWrite <= '0';
			MEM_MemRead <= '0';
			MEM_RegWrite <= '0';
		elsif(EXMEM_ChipEnable = '1') then
			MEM_D_addr <= EX_D_Addr;
			MEM_D_DataOut <= EX_D_DataOut;
			MEM_A3 <= EX_A3;
			--señales de control
			MEM_MemToReg <= EX_MemToReg;
			MEM_MemWrite <= EX_MemWrite;
			MEM_MemRead <= EX_MemRead;
			MEM_RegWrite <= EX_RegWrite;
		end if;
	end if;
end process;

--PROCESO DEL REGISTRO MEM/WB
process(clk,Reset)
begin
	if(Reset = '1') then
		WB_D_Addr <= (others => '0');
		WB_D_DataIn <= (others => '0');
		A3 <= (others => '0');
		--señales de control
		WB_MemToReg <= '0';
		WB_RegWrite <= '0';
	elsif(rising_edge(clk) and MEMWB_ChipEnable = '1') then
		WB_D_Addr <= MEM_D_Addr;
		WB_D_DataIn <= MEM_D_DataIn;
		A3 <= MEM_A3;
		--señales de control
		WB_MemToReg <= MEM_MemToReg;
		WB_RegWrite <= MEM_RegWrite;
	end if;
end process;

--CONECTAMOS CABLES

--fase IF

	--proceso del PC
	process(clk,Reset)
	begin
		if Reset = '1' then
			pcoutput <= (others => '0');
		elsif (rising_edge(clk) and PC_ChipEnable = '1') then
			pcoutput <= pcinput;
		end if;
	end process;
	
--conexiones
	with PCSrc select
		pcinput <= IF_nextpc_OUT when '0',
		JumpTo when others;
	IF_nextpc_OUT <= pcoutput + 4;
	IF_I_Addr <= pcoutput;
	
--fase ID
	--conexiones
	OPCode <= ID_I_DataIN(31 downto 26);
	Funct <= ID_I_DataIN(5 downto 0);
	A1 <= ID_I_DataIN(25 downto 21);
	A2 <= ID_I_DataIN(20 downto 16);
	with ID_RegDest select
		ID_A3 <= ID_I_DataIN(20 downto 16) when '0',
		ID_I_DataIN(15 downto 11) when others;
	ID_cero(31 downto 16) <= (others => '0');
	ID_cero(15 downto 0) <= ID_I_DataIN(15 downto 0);
	ID_signo(31 downto 16) <= (others => ID_I_DataIN(15));
	ID_signo(15 downto 0) <= ID_I_DataIN(15 downto 0);
	
--fase EX
	--conexiones
	with EX_ExtCero select
		inm <= EX_signo when '0',
		EX_cero when others;
	
	with ForwardControl2 select
		EX_D_DataOut <= ForwardData2 when '1',
		EX_RD2 when others;
		
	with ForwardControl1 select
		OP1 <= ForwardData1 when '1',
		EX_RD1 when others;
	
	with EX_ALUSrc select
		OP2 <= EX_D_DataOut when '0',
		inm when others;
		
--fase MEME
	MEMWB_ChipEnable <= '1';
	
--fase WB
	with WB_MemToReg select
		Wd3 <= WB_D_addr when '0',
		WB_D_DataIn when others;
		
IF_I_DataIn <= I_DataIn;
I_Addr <= IF_I_Addr;
              
D_WrEn <= MEM_MemWrite;
MEM_D_DataIn <= D_DataIn;
D_Addr <= MEM_D_Addr;
D_DataOut <= MEM_D_DataOut;
	
end Behavioral;
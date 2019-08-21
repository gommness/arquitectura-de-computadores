----------------------------------------------------------------------
-- Fichero: procesador.vhd
-- Descripción: el procesador uniciclo
--
-- Autores: Javier Gómez Martínez//Carlos Li Hu
-- Asignatura: arqO grado
-- Grupo de Prácticas: 1311
-- Grupo de Teoría: 130
-- Práctica: 1
-- Ejercicio: 1
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

Res : out std_logic_vector(31 downto 0); -- Resultado
Z : out std_logic -- bandera que se activa si Res = 0
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
           Branch : out  STD_LOGIC; 
           ALUControl : out  STD_LOGIC_VECTOR (2 downto 0); 
           ALUSrc : out  STD_LOGIC; 
           RegDest : out  STD_LOGIC; 
           RegWrite : out  STD_LOGIC; 
           RegToPC : out  STD_LOGIC; 
           ExtCero : out  STD_LOGIC; 
           Jump : out  STD_LOGIC; 
           PCToReg : out  STD_LOGIC); 
end component;

--registro IFID
signal I_DataInIF : std_logic_vector(31 downto 0);
signal I_DataInID : std_logic_vector(31 downto 0);
signal nextPCID : std_logic_vector(31 downto 0);
signal nextPCIF : std_logic_vector(31 downto 0);

--registro IDEX


--señales ALUMIPS
signal Op1, Op2, Res: std_logic_vector (31 downto 0);
signal ALUControl: std_logic_vector (2 downto 0);
signal Z: std_logic;

--señales Regsmips
signal Wd3 : std_logic_vector(31 downto 0);
signal A3 : std_logic_vector(4  downto 0);
signal A2 : std_logic_vector(4  downto 0);
signal A1 : std_logic_vector(4  downto 0);
signal Rd1 : std_logic_vector(31 downto 0);
signal Rd2 : std_logic_vector(31 downto 0);
signal We3: std_logic;

--señales Unidad de Control
signal OPCode : STD_LOGIC_VECTOR (5 downto 0);
signal Funct :  STD_LOGIC_VECTOR (5 downto 0);

signal MemToReg :  STD_LOGIC;
signal Branch :  STD_LOGIC; 
signal ALUSrc :  STD_LOGIC; 
signal RegDest : STD_LOGIC; 
signal RegWrite :  STD_LOGIC; 
signal RegToPC :  STD_LOGIC; 
signal ExtCero :  STD_LOGIC; 
signal Jump : STD_LOGIC; 
signal PCToReg :  STD_LOGIC; 
signal MemWrite: STD_LOGIC;

--señales auxiliares   se pueden encontrar bien localizadas en la imagen proporcionadoa aparte
signal branchpc,pcinput,cero,jumppc,nextpc,branchjump,signo,inm,carlos,pcoutput: STD_LOGIC_VECTOR (31 downto 0);
signal inmjump: STD_LOGIC_VECTOR (27 downto 0);
signal javi: STD_LOGIC_VECTOR (4 downto 0);
signal PCSrc: STD_LOGIC;

begin

--conectamos las señales y sus componentes
MiALU: ALU PORT MAP(
    Op1 => Op1,
    Op2 => Op2,
    ALUControl => ALUControl,
    Res => Res,
    Z => Z
);

MiRegistros: registros PORT MAP(
    Clk => Clk,
    NRst => Reset,
    Wd3 => Wd3,
    A3 => A3,
    A2 => A2,
    A1 => A1,
    Rd1 => Rd1,
    Rd2 => Rd2,
    We3 => We3
);

MiControl:control PORT MAP(
    OPCode => OPcode,
    Funct => Funct,
   MemToReg => MemToReg,
   MemWrite => MemWrite,
   Branch => Branch,
   ALUControl => ALUControl,
   ALUSrc => ALUSrc,
   RegDest => RegDest,
   RegWrite => RegWrite,
   RegToPC => RegToPC,
   ExtCero => ExtCero,
   Jump => Jump,
   PCToReg => PCToReg
);
--hacemos el registro del pc
process(clk,Reset)
begin
if Reset='1' then --reset a nivel alto
    pcoutput <= (others =>'0');
elsif rising_edge(clk) then
    pcoutput <= pcinput;    
end if; 
end process;
--asignamos el valor a las salidas dependiendo de las señales segun el esquema del microprocesador
We3 <= RegWrite;
D_WrEn <= MemWrite;
Op1 <= Rd1;
OPCode <= I_DataIn(31 downto 26);
Funct <= I_DataIn(5 downto 0);   
D_Addr <= res;
D_DataOut <= Rd2;
I_Addr<= pcoutput;
A2 <= I_DataIn(20 downto 16);
A1 <= I_DataIn(25 downto 21);
nextpc <= pcoutput + 4;
PCSrc <= Branch and Z;
branchjump <= nextpc + (signo(29 downto 0) & "00");
inmjump <= I_DataIn(25 downto 0) & "00";

signo(31 downto 16) <= (others => I_DataIn(15));
signo(15 downto 0) <= I_DataIn(15 downto 0);
cero(31 downto 16) <= (others => '0');
cero(15 downto 0) <= I_DataIn(15 downto 0);


--aquí empiezan a crearse los multiplexores
with PCSrc select                              --este multiplexor decide si se produce un salto por branch o no
    branchpc <= branchjump when '1',
                    nextpc when others;

with Jump select                               --decide si se produce un salto
    jumppc <= branchpc when '0',
        nextpc(31 downto 28) & inmjump when others;

with RegtoPC select                             --decide si el contenido de un registro va al pc
    pcinput<=jumppc when '0',
        op1 when others;

with RegDest select                             --decide la direccion del registro de destino
    javi<=I_DataIn(20 downto 16) when '0',
        I_DataIn(15 downto 11) when others;
    
with PCtoReg select
    A3<=javi when '0',                          --decide si se escribe el pc+4 en un registro
        "11111" when others;

with ExtCero select                             --decide si se extiende en signo o en ceros el dato inmediato
    inm<= signo when '0',
        cero  when others;
with ALUSrc select                              --decide si el segundo operando es un dato inmediato o el contenido de un registro
    op2<= RD2 when '0',
        inm when others;

with MemToReg select                            --decide si se escribe en el registro algo de la memoria
    carlos<= res when '0',
        D_DataIn when others;

with PCToReg select                             --decide si se escribe la direccion del pc en un registro
    wd3<= carlos when '0',
        nextpc when others;

end Behavioral;





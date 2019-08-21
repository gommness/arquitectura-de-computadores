----------------------------------------------------------------------
-- Fichero: ALU.vhd
-- Descripción: unidad aritmetica de operaciones
-- Autores: Javier Gómez Martínez//Carlos Li Hu
-- Asignatura: ARQO 3º grado
-- Grupo de Prácticas: 1311
-- Grupo de Teoría: 130
-- Práctica: 1
-- Ejercicio: 2
----------------------------------------------------------------------


library IEEE; --añadimos las librerías
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_signed.ALL; 

entity ALU is --definimos la entidad ALU
	port (
		Op1 : in std_logic_vector(31 downto 0); -- Operando
		Op2 : in std_logic_vector(31 downto 0); -- Operando
		ALUControl : in std_logic_vector (2 downto 0); --seleccion de operacion
		Res : out std_logic_vector(31 downto 0) -- Resultado
	);
end ALU; --Terminamos la definicion

architecture Simple of ALU is --definimos el comportamiento de ALUSUMA
signal slt : std_logic_vector(31 downto 0); -- valor que devuelve la operacion set less than
signal resaux : std_logic_vector(31 downto 0);--resaux se utiliza como señal auxiliar para escribir en RES y leer desde Z

begin

with ALUControl select 		--Hacemos un with select con el ALUControl para elegir la operación
resaux <= Op1 + Op2 when "010", -- SUMA BITCH
		 Op1 - Op2 when "110", -- RESTA BITCH
		 Op1 or Op2 when "001", -- OR BITCH
		 Op1 xor Op2 when "011", -- XOR BITCH
		 slt when "111", --slt es una operación que se hace en un proceso a parte
		  -- SLT BITCH
		 Op1 and Op2 when "100", -- AND BITCH
		 Op2(15 downto 0) & "0000000000000000" when others; -- LUI BITCH
		 
Res <= resaux;
		 
process(Op1, Op2)--definimos slt
begin
if Op1(31)/= Op2(31) then -- si los operandos tienen diferente signo entonces dependiendo de cual sea 1 slt toma 0 o 1
	if Op1(31)= '1' then slt <= (31 downto 1 => '0', 0 => '1');
	else slt <= (others => '0');
	end if;
else  --si son del mismo signo se restan, y si queda un numero negativo entonces slt se cumple y se pone a 1 ya que op1<op2
   if conv_integer(Op1-Op2)<0 then
		slt <= (31 downto 1 => '0', 0 => '1');
	else slt <= (others => '0');
	end if;	
end if;
end process;		 
		 

end Simple; -- THE END


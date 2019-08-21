----------------------------------------------------------------------
-- Fichero: BJLU.vhd
-- Descripción: unidad de calculo de saltos
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

entity BJLU is
    Port ( 
			  clk : in std_logic; -- clock
			  NRST : in std_logic; --reset
			  I_DataIn : in  STD_LOGIC_VECTOR (31 downto 0); -- la instruccion leida de memoria
           nextPC : in  STD_LOGIC_VECTOR (31 downto 0); -- la direccion de instruccion siguiente
           reg1 : in  STD_LOGIC_VECTOR (31 downto 0); -- registro uno para comparacion
           reg2 : in  STD_LOGIC_VECTOR (31 downto 0); -- registro dos para comparacion
           JumpTo : out  STD_LOGIC_VECTOR (31 downto 0); -- salida que indica la direccion a la que se saltara
           PCSrc : out  STD_LOGIC); -- flag que indicara si se ha de tomar salto o no
end BJLU;

architecture Behavioral of BJLU is

signal signo : STD_LOGIC_VECTOR(31 downto 0); -- extiende el signo del dato inmediato de la instruccion
signal condition : STD_LOGIC; -- almacena un valor que indicara si la condicion se cumple o no

begin


signo(31 downto 18) <= (others => I_DataIn(15));
signo(17 downto 0) <= I_DataIn(15 downto 0) & "00";


condition <= '1' when reg1 = reg2
else '0';

process(clk, NRST)
begin
	if NRST = '1' then
		PCSrc <= '0';
		JumpTo <= (others => '0');
	elsif rising_edge(clk) then

		
		--Primero debemos identificar si la instrucción es un jup, un branch o una que no implique salto
		-- PCSRC <= 1 en caso de que se haga algun salto
		-- PCSRC <= 0 en caso de que NO se haga ningun salto
		if I_DataIn(31 downto 26) = "000010" or (I_DataIn(31 downto 26) = "000100" and condition = '1') then
			PCSrc <= '1';
		else
			PCSrc <= '0';
		end if;
		
		-- primer caso, el salto es un jump
		if I_DataIn(31 downto 26) = "000010" then
		JumpTo <= (nextPC (31 downto 28) & I_DataIn (25 downto 0) & "00");
		--siguiente caso, el salto es un branch (beq)
		else
		JumpTo <= nextpc + signo;
		end if;
	end if;
end process;

end Behavioral;


----------------------------------------------------------------------
-- Fichero: HDU.vhd
-- Descripción: Hazard Detection Unit
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

entity HDU is
    Port ( 
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
			  EXMEM_Bubble: out STD_LOGIC);
end HDU;

architecture Behavioral of HDU is
begin

	--LOAD implica MEM_MemRead = 1 && MEM_RegWrite = 1
	
	process(A1, A2, EX_RegWrite, EX_A3, MEM_RegWrite, MEM_A3, EX_MemRead)
	begin
			--Ademas, ChipEnable de EXMEM a 0 en caso de que el riesgo en MEM sea por un LOAD
			if(((EX_A3 = A1) or (EX_A3 = A2)) and EX_RegWrite = '1' and EX_A3 /= "00000" and EX_MemRead = '1') then
				PC_ChipEnable <= '0';
				IFID_ChipEnable <= '0';
				IDEX_ChipEnable <= '0';
				IFID_Bubble <= '0';
				IDEX_Bubble <= '1';
			else 
				PC_ChipEnable <= '1';
				IFID_ChipEnable <= '1';
				IDEX_ChipEnable <= '1';
				IFID_Bubble <= '0';
				IDEX_Bubble <= '0';
			end if;
		--En caso de que no haya riesgo alguno, los ChipEnables permaneceran a 1
	end process;
	
	EXMEM_ChipEnable <= '1';
	EXMEM_Bubble <= '0';

end Behavioral;


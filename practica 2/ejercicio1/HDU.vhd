----------------------------------------------------------------------
-- Fichero: HDU.vhd
-- Descripción: Hazard Detection Unit
-- Autores: Javier Gómez Martínez//Carlos Li Hu
-- Asignatura: ARQO 3º grado
-- Grupo de Prácticas: 1311
-- Grupo de Teoría: 130
-- Práctica: 2
-- Ejercicio: 1
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
           MEM_MemRead : in  STD_LOGIC;--boolean de lectura de memoria
			  
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
	
	process(A1, A2, EX_RegWrite, EX_A3, MEM_RegWrite, MEM_A3, MEM_MemRead)
	begin
		--ChipEnables de PC, IFID, IDEX a 0 en caso de que haya algún riesgo
			if((((EX_A3 = A1) or (EX_A3 = A2)) and EX_A3 /= "00000" and EX_RegWrite = '1')--riesgo en EX
				or (((MEM_A3 = A1) or (MEM_A3 = A2)) and MEM_A3 /= "00000" and MEM_RegWrite = '1')) then--riesgo en MEM
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
			--Ademas, ChipEnable de EXMEM a 0 en caso de que el riesgo en MEM sea por un LOAD
			if(((MEM_A3 = A1) or (MEM_A3 = A2)) and MEM_RegWrite = '1' and MEM_A3 /= "00000" and MEM_MemRead = '1') then
				EXMEM_ChipEnable <= '0';
				EXMEM_Bubble <= '1';
			else 
				EXMEM_ChipEnable <= '1';
				EXMEM_Bubble <= '0';
			end if;
		--En caso de que no haya riesgo alguno, los ChipEnables permaneceran a 1
	end process;

end Behavioral;


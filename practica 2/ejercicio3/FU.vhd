----------------------------------------------------------------------
-- Fichero: FU.vhd
-- Descripción: unidad de forwarding de datos
-- Autores: Javier Gómez Martínez//Carlos Li Hu
-- Asignatura: ARQO 3º grado
-- Grupo de Prácticas: 1311
-- Grupo de Teoría: 130
-- Práctica: 2
-- Ejercicio: 3
----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity FU is
    Port ( MEM_D_addr : in  STD_LOGIC_VECTOR (31 downto 0);
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
           ForwardControl2 : out  STD_LOGIC);
end FU;

architecture Behavioral of FU is
begin

process(EX_A1, EX_A2, MEM_A3, WB_A3, MEM_RegWrite, WB_RegWrite, MEM_MemRead, MEM_D_addr, Wd3)
begin

	--CASO FORWARDING A A1
	if(EX_A1 = WB_A3 and WB_RegWrite = '1' and WB_A3 /= "00000") then --caso en el que forwardeamos dato desde WB
		ForwardData1 <= Wd3;
		ForwardControl1 <= '1';
	else
		ForwardData1 <= (others => '0');
		ForwardControl1 <= '0';
	end if;
	
	if(EX_A1 = MEM_A3 and MEM_RegWrite = '1' and MEM_MemRead = '0' and MEM_A3 /= "00000") then --caso en el que forwardeamos desde EX y NO es lw
		ForwardData1 <= MEM_D_addr;
		ForwardControl1 <= '1';
	elsif(EX_A1 /= WB_A3 or WB_RegWrite /= '1' or WB_A3 = "00000") then
		ForwardData1 <= (others => '0');
		ForwardControl1 <= '0';
	end if;
	
	--CASO FORWARDING A A2
	if(EX_A2 = WB_A3 and WB_RegWrite = '1' and WB_A3 /= "00000") then --caso en el que forwardeamos dato desde WB
		ForwardData2 <= Wd3;
		ForwardControl2 <= '1';
	else
		ForwardData2 <= (others => '0');
		ForwardControl2 <= '0';
	end if;
	
	if(EX_A2 = MEM_A3 and MEM_RegWrite = '1' and MEM_MemRead = '0' and MEM_A3 /= "00000") then --caso en el que forwardeamos desde EX y NO es lw
		ForwardData2 <= MEM_D_addr;
		ForwardControl2 <= '1';
	elsif(EX_A2 /= WB_A3 or WB_RegWrite /= '1' or WB_A3 = "00000") then
		ForwardData2 <= (others => '0');
		ForwardControl2 <= '0';
	end if;
	
end process;

end Behavioral;


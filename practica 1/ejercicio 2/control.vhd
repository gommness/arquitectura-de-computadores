----------------------------------------------------------------------
-- Fichero: control.vhd
-- Descripción: Unidad de Control
-- Autores: Javier Gómez Martínez//Carlos Li Hu
-- Asignatura: ARQO 3º grado
-- Grupo de Prácticas: 1311
-- Grupo de Teoría: 130
-- Práctica: 1
-- Ejercicio: 2
----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control is
    Port ( OPCode : in  STD_LOGIC_VECTOR (5 downto 0);
           Funct : in  STD_LOGIC_VECTOR (5 downto 0);
           MemToReg : out  STD_LOGIC;
           MemWrite : out  STD_LOGIC; 
           ALUControl : out  STD_LOGIC_VECTOR (2 downto 0); 
           ALUSrc : out  STD_LOGIC; 
           RegDest : out  STD_LOGIC; 
           RegWrite : out  STD_LOGIC; 
           ExtCero : out  STD_LOGIC); 
end control;

architecture Behavioral of control is -- de acuerdo a los requisitos de las instrucciones damos valores a las señales de control
begin
MemToReg <= '1' when OPCode = "100011" -- lw
else '0';
MemWrite <= '1' when OPCode = "101011" -- sw
else '0';
RegDest <= '1' when OPCode = "000000" and Funct /= "000000" -- R-Type
else '0';

-- Nop, al ser 0x0000000 esta implementado con todas las señales a 0

ALUControl <= "010" when (OPCode = "000000" and Funct = "100000") or OPCode = "001000" or OPCode = "100011" or OPCode = "101011" -- ADD/ADDI/SW/LW
else "110" when (OPCode = "000000" and Funct = "100010") or OPCode = "000100" -- SUB/BEQ
else "001" when (OPCode = "000000" and Funct = "100101") or OPCode = "001101"  -- OR/ORI
else "011" when (OPCode = "000000" and Funct = "100110") or OPCode = "001110" -- XOR/XORI
else "111" when (OPCode = "000000" and Funct = "101010") or OPCode = "001010"  -- SLT/SLTI
else "100" when (OPCode = "000000" and Funct = "100100") --AND
else "101"; --LUI


ALUSrc <= '1' when OPCode = "100011" or OPCode = "101011" or OPCode = "001000" or OPCode = "001101"
or OPCode = "001110" or OPCode = "001010" or OPCode = "001111" --lw/sw/jr/ori/xori/slti/lui
else '0';

ExtCero <= '1' when OPCode = "001101" or OPCode = "001110" --ori/xori
else '0';

RegWrite <= '0' when OPCode = "101011" or OPCode = "000100" or OPCode = "000010"
or (OPCode = "000000" and Funct = "001000") --sw/beq/j/jr
else '1';

end Behavioral;


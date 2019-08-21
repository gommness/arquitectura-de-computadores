----------------------------------------------------------------------
-- Fichero: FBJLU.vhd
-- Descripción: unidad de logica de saltos con prevencion de riesgos
-- Autores: Javier Gómez Martínez//Carlos Li Hu
-- Asignatura: ARQO 3º grado
-- Grupo de Prácticas: 1311
-- Grupo de Teoría: 130
-- Práctica: 2
-- Ejercicio: 3
----------------------------------------------------------------------

entity FBJLU is
    Port ( A1 : in  STD_LOGIC_VECTOR (4 downto 0);
           A2 : in  STD_LOGIC_VECTOR (4 downto 0);
           EX_A3 : in  STD_LOGIC_VECTOR (4 downto 0);
           MEM_A3 : in  STD_LOGIC_VECTOR (4 downto 0);
           EX_RegWrite : in  STD_LOGIC;
           Mem_RegWrite : in  STD_LOGIC;
           Mem_MemRead : in  STD_LOGIC;
           RD1 : in  STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in  STD_LOGIC_VECTOR (31 downto 0);
           FWD : in  STD_LOGIC_VECTOR (31 downto 0);
           NextPC : in  STD_LOGIC_VECTOR (31 downto 0);
           I_DataIN : in  STD_LOGIC_VECTOR (31 downto 0);
			  
           PCSrc : out  STD_LOGIC;
           JumpTo : out  STD_LOGIC_VECTOR (31 downto 0);
           BubbleIFID : out  STD_LOGIC;
           BubbleIDEX : out  STD_LOGIC;
           ChipEnIFID : out  STD_LOGIC;
           ChipEnPC : out  STD_LOGIC);
end FBJLU;

architecture Behavioral of FBJLU is
	signal signo : STD_LOGIC_VECTOR(31 downto 0);
begin

signo(31 downto 18) <= (others => I_DataIn(15));
signo(17 downto 0) <= I_DataIn(15 downto 0) & "00";

process(I_DataIN, nextPC, EX_A3, MEM_A3, A1, A2, EX_RegWrite, MEM_RegWrite, MEM_MemRead, FWD, RD1, RD2)
	variable data1 : STD_LOGIC_VECTOR(31 downto 0);
	variable data2 : STD_LOGIC_VECTOR(31 downto 0);
begin

	if(A1 = MEM_A3 and MEM_A3 /= "00000" and MEM_RegWrite = '1' and MEM_MemRead = '0') then
		data1 := FWD;
	else
		data1 := RD1;
	end if;
	if(A2 = MEM_A3 and MEM_A3 /= "00000" and MEM_RegWrite = '1' and MEM_MemRead = '0') then
		data2 := FWD;
	else
		data2 := RD2;
	end if;

	if(I_DataIN(31 downto 26) = "000010") then --CASO JUMP
		PCSrc <= '1';
		JumpTo <= nextPC (31 downto 28) & I_DataIn (25 downto 0) & "00";
		BubbleIFID <= '1';
		BubbleIDEX <= '0';
		ChipEnIFID <= '1';
		ChipEnPC <= '1';
	elsif(I_DataIN(31 downto 26) = "000100") then--CASO BRANCH
		if(((A1 = EX_A3 or A2 = EX_A3) and EX_A3 /= "00000" and EX_RegWrite = '1')--cualquier instruccion con riesgo en etapa EX
			or ((A1 = MEM_A3 or A2 = MEM_A3) and MEM_A3 /= "00000" and MEM_RegWrite = '1' and MEM_MemRead = '1'))--lw con riesgo en etapa MEM
				then
				BubbleIDEX <= '1';
				ChipEnIFID <= '0';
				ChipEnPc <= '0';
		elsif(data1 = data2) then
			PCSrc <= '1';
			JumpTo <= signo + NextPC - 4;
			BubbleIFID <= '1';
			BubbleIDEX <= '0';
			ChipEnIFID <= '1';
			ChipEnPC <= '1';
		else
			PCSrc <= '0';
			JumpTo <= (others => '0');
			BubbleIFID <= '0';
			BubbleIDEX <= '0';
			ChipEnIFID <= '1';
			ChipEnPC <= '1';
		end if;
		
	else--caso de que no sea nada
		PCSrc <= '0';
		JumpTo <= (others => '0');
		BubbleIFID <= '0';
		BubbleIDEX <= '0';
		ChipEnIFID <= '1';
		ChipEnPC <= '1';
	end if;
end process;

end Behavioral;


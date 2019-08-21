----------------------------------------------------------------------
-- Fichero: registros.vhd
-- Descripci�n: banco de registros de proposito general
-- Autores: Javier G�mez Mart�nez//Carlos Li Hu
-- Asignatura: E.C. 1� grado
-- Grupo de Pr�cticas: 2102
-- Grupo de Teor�a: 210
-- Pr�ctica: 3
-- Ejercicio: 2
----------------------------------------------------------------------


library IEEE; --a�adimos las librer�as
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity registros is --definimos la entidad del registro con sus puertos de entrada y salida
	port (
		Clk : in std_logic; -- Reloj
		NRst : in std_logic; -- Reset as�ncrono a nivel bajo
		Wd3 : in std_logic_vector(31 downto 0); -- Dato de entrada RT
		A3 : in std_logic_vector(4  downto 0); -- Direcci�n A3
		A1 : in std_logic_vector(4 downto 0); -- Direcci�n A1
		A2 : in std_logic_vector(4 downto 0); -- Direcci�n A2
		Rd1 : out std_logic_vector(31 downto 0); -- Salida Rd1
		Rd2 : out std_logic_vector(31 downto 0); -- Salida Rd2
		We3 : in std_logic-- write enable
	); 
end registros;

architecture Practica of registros is --definimos el comportamiento del registro

	-- Tipo para almacenar los registros
	type regs_t is array (0 to 31) of std_logic_vector(31 downto 0);

	-- Esta es la se�al que contiene los registros. El acceso es de la
	-- siguiente manera: regs(i) acceso al registro i, donde i es
	-- un entero. Para convertir del tipo std_logic_vector a entero se
	-- hace de la siguiente manera: conv_integer(slv), donde
	-- slv es un elemento de tipo std_logic_vector

	-- Registros inicializados a '0' 
	-- NOTA: no cambie el nombre de esta se�al.
	signal regs : regs_t;

begin  -- PRACTICA

	------------------------------------------------------
	-- Escritura del registro 
	------------------------------------------------------
process(Clk,NRst) --Reset asincrono
	begin
		if NRst= '1' then --reset a nivel alto
			BUCLE: for i in 0 to 31 loop --ponemos los 32 registros de 32 bits a 0 cuando el reset est� activo
			regs(i) <= (others => '0');
			end loop;
		
		elsif falling_edge(Clk) then --cuando halla un flanco del reloj de bajada
			if We3 = '1' then
			regs(conv_integer(A3)) <= Wd3;
			end if;
			--convertimos a un numero entero el valor A3 (que es un std_logic_vector)
			--despues, al registro de ese numero (que representa una direccion),
			--le asignamos el valor de escritura Wd3
		end if; --Nintendo 27 power!
		
	
	
	end process;
	------------------------------------------------------
	-- Lectura del registro RS
	------------------------------------------------------
	
	Rd1 <= regs(conv_integer(A1)) when conv_integer(A1) /= 0  --easy peasy
	else (others => '0');
	Rd2 <= regs(conv_integer(A2)) when conv_integer(A2) /= 0  --easy peasy
	else (others => '0');
	-- cuando la direccion no sea R0(el numero en binario A2 y A1 respectivamente no representen 0 en decimal),
	-- entonces a Rd1 y Rd2, las salidas, se le asignar�n a los  buses de bits que haya en los registros seleccionados
	-- en cualquier otro caso, es decir cuando se lea de la direcci�n 0,
	-- las salidas valdr�n 0



end Practica;

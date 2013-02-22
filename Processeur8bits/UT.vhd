----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:13:34 02/14/2013 
-- Design Name: 
-- Module Name:    UT - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UT is
	Port (	H					: in	STD_LOGIC;								-- Horloge
				RST				: in	STD_LOGIC;								-- Reset asynchrone du composant
				CE					: in  STD_LOGIC;								-- Clock Enable, actication du composant
				Sel_UAL			: in  STD_LOGIC;								-- Sélection de l'oppération de l'UAL, 0:NOR 1:ADD
				Init_RegCarry	: in  STD_LOGIC;								-- Initialisation de la FF
				Load_RegCarry	: in  STD_LOGIC;								-- Chargement de la FF
				Load_RegData	: in  STD_LOGIC;								-- Chargement du reg de donnée (provenance mémoire)
				Load_RegAccu	: in  STD_LOGIC;								-- Chargement de l'accu (provenance UAL)
				From_Mem			: in  STD_LOGIC_VECTOR(7 downto 0);		-- Donnée de la mémoire vers le reg Data
				To_Mem			: out	STD_LOGIC_VECTOR(7 downto 0);		-- Donnée de l'accu vers la mémoire
				Carry_Out		: out	STD_LOGIC);								-- Retenue de l'UAL
end UT;

architecture Behavioral of UT is




component UAL
	Port (Sel_UAL			: in	STD_LOGIC;							-- 0:NOR, 1:ADD
			Data_In_ACCU	: in	STD_LOGIC_VECTOR(7 downto 0); -- Valeur provenant de l'ACCU
			Data_In_MEM		: in	STD_LOGIC_VECTOR(7 downto 0); -- Valeur provenant du registre data
			Data_Out			: out	STD_LOGIC_VECTOR(7 downto 0); -- Valeur calculée
			Carry_Out		: out STD_LOGIC);							-- Retenue de l'oppération
end component;


component Reg8bits
	Port (H			: in	STD_LOGIC;							-- Horloge
			RST		: in	STD_LOGIC;							-- Reset asynchrone du composant
			CE			: in  STD_LOGIC;							-- Clock Enable, actication du composant
			Load		: in  STD_LOGIC;							-- Chargement de la valeur d'entrée
			Data_In	: in	STD_LOGIC_VECTOR(7 downto 0);	-- Valeur d'entrée
			Data_Out	: out	STD_LOGIC_VECTOR(7 downto 0));-- Valeur de sortie
end component;


component FF1bit
	Port (H			: in	STD_LOGIC;	-- Horloge
			RST		: in	STD_LOGIC;	-- Reset asynchrone du composant
			CE			: in  STD_LOGIC;	-- Clock Enable, actication du composant
			Init		: in	STD_LOGIC;	-- Init, initialisation synchrone
			Load		: in  STD_LOGIC;	-- Chargement de la valeur d'entrée
			Data_In	: in	STD_LOGIC;	-- Valeur d'entrée
			Data_Out	: out	STD_LOGIC);	-- Valeur de sortie
end component;



signal RegData_out	: STD_LOGIC_VECTOR(7 downto 0);
signal UALcarry_out	: STD_LOGIC;
signal UALdata_out	: STD_LOGIC_VECTOR(7 downto 0);
signal RegAccu_out	: STD_LOGIC_VECTOR(7 downto 0);

begin

	To_Mem <= RegAccu_out;

	RegData : Reg8bits port map (
		H,
		RST,
		CE,
		Load_RegData,
		From_Mem,
		RegData_out);
	
	
	RegAccu : Reg8bits port map (
		H,
		RST,
		CE,
		Load_RegAccu,
		UALdata_out,
		RegAccu_out);
		
		
	FFcarry : FF1bit port map (
		H,
		RST,
		CE,
		Init_RegCarry,
		Load_RegCarry,
		UALcarry_out,
		Carry_Out);
		
		
	UT_UAL : UAL port map (
		Sel_UAL,
		RegAccu_out,
		RegData_out,
		UALdata_out,
		UALcarry_out);

end Behavioral;


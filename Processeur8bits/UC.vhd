----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:13:46 02/14/2013 
-- Design Name: 
-- Module Name:    UC - Behavioral 
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

entity UC is
	Port (	H						: in	STD_LOGIC;							-- Horloge
				RST					: in	STD_LOGIC;							-- Reset asynchrone du composant
				CE						: in  STD_LOGIC;							-- Clock Enable, actication du composant
				Mem_From				: in	STD_LOGIC_VECTOR(7 downto 0);	-- Data lue de la mémoire
				Mem_Addr				: out	STD_LOGIC_VECTOR(5 downto 0);	-- Adresse mémoire à lire/écrire
				Mem_Enable			: out STD_LOGIC;							-- Autorisation mémoire
				Mem_RW				: out STD_LOGIC;							-- Lecture(0) ou écriture (1) mémoire
				UT_Carry				: in	STD_LOGIC;							-- Retenue de l'UAL
				UT_Sel_UAL			: out STD_LOGIC;							-- Choix oppération UAL, 0:NOR 1:ADD
				UT_Load_RegData	: out STD_LOGIC;							-- Chargement registre data UT (depuis mémoire)
				UT_Load_RegAccu	: out STD_LOGIC;							-- Chargement registre Accu UT (depuis UAL)
				UT_Load_RegCarry	: out STD_LOGIC;							-- Chargement registre Carry (depuis UAL)
				UT_Init_Carry		: out STD_LOGIC);							-- Init de la carry	
end UC;

architecture Behavioral of UC is

	component Reg8bits
	Port (H			: in	STD_LOGIC;							-- Horloge
			RST		: in	STD_LOGIC;							-- Reset asynchrone du composant
			CE			: in  STD_LOGIC;							-- Clock Enable, actication du composant
			Load		: in  STD_LOGIC;							-- Chargement de la valeur d'entrée
			Data_In	: in	STD_LOGIC_VECTOR(7 downto 0);	-- Valeur d'entrée
			Data_Out	: out	STD_LOGIC_VECTOR(7 downto 0));-- Valeur de sortie
	end component;
	
	
	component Cpt6bits
	Port (H			: in  STD_LOGIC;
			RST		: in  STD_LOGIC;
			CE			: in  STD_LOGIC;
			Data_in	: in  STD_LOGIC_VECTOR (5 downto 0);
			Enable	: in  STD_LOGIC;
			Init		: in  STD_LOGIC;
			Load		: in  STD_LOGIC;
			Data_out	: out  STD_LOGIC_VECTOR (5 downto 0));
	end component;
	
	
	component MUX6bits
	Port (Data_In_0 : in  STD_LOGIC_VECTOR (5 downto 0);
			Data_In_1 : in  STD_LOGIC_VECTOR (5 downto 0);
			Channel   : in  STD_LOGIC;
			Data_Out  : out STD_LOGIC_VECTOR (5 downto 0));
	end component;


	component FSM
	Port (Clk		: in   STD_LOGIC;
			Rst		: in   STD_LOGIC;
			CE			: in   STD_LOGIC;
			Carry		: in   STD_LOGIC;
			Code_Op	: in   STD_LOGIC_VECTOR (1 downto 0);
			A			: out  STD_LOGIC;
			B			: out  STD_LOGIC;
			C			: out  STD_LOGIC;
			D			: out  STD_LOGIC;
			E			: out  STD_LOGIC;
			F			: out  STD_LOGIC;
			G			: out  STD_LOGIC;
			H			: out  STD_LOGIC;
			I			: out  STD_LOGIC;
			J			: out  STD_LOGIC;
			K			: out  STD_LOGIC;
			L			: out  STD_LOGIC);
	end component;


	signal Instruction	: STD_LOGIC_VECTOR(7 downto 0);
	signal Cpt_DataOut	: STD_LOGIC_VECTOR(5 downto 0);
	signal Cpt_Enable		: STD_LOGIC;
	signal Cpt_Init		: STD_LOGIC;
	signal Cpt_Chargement: STD_LOGIC;
	signal MUX_Sel			: STD_LOGIC;
	signal RegInst_Load	: STD_LOGIC;
	
begin
	UC_RegInst : Reg8bits port map (
		H,
		RST,
		CE,
		RegInst_Load,
		Mem_From,
		Instruction);
	
	UC_MUX : MUX6bits port map (
		Cpt_DataOut,
		Instruction(5 downto 0),
		MUX_Sel,
		Mem_Addr);
		
	UC_Cpt : Cpt6bits port map (
		H,
		RST,
		CE,
		Instruction(5 downto 0),
		Cpt_Enable,
		Cpt_Init,
		Cpt_Chargement,
		Cpt_DataOut);
	
	UC_FSM : FSM port map (
		H,
		RST,
		CE,
		UT_Carry,
		Instruction(7 downto 6),
		Cpt_Enable,
		Cpt_Init,
		Cpt_Chargement,
		MUX_Sel,
		RegInst_Load,
		Mem_Enable,
		Mem_RW,
		UT_Sel_UAL,
		UT_Load_RegData,
		UT_Load_RegAccu,
		UT_Load_RegCarry,
		UT_Init_Carry);

end Behavioral;


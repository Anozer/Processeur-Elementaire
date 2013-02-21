----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:15:40 02/14/2013 
-- Design Name: 
-- Module Name:    Mem64octets - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mem64octets is
	Port (	H			: in	STD_LOGIC;								-- Horloge
				RST		: in	STD_LOGIC;								-- Reset asynchrone du composant
				CE			: in  STD_LOGIC;								-- Clock Enable, actication du composant
				RW			: in  STD_LOGIC;								-- Read/Write, 0:Read, 1:Write
				Enable	: in  STD_LOGIC;								--	Activation de la mémoire
				ADDR		: in	STD_LOGIC_VECTOR(5 downto 0);		--	Adresse de la donnée à lire/écrire
				Data_In	: in	STD_LOGIC_VECTOR(7 downto 0);		--	Donnée à écrire
				Data_Out : out	STD_LOGIC_VECTOR(7 downto 0));	-- Donnée lue
				
end Mem64octets;

architecture Behavioral of Mem64octets is

type tab64 is array (0 to 63) of STD_LOGIC_VECTOR(7 downto 0);
signal memoire : tab64 := ("00001000",
									"01000111",
									"10000110",
									"11000010",
									"11000010",
									"00000000",
									"00000000",
									"01111110",
									"11111110",
									others => "00000000");
									
begin

	process (H,RST)
	begin
		
		if (RST = '1') then
			--memoire <= (others => "00000000");
			Data_Out <= "00000000";
			
		elsif (H'event AND H = '1') then
			if (CE = '1') then
				if (Enable = '1') then
				
					-- lecture
					if (RW = '0') then
						Data_Out <= memoire(conv_integer(ADDR));
					
					-- écriture
					elsif (RW = '1') then
						memoire(conv_integer(ADDR)) <= Data_In;
						
					end if;
					
				end if;
			end if;
		end if;
		
	end process;

end Behavioral;


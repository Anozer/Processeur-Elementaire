--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:07:41 02/22/2013
-- Design Name:   
-- Module Name:   Z:/Dev/VHDL/Processeur Elementaire/Processeur8bits/Mem64octets_TestBench.vhd
-- Project Name:  Processeur8bits
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Mem64octets
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Mem64octets_TestBench IS
END Mem64octets_TestBench;
 
ARCHITECTURE behavior OF Mem64octets_TestBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Mem64octets
    PORT(
         H : IN  std_logic;
         RST : IN  std_logic;
         CE : IN  std_logic;
         RW : IN  std_logic;
         Enable : IN  std_logic;
         ADDR : IN  std_logic_vector(5 downto 0);
         Data_In : IN  std_logic_vector(7 downto 0);
         Data_Out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal H : std_logic := '0';
   signal RST : std_logic := '0';
   signal CE : std_logic := '0';
   signal RW : std_logic := '0';
   signal Enable : std_logic := '0';
   signal ADDR : std_logic_vector(5 downto 0) := (others => '0');
   signal Data_In : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Data_Out : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant H_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Mem64octets PORT MAP (
          H => H,
          RST => RST,
          CE => CE,
          RW => RW,
          Enable => Enable,
          ADDR => ADDR,
          Data_In => Data_In,
          Data_Out => Data_Out
        );

   -- Clock process definitions
   H_process :process
   begin
		H <= '0';
		wait for H_period/2;
		H <= '1';
		wait for H_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 13 ns;	
		
		RST <= '1';
		wait for 10 ns;
		
		-- Test de lecture
		RST <= '0';
		CE <= '1';
		Enable <= '1';
		RW <= '0';
		ADDR <= "000111"; -- lecture de 0x07
		wait for 20 ns;
		
		
		-- test d'écriture
		ADDR <= "001000";	-- écriture à 0x08
		Data_In <= X"FF";	-- écriture de 0xFF
		RW <= '1';			-- activation écriture
		wait for 10 ns;
		RW <= '0';			-- lecture de la valeur écrite
		
		
		
		
		
      wait;
   end process;

END;

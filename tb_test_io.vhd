
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:30:51 02/21/2007
-- Design Name:   test_io
-- Module Name:   D:/users/infotronique/jd/test/tb_test_io.vhd
-- Project Name:  test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: test_io
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
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY tb_test_io_vhd IS
END tb_test_io_vhd;

ARCHITECTURE behavior OF tb_test_io_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT test_io
	PORT(
		CLK : IN std_logic;
		nRESET : IN std_logic;
		TRIG : IN std_logic;
		ENTREE : IN std_logic;    
		E_S : INOUT std_logic;      
		SORTIE : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL CLK :  std_logic := '0';
	SIGNAL nRESET :  std_logic := '0';
	SIGNAL TRIG :  std_logic := '0';
	SIGNAL ENTREE :  std_logic := '0';

	--BiDirs
	SIGNAL E_S :  std_logic;

	--Outputs
	SIGNAL SORTIE :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: test_io PORT MAP(
		SORTIE => SORTIE,
		CLK => CLK,
		nRESET => nRESET,
		TRIG => TRIG,
		E_S => E_S,
		ENTREE => ENTREE
	);

	tb : PROCESS
	BEGIN
	ENTREE <= '0';
	TRIG	<= '0';
	E_S <= 'Z';
	wait for 100 ns;
		-- Wait 100 ns for global reset to finish
		
	ENTREE <= '1';
	TRIG	<= '0';
	wait for 100 ns;
	
	ENTREE <= '0';
	TRIG	<= '0';
	wait for 100 ns;
	
	E_S <= 'Z';
	TRIG	<= '1';
	wait for 2 ns;
	E_S <= '1';
	wait for 100 ns;
	
	E_S <= 'Z';
	wait for 2 ns;
	TRIG	<= '0';
	wait for 100 ns;
		-- Place stimulus here

		wait; -- will wait forever
	END PROCESS;

END;

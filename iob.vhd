-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- GES3_SDRAM: Version TCOP fonctionnement similaire a GES_SRAM _ 2 differences
-- a) D_T et Q_T ne sont pas associes la mais a l'ext
-- b) modes burst elimines
-- Controleur de SRAM ZBT mt55l512y36f

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- synopsys translate_off
library unisim;
use unisim.VComponents.all;
-- synopsys translate_on


entity test_io is
  port (
    SORTIE 					: out std_logic;
    CLK, nRESET    	   : in  std_logic;
    TRIG              	: in std_logic;
	 E_S						: inout std_logic;
	 ENTREE					: in  std_logic
    );
end test_io;


architecture arch_test_io of test_io is


 -- signal A,B    : std_logic;
 -- signal TRIGGER : std_logic;

    

component IOBUF_F_16
  port(
    O  : out   std_logic;
    IO : inout std_logic;
    I  : in    std_logic;
    T  : in    std_logic
    );
end component; 
 
begin


CBUFIO1: IOBUF_F_16 port map(SORTIE,E_S,ENTREE,TRIG);

end arch_test_io;



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- FIN
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

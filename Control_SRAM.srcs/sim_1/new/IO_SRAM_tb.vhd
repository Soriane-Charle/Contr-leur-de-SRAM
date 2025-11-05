library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IO_SRAM_tb is
end IO_SRAM_tb;

architecture TB of IO_SRAM_tb is

    -----------------------------------------------------------------
    -- Déclaration du composant à tester
    -----------------------------------------------------------------
    component IO_SRAM
    Port ( Data_In   : in STD_LOGIC_VECTOR(35 DOWNTO 0);
           Data_Out  : out STD_LOGIC_VECTOR(35 DOWNTO 0);
           Addrs     : in STD_LOGIC_VECTOR(18 DOWNTO 0);
           RW        : in STD_LOGIC;
           CLK       : in STD_LOGIC;
           Rst       : IN STD_LOGIC;
           Dq        : INOUT STD_LOGIC_VECTOR (35 DOWNTO 0);   -- Data I/O
           Addr      : OUT    STD_LOGIC_VECTOR (18 DOWNTO 0);   -- Address
           Lbo_n     : OUT    STD_LOGIC;                                   -- Burst Mode
           Cke_n     : OUT    STD_LOGIC;                                   -- Cke#
           Ld_n      : OUT    STD_LOGIC;                                   -- Adv/Ld#
           Bwa_n     : OUT    STD_LOGIC;                                   -- Bwa#
           Bwb_n     : OUT    STD_LOGIC;                                   -- BWb#
           Bwc_n     : OUT    STD_LOGIC;                                   -- Bwc#
           Bwd_n     : OUT    STD_LOGIC;                                   -- BWd#
           Rw_n      : OUT    STD_LOGIC;                                   -- RW#
           Oe_n      : OUT    STD_LOGIC;                                   -- OE#
           Ce_n      : OUT   STD_LOGIC;                                   -- CE#
           Ce2_n     : OUT    STD_LOGIC;                                   -- CE2#
           Ce2       : OUT    STD_LOGIC;                                   -- CE2
           Zz        : OUT    STD_LOGIC                                   -- Snooze Mode
        );
    end component;

    -----------------------------------------------------------------
    -- Signaux internes
    -----------------------------------------------------------------
    signal CLK_tb     : std_logic := '0';
    signal RST_tb     : std_logic := '0';
    signal RW_tb      : std_logic := '1';  -- '1' = WRITE, '0' = READ
    signal Data_In_tb : std_logic_vector(35 downto 0) := (others => '0');
    signal Data_Out_tb: std_logic_vector(35 downto 0);
    signal Addrs_tb   : std_logic_vector(18 downto 0) := (others => '0');

    constant CLK_PERIOD : time := 10 ns;
    
    component mt55l512y36f IS

    GENERIC (
        -- Constant parameters

        addr_bits : INTEGER := 19;
        data_bits : INTEGER := 36;
 
        -- Timing parameters for -10 (100 Mhz)

        tKHKH    : TIME    := 10.0 ns;
        tKHKL    : TIME    :=  2.5 ns;
        tKLKH    : TIME    :=  2.5 ns;
        tKHQV    : TIME    :=  5.0 ns;
        tAVKH    : TIME    :=  2.0 ns;
        tEVKH    : TIME    :=  2.0 ns;
        tCVKH    : TIME    :=  2.0 ns;
        tDVKH    : TIME    :=  2.0 ns;
        tKHAX    : TIME    :=  0.5 ns;
        tKHEX    : TIME    :=  0.5 ns;
        tKHCX    : TIME    :=  0.5 ns;
        tKHDX    : TIME    :=  0.5 ns

    );
 
    -- Port Declarations

    PORT (
            Dq        : INOUT STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0);   -- Data I/O
            Addr      : IN    STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0);   -- Address
            Lbo_n     : IN    STD_LOGIC;                                   -- Burst Mode
            Clk       : IN    STD_LOGIC;                                   -- Clk
            Cke_n     : IN    STD_LOGIC;                                   -- Cke#
            Ld_n      : IN    STD_LOGIC;                                   -- Adv/Ld#
            Bwa_n     : IN    STD_LOGIC;                                   -- Bwa#
            Bwb_n     : IN    STD_LOGIC;                                   -- BWb#
            Bwc_n     : IN    STD_LOGIC;                                   -- Bwc#
            Bwd_n     : IN    STD_LOGIC;                                   -- BWd#
            Rw_n      : IN    STD_LOGIC;                                   -- RW#
            Oe_n      : IN    STD_LOGIC;                                   -- OE#
            Ce_n      : IN    STD_LOGIC;                                   -- CE#
            Ce2_n     : IN    STD_LOGIC;                                   -- CE2#
            Ce2       : IN    STD_LOGIC;                                   -- CE2
            Zz        : IN    STD_LOGIC                                   -- Snooze Mode

    );
end component mt55l512y36f;

SIGNAL  Dq         : STD_LOGIC_VECTOR (35 DOWNTO 0);   -- Data I/O
SIGNAL  CLK        : STD_LOGIC;
SIGNAL  Addr       : STD_LOGIC_VECTOR (18 DOWNTO 0);   -- Address
SIGNAL   Lbo_n     : STD_LOGIC := '0';                                   -- Burst Mode
SIGNAL   Cke_n     : STD_LOGIC := '0';                                   -- Cke#
SIGNAL   Ld_n      : STD_LOGIC := '0';                                   -- Adv/Ld#
SIGNAL   Bwa_n     : STD_LOGIC := '0';                                   -- Bwa#
SIGNAL   Bwb_n     : STD_LOGIC := '0';                                   -- BWb#
SIGNAL   Bwc_n     : STD_LOGIC := '0';                                   -- Bwc#
SIGNAL   Bwd_n     : STD_LOGIC := '0';                                   -- BWd#
SIGNAL   Rw_n      : STD_LOGIC;                                  -- RW#
SIGNAL   Oe_n      : STD_LOGIC;                                   -- OE#
SIGNAL   Ce_n      : STD_LOGIC := '0';                                   -- CE#
SIGNAL   Ce2_n     : STD_LOGIC := '0';                                   -- CE2#
SIGNAL   Ce2       : STD_LOGIC := '1';                                   -- CE2
SIGNAL   Zz        : STD_LOGIC := '0';                                   -- Snooze Mode

begin

  SRAM1 : mt55l512y36f 
   port map   (    CLK    =>    CLK_tb,  
                   Dq     =>     Dq,   
                   Addr   =>     Addr, 
                   Lbo_n   =>    Lbo_n,
                   Cke_n   =>    Cke_n,
                   Ld_n    =>    Ld_n, 
                   Bwa_n   =>    Bwa_n,
                   Bwb_n   =>    Bwb_n,
                   Bwc_n   =>    Bwc_n,
                   Bwd_n    =>   Bwd_n,
                   Rw_n    =>    Rw_n, 
                   Oe_n    =>    Oe_n, 
                   Ce_n    =>    Ce_n, 
                   Ce2_n   =>    Ce2_n,
                   Ce2    =>    Ce2,
                   Zz     =>     Zz   
          );

    DUT: IO_SRAM
        port map (
            Data_In  => Data_In_tb,
            Data_Out => Data_Out_tb,
            Addrs    => Addrs_tb,
            RW       => RW_tb,
            CLK      => CLK_tb,
            Rst      => RST_tb,
            Dq     =>     Dq,   
           Addr   =>     Addr, 
           Lbo_n   =>    Lbo_n,
           Cke_n   =>    Cke_n,
           Ld_n    =>    Ld_n, 
           Bwa_n   =>    Bwa_n,
           Bwb_n   =>    Bwb_n,
           Bwc_n   =>    Bwc_n,
           Bwd_n    =>   Bwd_n,
           Rw_n    =>    Rw_n, 
           Oe_n    =>    Oe_n, 
           Ce_n    =>    Ce_n, 
           Ce2_n   =>    Ce2_n,
           Ce2    =>    Ce2,
           Zz     =>     Zz  
            
        );

    clk_process : process
    begin
            wait for CLK_PERIOD / 2;
            CLK_tb <= '0';
            wait for CLK_PERIOD / 2;
            CLK_tb <= '1';        
    end process;


           

    stim_proc : process
    begin

        RST_tb <= '1';
        wait for 5 ns;
        RST_tb <= '0';
            
        
        
        wait for CLK_PERIOD;
      
        
        
        RW_tb <= '1';  -- mode write
        Data_In_tb <= "000000000000000000000000000000000001";  -- données 1, 2, 3, ...
        Addrs_tb   <= "0000000000000000001";  -- adresses correspondantes
        wait for CLK_PERIOD;
        Data_In_tb <= "000000000000000000000000000000000011";  -- données 1, 2, 3, ...
        Addrs_tb   <= "0000000000000000011";  -- adresses correspondantes
        wait for CLK_PERIOD;
        RW_tb <= '0';
        wait for CLK_PERIOD;
        Addrs_tb   <= "0000000000000000011";  -- adresses correspondantes
        Data_In_tb <= "000000000000000000000000000000000000";  -- données 1, 2, 3, ...
        
        
--        wait for CLK_PERIOD;
--        RW_tb <= '0';  -- mode READ
--        wait for CLK_PERIOD;
--        RW_tb <= '1';
--        wait for CLK_PERIOD;
--        RW_tb <= '0';  -- mode READ
--        wait for CLK_PERIOD;
--        RW_tb <= '1';
--        wait for CLK_PERIOD;
        
         
--        
--        Addrs_tb   <= "0000000000000000001";  -- adresses correspondantes
--        wait for CLK_PERIOD / 2;
        
--        Data_In_tb <= "000000000000000000000000000000000001";  -- données 1, 2, 3, ...
--        Addrs_tb   <= "0000000000000000010";  -- adresses correspondantes
--        wait for CLK_PERIOD / 2;
        
--        Data_In_tb <= "000000000000000000000000000000000011";  -- données 1, 2, 3
--        Addrs_tb   <= "0000000000000000011";  -- adresses correspondantes
--        wait for CLK_PERIOD / 2;
--         Data_In_tb <= "000000000000000000000000000000000000";  
         
--        wait for CLK_PERIOD / 2;
--        RW_tb <= '0';  -- mode lecture
       
--        Addrs_tb   <= "0000000000000000001"; 
--        wait for CLK_PERIOD / 2;
--        Addrs_tb   <= "0000000000000000010"; 
--        wait for CLK_PERIOD / 2;
--        Addrs_tb   <= "0000000000000000011"; 
--        wait for CLK_PERIOD / 2;

        wait;
    end process;

end TB;

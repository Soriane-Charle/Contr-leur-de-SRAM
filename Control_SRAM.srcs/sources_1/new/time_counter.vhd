library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity Clock_Counter is
    Generic (
        CYCLE_COUNT : integer := 100 -- Number of clock cycles to count
    );
    Port (
        clk          : in  std_logic;             -- Clock signal
        reset        : in  std_logic;             -- Synchronous reset signal
        enable       : in  std_logic;             -- Enable signal for counting
        done         : out std_logic             -- Indicates the count is complete
                        -- Current counter value
    );
end Clock_Counter;
 
architecture Behavioral of Clock_Counter is
    signal counter : integer := 0; -- Internal counter
    signal count_done : std_logic := '0';
begin
 
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                counter <= 0;
                count_done <= '0';
            elsif enable = '1' then
                if counter < CYCLE_COUNT - 1 then
                    counter <= counter + 1;
                    count_done <= '0';
                else
                    count_done <= '1'; -- Signal that counting is complete
                    counter <= 0;      -- Reset counter
                  end if;  
             else       
                    count_done <= '0'; -- Signal that counting is complete
                    counter <= 0; 
                
            end if;
        end if;
    end process;
 
    
    done <= count_done;

 
end Behavioral;
--denis
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Slow_Clock is
    port(
        clk: in std_logic; 
        slow_clk_enable: out std_logic
    );
end Slow_Clock;
--the main clock divided at around 200 Hz in order to perfrom the transitions
architecture Behavioral of Slow_Clock is
    signal counter: std_logic_vector(27 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1; 
            if counter >= x"007A120"then 
                counter <= (others => '0');
            end if;
        end if;
    end process;
    slow_clk_enable <= '1' when counter =x"007A120"else '0'; 
end Behavioral;
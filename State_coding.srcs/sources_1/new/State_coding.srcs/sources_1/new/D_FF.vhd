

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF is
    Port ( clk : in STD_LOGIC;
           D : in STD_LOGIC;
           Q : out STD_LOGIC);
end D_FF;

architecture Behavioral of D_FF is

begin
process(clk,D)
begin
    if(rising_edge(clk)) then   
        Q<=D;
    end if;
end process;
end Behavioral;

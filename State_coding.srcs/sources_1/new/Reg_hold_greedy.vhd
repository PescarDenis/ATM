--dan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Reg_hold_greedy is
    Port ( load : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           Q : out STD_LOGIC);
end Reg_hold_greedy;
--simple 1 bit register
architecture Behavioral of Reg_hold_greedy is

begin
    process(clk,reset,load) begin
        if(rising_edge(clk)) then
            if(reset='1') then
                Q<='0';
             elsif(load='1') then
                Q<='1';
             end if;
         end if;
end process;   
end Behavioral;

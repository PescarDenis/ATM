
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter_greedy_reg is
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Carry : out STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (2 downto 0));
end counter_greedy_reg;

architecture Behavioral of counter_greedy_reg is

signal count : STD_LOGIC_VECTOR(2 downto 0):= (others=>'0');
begin
    
    process(clk)
    begin
        if(rising_edge(clk)) then
        if(Reset='1') then
            count<=(others=>'0');
         elsif(Enable = '1') then  
                if(count < "100") then
                    count <= count + 1;
                else  
                count<="101"; --we give a non existining address as we hardcode them and we have only 6 card from 000 to 101 
                end if;
            end if;
        end if;
        Q <= count; 
    end process;
Carry<='1' when count="101" else '0';
end Behavioral;

--denis+dan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_2_to_1 is
    Port ( sel : in STD_LOGIC;
           input1 : in STD_LOGIC_VECTOR (2 downto 0);
           input2 : in STD_LOGIC_VECTOR (2 downto 0);
           output : out STD_LOGIC_VECTOR (2 downto 0));
end MUX_2_to_1;
--this mux is used to select what we want to do,either read or write 
architecture Behavioral of MUX_2_to_1 is

begin
    process(sel,input1,input2)
        begin
        case sel is 
            when '0' => output<=input1;
            when others => output<=input2;
        end case;
    end process;
end Behavioral;

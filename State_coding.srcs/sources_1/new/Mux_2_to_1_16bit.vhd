
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2_to_1_16bit is
    Port ( input0 : in STD_LOGIC_VECTOR (15 downto 0);
           input1 : in STD_LOGIC_VECTOR (15 downto 0);
           sel : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (15 downto 0));
end Mux_2_to_1_16bit;
--a 2 to 1 mux on a data width of 16 bits, used to see what to write at the specific address
--it takes the mode as selection, beacuse we either want to write the updated greedy 
--or the updated sum after we deposit(add the current value of the banknotes with what we deposit)
architecture Behavioral of Mux_2_to_1_16bit is

begin
    process(sel, input1, input0)
    begin
        case sel is 
            when '0' => output<=input0;
            when others => output<=input1;
        end case;
    end process;

end Behavioral;

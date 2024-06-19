--dan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2_to_1_1bit is
    Port ( input0 : in STD_LOGIC;
           input1 : in STD_LOGIC;
           sel : in STD_LOGIC;
           output : out STD_LOGIC);
end Mux_2_to_1_1bit;
--simple 2:1 mux
architecture Behavioral of Mux_2_to_1_1bit is

begin

    process(sel,input1,input0)
    begin
        if(sel = '0') then
            output <= input0;
        else output <= input1;
        end if;
    end process;

end Behavioral;

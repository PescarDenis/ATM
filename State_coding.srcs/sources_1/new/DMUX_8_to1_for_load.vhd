--denis+dan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity DMUX_8_to1_for_load is
    Port ( o0 : out STD_LOGIC;
           o1 : out STD_LOGIC;
           o2 : out STD_LOGIC;
           o3 : out STD_LOGIC;
           o4 : out STD_LOGIC;
           o5 : out STD_LOGIC;
           o6 : out STD_LOGIC;
           o7 : out STD_LOGIC;
           sel: in std_logic_vector(2 downto 0);
            input : in STD_LOGIC);
end DMUX_8_to1_for_load;

architecture Behavioral of DMUX_8_to1_for_load is
--this component loads the register based on the selection
--from the counter
begin

    process(sel,input)
    begin
        case sel is
            when "000" =>
                o0 <= input;
                o1 <= '0';
                o2 <= '0';
                o3 <= '0';
                o4 <= '0';
                o5 <= '0';
                o6 <= '0';
                o7 <= '0';
            when "001" =>
                o0 <= '0';
                o1 <= input;
                o2 <= '0';
                o3 <= '0';
                o4 <= '0';
                o5 <= '0';
                o6 <= '0';
                o7 <= '0';
            when "010" =>
                o0 <= '0';
                o1 <= '0';
                o2 <= input;
                o3 <= '0';
                o4 <= '0';
                o5 <= '0';
                o6 <= '0';
                o7 <= '0';
            when "011" =>
                o0 <= '0';
                o1 <= '0';
                o2 <= '0';
                o3 <= input;
                o4 <= '0';
                o5 <= '0';
                o6 <= '0';
                o7 <= '0';
            when "100" =>
                o0 <= '0';
                o1 <= '0';
                o2 <= '0';
                o3 <= '0';
                o4 <= input;
                o5 <= '0';
                o6 <= '0';
                o7 <= '0';
            when "101" =>
                o0 <= '0';
                o1 <= '0';
                o2 <= '0';
                o3 <= '0';
                o4 <= '0';
                o5 <= input;
                o6 <= '0';
                o7 <= '0';
            when "110" =>
                o0 <= '0';
                o1 <= '0';
                o2 <= '0';
                o3 <= '0';
                o4 <= '0';
                o5 <= '0';
                o6 <= input;
                o7 <= '0';
            when others =>
                o0 <= '0';
                o1 <= '0';
                o2 <= '0';
                o3 <= '0';
                o4 <= '0';
                o5 <= '0';
                o6 <= '0';
                o7 <= input;
        end case;
    end process;

end Behavioral;
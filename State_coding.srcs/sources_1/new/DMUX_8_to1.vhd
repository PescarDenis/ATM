--denis +dan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DMUX_8_to1 is
    Port ( o0 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           o1 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           o2 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           o3 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           o4 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           o5 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           o6 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           o7 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           sel: in std_logic_vector(2 downto 0);
            input : in STD_LOGIC_VECTOR(15 DOWNTO 0));
end DMUX_8_to1;

architecture Behavioral of DMUX_8_to1 is
--this component takes the output of the ram memory, what is at that specific address,which
--is used as selection here, and outputs what to load into the 5 registers
begin

    process(sel,input)
    begin
        case sel is
            when "000" =>
                o0 <= input;
                o1 <= (others => '0');
                o2 <= (others => '0');
                o3 <= (others => '0');
                o4 <= (others => '0');
                o5 <= (others => '0');
                o6 <= (others => '0');
                o7 <= (others => '0');
            when "001" =>
                o0 <= (others => '0');
                o1 <= input;
                o2 <= (others => '0');
                o3 <= (others => '0');
                o4 <= (others => '0');
                o5 <= (others => '0');
                o6 <= (others => '0');
                o7 <= (others => '0');
            when "010" =>
                o0 <= (others => '0');
                o1 <= (others => '0');
                o2 <= input;
                o3 <= (others => '0');
                o4 <= (others => '0');
                o5 <= (others => '0');
                o6 <= (others => '0');
                o7 <= (others => '0');
            when "011" =>
                o0 <= (others => '0');
                o1 <= (others => '0');
                o2 <= (others => '0');
                o3 <= input;
                o4 <= (others => '0');
                o5 <= (others => '0');
                o6 <= (others => '0');
                o7 <= (others => '0');
            when "100" =>
                o0 <= (others => '0');
                o1 <= (others => '0');
                o2 <= (others => '0');
                o3 <= (others => '0');
                o4 <= input;
                o5 <= (others => '0');
                o6 <= (others => '0');
                o7 <= (others => '0');
            when "101" =>
                o0 <= (others => '0');
                o1 <= (others => '0');
                o2 <= (others => '0');
                o3 <= (others => '0');
                o4 <= (others => '0');
                o5 <= input;
                o6 <= (others => '0');
                o7 <= (others => '0');
            when "110" =>
                o0 <= (others => '0');
                o1 <= (others => '0');
                o2 <= (others => '0');
                o3 <= (others => '0');
                o4 <= (others => '0');
                o5 <= (others => '0');
                o6 <= input;
                o7 <= (others => '0');
            when others =>
                o0 <= (others => '0');
                o1 <= (others => '0');
                o2 <= (others => '0');
                o3 <= (others => '0');
                o4 <= (others => '0');
                o5 <= (others => '0');
                o6 <= (others => '0');
                o7 <= input;
        end case;
    end process;

end Behavioral;
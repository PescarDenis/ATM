--denis+dan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_8_to1 is
    Port ( i0 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           i1 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           i2 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           i3 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           i4 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           i5 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           i6 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           i7 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           sel: in std_logic_vector(2 downto 0);
            output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
end MUX_8_to1;
--an 8 to 1 mux on 16 bits 
--we are only using the first 5 inputs,because we want to write at 5 addresses, so the others
--are not useful, the inputs take the number of banknotes(either from greedy or depositing)
architecture Behavioral of MUX_8_to1 is

begin

    process(sel,i0,i1,i2,i3,i4,i5,i6,i7)
    begin
        case sel is
            when "000" =>
                output <= i0;
            when "001" =>
                output <= i1;
            when "010" =>
                output <= i2;
            when "011" =>
                output <= i3;
            when "100" =>
                output <= i4;
            when "101" =>
                output <= i5;
            when "110" =>
                output <= i6;
            when others =>
                output <= i7;
        end case;
    end process;

end Behavioral;
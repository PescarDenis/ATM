library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity Register_load_16bit is
    Port ( dataIn : in STD_LOGIC_VECTOR (15 downto 0);
           LD : in STD_LOGIC;
           clock : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (15 downto 0));
end Register_load_16bit;

architecture Behavioral of Register_load_16bit is

begin
process(clock,Reset)
begin
    if(Reset = '1') then
            Q <= (others => '0');
    elsif(rising_edge(clock))then
        if(LD='1') then
            Q<=dataIn;
        end if;
    end if;
end process;

end Behavioral;
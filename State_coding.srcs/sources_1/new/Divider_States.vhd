library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Divider_States is
    Port (
        CLK50 : in STD_LOGIC;   -- Initial clock of 50 MHz
        Divided : out STD_LOGIC
    );
end Divider_States;

architecture Divide of Divider_States is
    signal count : std_logic_vector(25 downto 0) := (others => '0');
begin
    process(CLK50)
    begin
        if rising_edge(CLK50) then
            if count = X"3FFFFFF" then  -- Maximum count value
                count <= (others => '0');  -- Reset count
                Divided <= '1';  -- Output pulse at every overflow
            else
                count <= count + 1;  -- Increment count
                Divided <= '0';  -- Output low when not at overflow
            end if;
        end if;
    end process;
end Divide;

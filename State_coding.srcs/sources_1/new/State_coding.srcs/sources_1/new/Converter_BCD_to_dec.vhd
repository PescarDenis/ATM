--dan+denis
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Converter_BCD_to_dec is
    Port (
        bcd_input  : in  STD_LOGIC_VECTOR (15 downto 0); -- 4-digit BCD input (16 bits)
        dec_output : out integer                         -- Output integer (4 digits)
    );
end Converter_BCD_to_dec;

architecture Behavioral of Converter_BCD_to_dec is
begin
    process(bcd_input)
        variable temp_int : integer := 0;
    begin
        -- Extract each BCD digit and convert to integer
        temp_int := 1000 * to_integer(unsigned(bcd_input(15 downto 12))) +
                    100 * to_integer(unsigned(bcd_input(11 downto 8))) +
                    10 * to_integer(unsigned(bcd_input(7 downto 4))) +
                    to_integer(unsigned(bcd_input(3 downto 0)));

        -- Assign the calculated integer to the output
        dec_output <= temp_int;
    end process;
end Behavioral;

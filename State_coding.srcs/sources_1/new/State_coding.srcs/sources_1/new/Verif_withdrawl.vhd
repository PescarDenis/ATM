--dan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Verif_withdrawal_module is
    Port ( Sum_introduced : in STD_LOGIC_VECTOR (15 downto 0);
           Sum_PIN : in STD_LOGIC_VECTOR (15 downto 0);
           Sum_to_write:out std_logic_vector(15 downto 0);
           Verif_ok : out STD_LOGIC :='1');
end Verif_withdrawal_module;

--this component takes the sum introduced from pmod and subtract it from the current balance
-- of the pin introduced, it converts it from BCD to dec
--and after we calculate it transforms it back to BCD from decimal
--it also has a verification output which check if the introduced sum
--is less than the current balance, less than or equal to 1000 and if the introduced 
--number is divisible to 5 as we have banknotes of 5,10,20,50,100
architecture Behavioral of Verif_withdrawal_module is

component Converter_BCD_to_dec is
    Port (
        bcd_input  : in  STD_LOGIC_VECTOR (15 downto 0); -- 4-digit BCD input (16 bits)
        dec_output : out integer                         -- Output integer (4 digits)
    );
end component;

component Converter_dec_to_BCD is
    Port (dec_input : in integer;
           bcd_output : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal decimal1: integer;
signal decimal2:integer;
signal subtract:integer;
signal subtract_temp : std_logic_vector(15 downto 0);
constant max_withdrawal:integer := 1000;
begin
c0: Converter_BCD_to_dec port map(Sum_introduced,decimal1);
c1: Converter_BCD_to_dec port map(Sum_PIN,decimal2);
c2: Converter_dec_to_BCD port map(subtract,subtract_temp);
subtract<= decimal2 - decimal1;
    process(decimal1)
        begin
        if( decimal1<= max_withdrawal and decimal1<=decimal2 and decimal1 mod 5 = 0) then
            Verif_ok<='1';
             Sum_to_write<=subtract_temp;
        else
            Verif_ok<='0';
            Sum_to_write<=(others=>'0');
         end if;
        end process;
end Behavioral;

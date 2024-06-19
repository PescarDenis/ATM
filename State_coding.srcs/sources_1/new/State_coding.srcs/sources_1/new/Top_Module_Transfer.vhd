--denis
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Top_Module_Transfer is
    Port ( transfer_sum : in STD_LOGIC_VECTOR (15 downto 0);
           summ1 : in STD_LOGIC_VECTOR (15 downto 0);
           summ2 : in STD_LOGIC_VECTOR (15 downto 0);
           updated_sum1 : out STD_LOGIC_VECTOR (15 downto 0);
           updated_sum2 : out STD_LOGIC_VECTOR (15 downto 0);
           verif_ok : out STD_LOGIC:='1');
end Top_Module_Transfer;

architecture Behavioral of Top_Module_Transfer is

--this component takes the 3 inputs as BCD, the balance at the first and second pin
-- and also the transfered sum from the pmod keypad in bcd
--we subtract from the first and add into the second one
--then we update the sum into BCD from decimal
--also,we have an output verif, to check if the transfer can be done
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
signal sum_decimal_1:integer;
signal sum_decimal_2:integer;
signal transfer_sum_decimal:integer;
signal update_sum1_decimal:integer;
signal update_sum2_decimal:integer;
constant max_amount:integer := 9999;
begin
c0: Converter_BCD_to_dec port map( summ1, sum_decimal_1);
c1: Converter_BCD_to_dec port map( summ2, sum_decimal_2);
c2: Converter_BCD_to_dec port map( transfer_sum, transfer_sum_decimal);
c3: Converter_dec_to_BCD port map( update_sum1_decimal,updated_sum1);
c4: Converter_dec_to_BCD port map( update_sum2_decimal,updated_sum2);

update_sum1_decimal<=sum_decimal_1 - transfer_sum_decimal; -- the transfer happens from the first account to the second account
update_sum2_decimal<=sum_decimal_2 + transfer_sum_decimal;

process(transfer_sum_decimal,sum_decimal_1)
    begin
        if(transfer_sum_decimal <= sum_decimal_1 and update_sum2_decimal<=max_amount) then
                verif_ok<='1';
        else
                verif_ok<='0';
         end if;
end process;
end Behavioral;

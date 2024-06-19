--denis
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Calculate_final_amount is
Port ( 
    input1: in std_logic_vector(15 downto 0);
    input2 : in std_logic_vector(15 downto 0);
    sum: out std_logic_vector(15 downto 0);
    sum_ok:out std_logic :='1'
    );
end Calculate_final_amount;

architecture Behavioral of Calculate_final_amount is

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
-- this component takes 2 bcd numbers,performs an addition
--and after the addition is performed it converts it back to the bcd
--to be able to print it
--also has an output to see if the sum after addition is not more than 9999
signal decimal1: integer;
signal decimal2:integer;
signal sum_temp:integer;
signal final_sum: std_logic_vector(15 downto 0);
constant max_amount: integer := 9999;
begin
c0:Converter_BCD_to_dec port map(input1,decimal1);
c1:Converter_BCD_to_dec port map(input2,decimal2);
c2:Converter_dec_to_BCD port map(sum_temp,final_sum);
sum_temp <= decimal1 + decimal2;
process(input1, input2)
    begin
            if(sum_temp>max_amount) then
                  sum_ok<='0';
                  sum <=(others =>'0');
            else
                sum_ok<='1';
                sum<=final_sum;
             end if;
 end process;   
end Behavioral;

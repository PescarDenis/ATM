--denis+dan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity greedy_banknotes is
    Port (
        bcd_sum     : in  std_logic_vector(15 downto 0); -- 4-digit BCD input
        nr_5        : in  std_logic_vector(15 downto 0); -- Number of banknotes of each type
        nr_10       : in  std_logic_vector(15 downto 0);
        nr_20       : in  std_logic_vector(15 downto 0);
        nr_50       : in  std_logic_vector(15 downto 0);
        nr_100      : in  std_logic_vector(15 downto 0);
        updated5    : out std_logic_vector(15 downto 0); -- Updated number of banknotes after greedy update
        updated10   : out std_logic_vector(15 downto 0);
        updated20   : out std_logic_vector(15 downto 0);
        updated50   : out std_logic_vector(15 downto 0);
        updated100  : out std_logic_vector(15 downto 0);
        display5    : out std_logic_vector(15 downto 0); -- Number of banknotes used in the greedy update
        display10   : out std_logic_vector(15 downto 0);
        display20   : out std_logic_vector(15 downto 0);
        display50   : out std_logic_vector(15 downto 0);
        display100  : out std_logic_vector(15 downto 0);
        start       : in std_logic;
        end_alg :    out STD_LOGIC
    );
end greedy_banknotes;

architecture Behavioral of greedy_banknotes is

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

signal sum_to_dec1: integer;
signal nr_5_int : integer:=0;
signal nr_10_int : integer:=0;
signal nr_20_int : integer :=0;
signal nr_50_int : integer :=0;
signal nr_100_int : integer :=0;

--this is the algorithm used for greedy, it takes at input the bcd sum introduced
--from the pmod for withdrawal, then converts it to decimal
--then, the 
begin

    c0: Converter_BCD_to_dec port map(bcd_sum, sum_to_dec1);
    c1: Converter_dec_to_BCD port map(nr_5_int,display5);
    c2: Converter_dec_to_BCD port map(nr_10_int,display10);
    c3: Converter_dec_to_BCD port map(nr_20_int,display20);
    c4: Converter_dec_to_BCD port map(nr_50_int,display50);
    c5: Converter_dec_to_BCD port map(nr_100_int,display100);
    
    process(sum_to_dec1, nr_5, nr_10, nr_20, nr_50, nr_100,start)
        variable sum_to_dec: integer :=0;
        variable num_100   : integer := 0;
        variable num_50    : integer := 0;
        variable num_20    : integer := 0;
        variable num_10    : integer := 0;
        variable num_5     : integer := 0;
        variable temp_nr_5 : integer := 0;
        variable temp_nr_10 : integer := 0;
        variable temp_nr_20 : integer := 0;
        variable temp_nr_50 : integer := 0;
        variable temp_nr_100 : integer := 0;
    begin
        sum_to_dec :=0;
        num_100    := 0;
        num_50     := 0;
        num_20     := 0;
        num_10     := 0;
        num_5      := 0;
        temp_nr_5  := 0;
        temp_nr_10 := 0;
        temp_nr_20 := 0;
        temp_nr_50 := 0;
        temp_nr_100:= 0;
        if(start='1') then
            sum_to_dec := sum_to_dec1; -- Ensure signal sum_to_dec gets the updated value
            -- Convert std_logic_vector inputs to integers
            temp_nr_5 := to_integer(unsigned(nr_5));
            temp_nr_10 := to_integer(unsigned(nr_10));
            temp_nr_20 := to_integer(unsigned(nr_20));
            temp_nr_50 := to_integer(unsigned(nr_50));
            temp_nr_100 := to_integer(unsigned(nr_100));
    
            -- Calculate number of 100 banknotes
            if sum_to_dec >= 100 and temp_nr_100 > 0 then
                num_100 := sum_to_dec / 100;
                if num_100 > temp_nr_100 then
                    num_100 := temp_nr_100;
                    sum_to_dec := sum_to_dec - temp_nr_100 * 100;
                else 
                    sum_to_dec := sum_to_dec mod 100;
                end if;   
            end if;
    
            -- Calculate number of 50 banknotes
            if sum_to_dec >= 50 and temp_nr_50 > 0 then
                num_50 := sum_to_dec / 50;
                if num_50 > temp_nr_50 then
                    num_50 := temp_nr_50;
                    sum_to_dec := sum_to_dec - temp_nr_50 * 50;
                else
                    sum_to_dec := sum_to_dec mod 50;
                end if;
            end if;
    
            -- Calculate number of 20 banknotes
            if sum_to_dec >= 20 and temp_nr_20 > 0 then
                num_20 := sum_to_dec / 20;
                if num_20 > temp_nr_20 then
                    num_20 := temp_nr_20;
                    sum_to_dec := sum_to_dec - temp_nr_20 * 20;
                else    
                    sum_to_dec := sum_to_dec mod 20;
                end if;
            end if;
    
            -- Calculate number of 10 banknotes
            if sum_to_dec >= 10 and temp_nr_10 > 0 then
                num_10 := sum_to_dec / 10;
                if num_10 > temp_nr_10 then
                    num_10 := temp_nr_10;
                    sum_to_dec := sum_to_dec - temp_nr_10 * 10;
                else
                    sum_to_dec := sum_to_dec mod 10;
                end if;
            end if;
    
            -- Calculate number of 5 banknotes
            if sum_to_dec >= 5 and temp_nr_5 > 0 then
                num_5 := sum_to_dec / 5;
                if num_5 > temp_nr_5 then
                    num_5 := temp_nr_5;
                    sum_to_dec := sum_to_dec - temp_nr_5 * 5;
                else
                    sum_to_dec := sum_to_dec mod 5;
                end if;
            end if;
    
            -- Update the number of banknotes after the greedy update
            
            if(sum_to_dec=0) then  
                end_alg<='1';
               else
                end_alg<='0';
           end if;
       else
    
            -- Update the number of banknotes after the greedy update
            end_alg<='0';
        end if;
        nr_100_int<=num_100;
        nr_50_int<=num_50;
        nr_20_int<=num_20;
        nr_10_int<=num_10;
        nr_5_int<=num_5;
        updated100 <= std_logic_vector(to_unsigned(temp_nr_100 - num_100, 16));
        updated50  <= std_logic_vector(to_unsigned(temp_nr_50 - num_50, 16));
        updated20  <= std_logic_vector(to_unsigned(temp_nr_20 - num_20, 16));
        updated10  <= std_logic_vector(to_unsigned(temp_nr_10 - num_10, 16));
        updated5   <= std_logic_vector(to_unsigned(temp_nr_5 - num_5, 16));
    end process;
    
    
end Behavioral;
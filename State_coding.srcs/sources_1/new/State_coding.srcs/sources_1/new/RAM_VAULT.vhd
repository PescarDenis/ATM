--denis+dan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM_VAULT is
    Port (
        WE           : in  STD_LOGIC;  -- The write enable activates after we deposit or withdraw a certain amount
        ADDR         : in  STD_LOGIC_VECTOR (2 downto 0);  -- The address of the memory holds the number of banknotes
        DIN          : in  STD_LOGIC_VECTOR (15 downto 0);  -- The number of banknotes that we are going to write when we update
        CLK          : in  STD_LOGIC;
        NR_BANKNOTES : out STD_LOGIC_VECTOR (15 downto 0)  -- The output showing the number of banknotes at the specific address
    );
end RAM_VAULT;

architecture Behavioral of RAM_VAULT is
    type ram_array is array (0 to 7) of std_logic_vector(15 downto 0);  -- The declaration of a RAM array
    signal memory : ram_array := (
        0 => "0000000000000000",  -- Number of 5 banknotes (100 in binary)
        1 => "0000000000000100", -- Number of 10 banknotes (100 in binary)
        2 => "0000000000000101",  -- Number of 20 banknotes (100 in binary)
        3 => "0000000000000011",  -- Number of 50 banknotes (100 in binary)
        4 => "0000000000000101",  -- Number of 100 banknotes (100 in binary)
        5 => (others => '0'),  -- Unused
        6 => (others => '0'),  -- Unused
        7 => (others => '0')   -- Unused
    );
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if WE = '1' then
                memory(to_integer(unsigned(ADDR))) <= DIN;  -- If we update the number of banknotes, update the value at that specific address
            end if;
        end if;
    end process;

    NR_BANKNOTES <= memory(to_integer(unsigned(ADDR)));
end Behavioral;
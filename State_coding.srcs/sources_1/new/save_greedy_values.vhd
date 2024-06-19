--dan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity save_greedy_values is
    Port ( clk : in STD_LOGIC;
           input5 : in STD_LOGIC_VECTOR (15 downto 0);
           input10 : in STD_LOGIC_VECTOR (15 downto 0);
           input20 : in STD_LOGIC_VECTOR (15 downto 0);
           input50 : in STD_LOGIC_VECTOR (15 downto 0);
           input100 : in STD_LOGIC_VECTOR (15 downto 0);
           load_greedy_reg : in STD_LOGIC;
           reset_reg : in STD_LOGIC;
           output5 : out STD_LOGIC_VECTOR(15 downto 0);
           output10 : out STD_LOGIC_VECTOR(15 downto 0);
           output20 : out STD_LOGIC_VECTOR(15 downto 0);
           output50 : out STD_LOGIC_VECTOR(15 downto 0);
           output100 : out STD_LOGIC_VECTOR(15 downto 0));
end save_greedy_values;

architecture Behavioral of save_greedy_values is

component Register_load_16bit is
    Port ( dataIn : in STD_LOGIC_VECTOR (15 downto 0);
           LD : in STD_LOGIC;
           clock : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (15 downto 0));
end component;
begin
--this is a component of 16 bit registers to hold the values of the 
--greedy outputs,either the updated banknotes or the current display of the greedy
reg1: Register_load_16bit port map(input5, load_greedy_reg, clk, reset_reg, output5);
reg2: Register_load_16bit port map(input10, load_greedy_reg, clk, reset_reg, output10);
reg3: Register_load_16bit port map(input20, load_greedy_reg, clk, reset_reg, output20);
reg4: Register_load_16bit port map(input50, load_greedy_reg, clk, reset_reg, output50);
reg5: Register_load_16bit port map(input100, load_greedy_reg, clk, reset_reg, output100);

end Behavioral;

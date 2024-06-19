library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity tb_sum_creator_deposit is
end tb_sum_creator_deposit;

architecture Behavioral of tb_sum_creator_deposit is
    signal clk : STD_LOGIC := '0';
    signal Reset : STD_LOGIC := '0';            
    signal input_5 : STD_LOGIC := '0';
    signal input_10 : STD_LOGIC := '0';
    signal input_20 : STD_LOGIC := '0';
    signal input_50 : STD_LOGIC := '0';
    signal input_100 : STD_LOGIC := '0';
    signal sum_deposit : std_logic_vector(15 downto 0);
    signal cnt_5 : std_logic_vector(15 downto 0);
    signal cnt_10 : std_logic_vector(15 downto 0);
    signal cnt_20 : std_logic_vector(15 downto 0);
    signal cnt_50 : std_logic_vector(15 downto 0);
    signal cnt_100 : std_logic_vector(15 downto 0);

    component sum_creator_deposit
        Port ( clk : in STD_LOGIC;
               Reset : in STD_LOGIC;            
               input_5 : in STD_LOGIC;
               input_10 : in STD_LOGIC;
               input_20 : in STD_LOGIC;
               input_50 : in STD_LOGIC;
               input_100 : in STD_LOGIC;
               sum_deposit : out std_logic_vector(15 downto 0);
               cnt_5 : out std_logic_vector(15 downto 0);
               cnt_10 : out std_logic_vector(15 downto 0);
               cnt_20 : out std_logic_vector(15 downto 0);
               cnt_50 : out std_logic_vector(15 downto 0);
               cnt_100 : out std_logic_vector(15 downto 0));
    end component;

    -- Clock generation
    constant clk_period : time := 10 ns;
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: sum_creator_deposit
        Port map (
            clk => clk,
            Reset => Reset,
            input_5 => input_5,
            input_10 => input_10,
            input_20 => input_20,
            input_50 => input_50,
            input_100 => input_100,
            sum_deposit => sum_deposit,
            cnt_5 => cnt_5,
            cnt_10 => cnt_10,
            cnt_20 => cnt_20,
            cnt_50 => cnt_50,
            cnt_100 => cnt_100
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the system
        Reset <= '1';
        wait for 20 ns;
        Reset <= '0';

        -- Deposit 5
        input_5 <= '1';
        wait for 20 ns;
        input_5 <= '0';

        -- Deposit 10
        input_10 <= '1';
        wait for 20 ns;
        input_10 <= '0';

        -- Deposit 20
        input_20 <= '1';
        wait for 20 ns;
        input_20 <= '0';

        -- Deposit 50
        input_50 <= '1';
        wait for 20 ns;
        input_50 <= '0';

        -- Deposit 100
        input_100 <= '1';
        wait for 20 ns;
        input_100 <= '0';

        -- Wait for some time to observe the outputs
        wait for 100 ns;

        -- Check if the sum is correctly updated and outputs are as expected
       
        -- End simulation
        wait;
    end process;
end Behavioral;

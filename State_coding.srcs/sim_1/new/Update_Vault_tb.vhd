library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Update_Vault_tb is
end Update_Vault_tb;

architecture Behavioral of Update_Vault_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component Update_Vault is
        Port (
            CLK : in STD_LOGIC;
            begin_update: in std_logic;
            mode : in std_logic;
            cnt_5: in std_logic_vector(15 downto 0);
            cnt_10: in std_logic_vector(15 downto 0);
            cnt_20: in std_logic_vector(15 downto 0);
            cnt_50: in std_logic_vector(15 downto 0);
            cnt_100: in std_logic_vector(15 downto 0);
            greedy_5 : in std_logic_vector(15 downto 0);
            greedy_10 : in std_logic_vector(15 downto 0);
            greedy_20 : in std_logic_vector(15 downto 0);
            greedy_50 : in std_logic_vector(15 downto 0);
            greedy_100 : in std_logic_vector(15 downto 0);
            read_5_out : out std_logic_vector(15 downto 0);
            read_10_out : out std_logic_vector(15 downto 0);
            read_20_out : out std_logic_vector(15 downto 0);
            read_50_out : out std_logic_vector(15 downto 0);
            read_100_out : out std_logic_vector(15 downto 0);
            Finished : out std_logic;
            Reset : in std_logic
        );
    end component;

    -- Signals for stimulating the UUT
    signal CLK : std_logic := '0';
    signal begin_update : std_logic := '0';
    signal mode : std_logic := '0';
    signal cnt_5 : std_logic_vector(15 downto 0) := (others => '0');
    signal cnt_10 : std_logic_vector(15 downto 0) := (others => '0');
    signal cnt_20 : std_logic_vector(15 downto 0) := (others => '0');
    signal cnt_50 : std_logic_vector(15 downto 0) := (others => '0');
    signal cnt_100 : std_logic_vector(15 downto 0) := (others => '0');
    signal greedy_5 : std_logic_vector(15 downto 0) := (others => '0');
    signal greedy_10 : std_logic_vector(15 downto 0) := (others => '0');
    signal greedy_20 : std_logic_vector(15 downto 0) := (others => '0');
    signal greedy_50 : std_logic_vector(15 downto 0) := (others => '0');
    signal greedy_100 : std_logic_vector(15 downto 0) := (others => '0');
    signal read_5_out : std_logic_vector(15 downto 0);
    signal read_10_out : std_logic_vector(15 downto 0);
    signal read_20_out : std_logic_vector(15 downto 0);
    signal read_50_out : std_logic_vector(15 downto 0);
    signal read_100_out : std_logic_vector(15 downto 0);
    signal test_output : std_logic_vector(15 downto 0);
    signal Finished : std_logic;
    signal Reset : std_logic := '0';

    -- Clock generation
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Update_Vault
        port map (
            CLK => CLK,
            begin_update => begin_update,
            mode => mode,
            cnt_5 => cnt_5,
            cnt_10 => cnt_10,
            cnt_20 => cnt_20,
            cnt_50 => cnt_50,
            cnt_100 => cnt_100,
            greedy_5 => greedy_5,
            greedy_10 => greedy_10,
            greedy_20 => greedy_20,
            greedy_50 => greedy_50,
            greedy_100 => greedy_100,
            read_5_out => read_5_out,
            read_10_out => read_10_out,
            read_20_out => read_20_out,
            read_50_out => read_50_out,
            read_100_out => read_100_out,
            Finished => Finished,
            Reset => Reset
        );

    -- Clock process
    clk_process: process
    begin
        while True loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        Reset <= '1';
        wait for 20 ns;
        Reset <= '0';

        -- Wait for reset deassertion
        wait for 20 ns;
        begin_update<='0';
        wait for 100 ns;
        -- Test Case 1: Withdrawal Mode
        
        greedy_5 <= std_logic_vector(to_unsigned(2, 16));  -- Withdraw 2 notes of 5 units
        greedy_10 <= std_logic_vector(to_unsigned(1, 16));  -- Withdraw 1 note of 10 units
        greedy_20 <= std_logic_vector(to_unsigned(1, 16));  -- Withdraw 1 note of 20 units
        greedy_50 <= std_logic_vector(to_unsigned(0, 16));  -- No withdrawal of 50 units
        greedy_100 <= std_logic_vector(to_unsigned(0, 16));  -- No withdrawal of 100 units
        
        begin_update <= '1';  -- Begin update
        mode <= '0';  -- Withdrawal mode

        wait for 100 ns;  -- Wait for some time
        
        begin_update <= '0';  -- End update
        wait for 100 ns;  -- Wait for some time

        -- Test Case 2: Deposit Mode
        begin_update <= '1';  -- Begin update
        mode <= '1';  -- Deposit mode
        cnt_5 <= std_logic_vector(to_unsigned(10, 16));  -- Deposit 10 notes of 5 units
        cnt_10 <= std_logic_vector(to_unsigned(5, 16));  -- Deposit 5 notes of 10 units
        cnt_20 <= std_logic_vector(to_unsigned(2, 16));  -- Deposit 2 notes of 20 units
        cnt_50 <= std_logic_vector(to_unsigned(1, 16));  -- Deposit 1 note of 50 units
        cnt_100 <= std_logic_vector(to_unsigned(1, 16));  -- Deposit 1 note of 100 units
        
        wait for 100 ns;  -- Wait for some time
        
        begin_update <= '0';  -- End update
        wait for 100 ns;  -- Wait for some time
        
        greedy_5 <= std_logic_vector(to_unsigned(2, 16));  -- Withdraw 2 notes of 5 units
        greedy_10 <= std_logic_vector(to_unsigned(1, 16));  -- Withdraw 1 note of 10 units
        greedy_20 <= std_logic_vector(to_unsigned(1, 16));  -- Withdraw 1 note of 20 units
        greedy_50 <= std_logic_vector(to_unsigned(0, 16));  -- No withdrawal of 50 units
        greedy_100 <= std_logic_vector(to_unsigned(0, 16));  -- No withdrawal of 100 units
        
        begin_update <= '1';  -- Begin update
        mode <= '0';  -- Withdrawal mode

        wait for 100 ns;  -- Wait for some time
         begin_update <= '0';  -- End update
        wait for 100 ns;  -- Wait for some time
        
         begin_update <= '1';  -- Begin update
        mode <= '1';  -- Deposit mode
        cnt_5 <= std_logic_vector(to_unsigned(12, 16));  -- Deposit 10 notes of 5 units
        cnt_10 <= std_logic_vector(to_unsigned(20, 16));  -- Deposit 5 notes of 10 units
        cnt_20 <= std_logic_vector(to_unsigned(9, 16));  -- Deposit 2 notes of 20 units
        cnt_50 <= std_logic_vector(to_unsigned(10, 16));  -- Deposit 1 note of 50 units
        cnt_100 <= std_logic_vector(to_unsigned(19, 16));  -- Deposit 1 note of 100 units
        
        wait for 100 ns;  -- Wait for some time

         begin_update <= '0';  -- End update
        wait for 100 ns;  -- Wait for some time
        -- Add more test cases as needed
        wait;
    end process;

end Behavioral;

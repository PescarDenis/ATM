library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Update_Withdrawal_tb is
end Update_Withdrawal_tb;

architecture Behavioral of Update_Withdrawal_tb is
    -- Component Declaration for the Unit Under Test (UUT)
    component Update_Withdrawal
        Port (
            CLK          : in  STD_LOGIC;
            begin_update : in  STD_LOGIC;
            cnt_5        : in  STD_LOGIC_VECTOR(15 downto 0);
            cnt_10       : in  STD_LOGIC_VECTOR(15 downto 0);
            cnt_20       : in  STD_LOGIC_VECTOR(15 downto 0);
            cnt_50       : in  STD_LOGIC_VECTOR(15 downto 0);
            cnt_100      : in  STD_LOGIC_VECTOR(15 downto 0);
            read_5       : out STD_LOGIC_VECTOR(15 downto 0);
            read_10      : out STD_LOGIC_VECTOR(15 downto 0);
            read_20      : out STD_LOGIC_VECTOR(15 downto 0);
            read_50      : out STD_LOGIC_VECTOR(15 downto 0);
            read_100     : out STD_LOGIC_VECTOR(15 downto 0);
            test_output: out std_logic_vector(15 downto 0);
            Reset        : in  STD_LOGIC
        );
    end component;

    -- Testbench signals
    signal CLK          : STD_LOGIC := '0';
    signal begin_update : STD_LOGIC := '0';
    signal test_output:  std_logic_vector(15 downto 0);
    signal cnt_5        : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal cnt_10       : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal cnt_20       : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal cnt_50       : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal cnt_100      : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal read_5       : STD_LOGIC_VECTOR(15 downto 0);
    signal read_10      : STD_LOGIC_VECTOR(15 downto 0);
    signal read_20      : STD_LOGIC_VECTOR(15 downto 0);
    signal read_50      : STD_LOGIC_VECTOR(15 downto 0);
    signal read_100     : STD_LOGIC_VECTOR(15 downto 0);
    signal Reset        : STD_LOGIC := '0';

    -- Clock generation
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: Update_Withdrawal
        Port map (
            CLK          => CLK,
            begin_update => begin_update,
            cnt_5        => cnt_5,
            cnt_10       => cnt_10,
            cnt_20       => cnt_20,
            cnt_50       => cnt_50,
            cnt_100      => cnt_100,
            read_5       => read_5,
            read_10      => read_10,
            read_20      => read_20,
            read_50      => read_50,
            read_100     => read_100,
            test_output  => test_output,
            Reset        => Reset
        );

    -- Clock process definitions
    CLK_process : process
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
        -- Reset the system
        
        -- Initial values
        cnt_5 <= "0000000000000101";  -- 5
        cnt_10 <= "0000000000001010"; -- 10
        cnt_20 <= "0000000000010100"; -- 20
        cnt_50 <= "0000000000110010"; -- 50
        cnt_100 <= "0000000001100100"; -- 100
        
        -- Begin update
        begin_update <= '0';
        wait for 100 ns;
        begin_update <= '1';
        wait for 100 ns;
        begin_update <= '0';
                -- Begin update
        wait for 100 ns;
        -- Finish simulation
        wait;
    end process;
end Behavioral;

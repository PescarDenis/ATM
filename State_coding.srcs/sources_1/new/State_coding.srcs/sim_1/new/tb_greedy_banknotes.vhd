library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_greedy_banknotes is
end tb_greedy_banknotes;

architecture Behavioral of tb_greedy_banknotes is
    -- Component declaration for the unit under test (UUT)
    component greedy_banknotes is
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
            end_alg     : out std_logic
        );
    end component;

    -- Testbench signals
    signal bcd_sum     : std_logic_vector(15 downto 0) := (others => '0');
    signal nr_5        : std_logic_vector(15 downto 0) := (others => '0');
    signal nr_10       : std_logic_vector(15 downto 0) := (others => '0');
    signal nr_20       : std_logic_vector(15 downto 0) := (others => '0');
    signal nr_50       : std_logic_vector(15 downto 0) := (others => '0');
    signal nr_100      : std_logic_vector(15 downto 0) := (others => '0');
    signal updated5    : std_logic_vector(15 downto 0);
    signal updated10   : std_logic_vector(15 downto 0);
    signal updated20   : std_logic_vector(15 downto 0);
    signal updated50   : std_logic_vector(15 downto 0);
    signal updated100  : std_logic_vector(15 downto 0);
    signal display5    : std_logic_vector(15 downto 0);
    signal display10   : std_logic_vector(15 downto 0);
    signal display20   : std_logic_vector(15 downto 0);
    signal display50   : std_logic_vector(15 downto 0);
    signal display100  : std_logic_vector(15 downto 0);
    signal start       : std_logic := '0';
    signal end_alg     : std_logic;

begin
    -- Instantiate the unit under test (UUT)
    uut: greedy_banknotes
        port map (
            bcd_sum     => bcd_sum,
            nr_5        => nr_5,
            nr_10       => nr_10,
            nr_20       => nr_20,
            nr_50       => nr_50,
            nr_100      => nr_100,
            updated5    => updated5,
            updated10   => updated10,
            updated20   => updated20,
            updated50   => updated50,
            updated100  => updated100,
            display5    => display5,
            display10   => display10,
            display20   => display20,
            display50   => display50,
            display100  => display100,
            start       => start,
            end_alg     => end_alg
        );

    -- Test process
    test_process: process
    begin
        -- Initialize inputs
        bcd_sum <= "0101011110000000"; -- 780 in BCD
        nr_5    <= "0000000001111111"; -- 9 banknotes of 5
        nr_10   <= "0000000001111111"; -- 8 banknotes of 10
        nr_20   <= "0000000001111111"; -- 7 banknotes of 20
        nr_50   <= "0000000001111111"; -- 6 banknotes of 50
        nr_100  <= "0000000001111111"; -- 5 banknotes of 100
        start   <= '1';
        wait for 100 ns;

        -- Deactivate start signal
        start <= '0';
        wait for 100 ns;

        -- Check the results
        assert end_alg = '1' report "Algorithm did not complete successfully." severity error;

        -- Add more test cases as needed
        -- ...

        wait;
    end process;

end Behavioral;

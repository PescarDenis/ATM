--DAN +DENIS
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
entity Update_Vault is
    Port (
        CLK : in STD_LOGIC;
        begin_update : in std_logic; --signal to know when to update the vault
        mode : in std_logic; --singal to choose with what we update the vault
        cnt_5 : in std_logic_vector(15 downto 0); --the banknotes used for depositing
        cnt_10 : in std_logic_vector(15 downto 0);
        cnt_20 : in std_logic_vector(15 downto 0);
        cnt_50 : in std_logic_vector(15 downto 0);
        cnt_100 : in std_logic_vector(15 downto 0);
        greedy_5 : in std_logic_vector(15 downto 0); --the banknotes after the greedy updates
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
end Update_Vault;

architecture Behavioral of Update_Vault is
    
    component Converter_dec_to_BCD is
        Port (dec_input : in integer;
               bcd_output : out STD_LOGIC_VECTOR (15 downto 0));
    end component;

    component MUX_8_to1 is
        Port (
            i0 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
            i1 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
            i2 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
            i3 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
            i4 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
            i5 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
            i6 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
            i7 : in STD_LOGIC_VECTOR(15 DOWNTO 0);
            sel : in std_logic_vector(2 downto 0);
            output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    end component;

    component DMUX_8_to1 is
        Port (
            o0 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
            o1 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
            o2 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
            o3 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
            o4 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
            o5 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
            o6 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
            o7 : out STD_LOGIC_VECTOR(15 DOWNTO 0);
            sel : in std_logic_vector(2 downto 0);
            input : in STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    end component;

    component DMUX_8_to1_for_load is
        Port (
            o0 : out STD_LOGIC;
            o1 : out STD_LOGIC;
            o2 : out STD_LOGIC;
            o3 : out STD_LOGIC;
            o4 : out STD_LOGIC;
            o5 : out STD_LOGIC;
            o6 : out STD_LOGIC;
            o7 : out STD_LOGIC;
            sel : in std_logic_vector(2 downto 0);
            input : in STD_LOGIC
        );
    end component;

    component RAM_VAULT is
        Port (
            WE : in STD_LOGIC;  -- The write enable activates after we deposit or withdraw a certain amount
            ADDR : in STD_LOGIC_VECTOR (2 downto 0);  -- The address of the memory holds the number of banknotes
            DIN : in STD_LOGIC_VECTOR (15 downto 0);  -- The number of banknotes that we are going to write when we update
            CLK : in STD_LOGIC;
            NR_BANKNOTES : out STD_LOGIC_VECTOR (15 downto 0)  -- The output showing the number of banknotes at the specific address
        );
    end component;

    component Calculate_final_amount is
        Port (
            input1 : in std_logic_vector(15 downto 0);
            input2 : in std_logic_vector(15 downto 0);
            sum : out std_logic_vector(15 downto 0);
            sum_ok : out std_logic := '1'
        );
    end component;

    component Register_load_16bit is
        Port (
            dataIn : in STD_LOGIC_VECTOR (15 downto 0);
            LD : in STD_LOGIC;
            clock : in STD_LOGIC;
            Reset : in STD_LOGIC;
            Q : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    component counter_RAM_banknotes is
        Port (
            clk : in STD_LOGIC;
            enable : in STD_LOGIC;
            Reset : in STD_LOGIC;
            Carry : out STD_LOGIC;
            Q : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    component MUX_2_to_1 is
        Port (
            sel : in STD_LOGIC;
            input1 : in STD_LOGIC_VECTOR (2 downto 0);
            input2 : in STD_LOGIC_VECTOR (2 downto 0);
            output : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    component Mux_2_to_1_16bit is
        Port (
            input0 : in STD_LOGIC_VECTOR (15 downto 0);
            input1 : in STD_LOGIC_VECTOR (15 downto 0);
            sel : in STD_LOGIC;
            output : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    signal nr_5 : STD_LOGIC_VECTOR(15 downto 0);
    signal nr_10 : STD_LOGIC_VECTOR(15 downto 0);
    signal nr_20 : STD_LOGIC_VECTOR(15 downto 0);
    signal nr_50 : STD_LOGIC_VECTOR(15 downto 0);
    signal nr_100 : STD_LOGIC_VECTOR(15 downto 0);
    signal out5 : std_Logic_vector(15 downto 0);
    signal out6 : std_Logic_vector(15 downto 0);
    signal out7 : std_Logic_vector(15 downto 0);

    signal enable1 : STD_LOGIC;
    signal enable2 : STD_LOGIC;
    signal enable3 : STD_LOGIC;
    signal enable4 : STD_LOGIC;
    signal enable5 : STD_LOGIC;
    signal enable6 : STD_LOGIC; -- 6, 7, and 8 are never used
    signal enable7 : STD_LOGIC;
    signal enable8 : STD_LOGIC;

    signal read_from_vault : STD_LOGIC;

    signal updated_5 : STD_LOGIC_VECTOR(15 downto 0);
    signal updated_10 : STD_LOGIC_VECTOR(15 downto 0);
    signal updated_20 : STD_LOGIC_VECTOR(15 downto 0);
    signal updated_50 : STD_LOGIC_VECTOR(15 downto 0);
    signal updated_100 : STD_LOGIC_VECTOR(15 downto 0);

    signal read_5 : STD_LOGIC_VECTOR(15 downto 0);
    signal read_10 : STD_LOGIC_VECTOR(15 downto 0);
    signal read_20 : STD_LOGIC_VECTOR(15 downto 0);
    signal read_50 : STD_LOGIC_VECTOR(15 downto 0);
    signal read_100 : STD_LOGIC_VECTOR(15 downto 0);

    signal Finished_read : std_logic;
    signal Finished_write : std_logic;
    signal ADDR : std_logic_vector(2 downto 0);
    signal ADDR_WRITE : STD_LOGIC_VECTOR(2 downto 0);
    signal ADDR_READ : STD_LOGIC_VECTOR(2 downto 0);
    signal Updated_banknote : std_logic_vector(15 downto 0);
    signal Updated_greedy : std_logic_vector(15 downto 0);
    signal nr_banknotes : std_logic_vector(15 downto 0);
    signal val_to_write : std_logic_vector(15 downto 0);

    signal ok1 : STD_LOGIC;
    signal ok2 : STD_LOGIC;
    signal ok3 : STD_LOGIC;
    signal ok4 : STD_LOGIC;
    signal ok5 : STD_LOGIC;
begin

    
--this component is used for updating the vault, and storing the current number of banknotes in the vault
--it has 2 counters, 1 for the reading and the other for writing, they reset when the the write or read is active
--for example, the reading counter reset when writing becomes 1( begin_update)
--the 2:1 mux on 3 bit3 is used for outputing the address,either we read or write
--the 2:1 mux on 16 bits is used to load the actualy value of the banknote to be written in the memory
--the 2 dmuxes are used to load the numbers into register, and to activate the load in the registers
--the registers are used to hold the information,until we overwrite the information
    process(begin_update)
    begin
        if begin_update = '0' then
            read_from_vault <= '1';
        else
            read_from_vault <= '0';
        end if;
    end process;

    c1: counter_RAM_banknotes port map(CLK, begin_update, read_from_vault, Finished_write, ADDR_WRITE);
    c2: counter_RAM_banknotes port map(CLK, read_from_vault, begin_update, Finished_read, ADDR_READ);

    mux_addr: MUX_2_to_1 port map(begin_update, ADDR_READ, ADDR_WRITE, ADDR);
    mux_with_or_dep: Mux_2_to_1_16bit port map(Updated_greedy, Updated_banknote, mode, val_to_write);

    c3: MUX_8_to1 port map(updated_5, updated_10, updated_20, updated_50, updated_100, (others => '0'), (others => '0'), (others => '0'), ADDR_WRITE, Updated_banknote);
    c4: MUX_8_to1 port map(greedy_5, greedy_10, greedy_20, greedy_50, greedy_100, (others => '0'), (others => '0'), (others => '0'), ADDR_WRITE, Updated_greedy);
    c5: RAM_VAULT port map(begin_update, ADDR, val_to_write, CLK, nr_banknotes);

    c6: DMUX_8_to1 port map(nr_5, nr_10, nr_20, nr_50, nr_100, out5, out6, out7, ADDR_READ, nr_banknotes);
    c7: DMUX_8_to1_for_load port map(enable1, enable2, enable3, enable4, enable5, enable6, enable7, enable8, ADDR_READ, '1');

    Reg1: Register_load_16bit port map(nr_5, enable1, CLK, '0', read_5);
    Reg2: Register_load_16bit port map(nr_10, enable2, CLK, '0', read_10);
    Reg3: Register_load_16bit port map(nr_20, enable3, CLK, '0', read_20);
    Reg4: Register_load_16bit port map(nr_50, enable4, CLK, '0', read_50);
    Reg5: Register_load_16bit port map(nr_100, enable5, CLK, '0', read_100);
    
    process(cnt_5, cnt_10, cnt_20, cnt_50, cnt_100, read_5, read_10, read_20, read_50, read_100)
    begin
        updated_5 <= cnt_5 + read_5;
        updated_10 <= cnt_10 + read_10;
        updated_20 <= cnt_20 + read_20;
        updated_50 <= cnt_50 + read_50;
        updated_100 <= cnt_100 + read_100;
    end process;
    read_5_out <= read_5;
    read_10_out <= read_10;
    read_20_out <= read_20;
    read_50_out <= read_50;
    read_100_out <= read_100;
    Finished <= Finished_write;
end Behavioral;

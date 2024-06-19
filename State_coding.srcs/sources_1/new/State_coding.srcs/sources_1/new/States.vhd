--denis+dan
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity State_coding is
   Port(   rows : in STD_LOGIC_VECTOR (1 to 4); --pmod usage
           columns : buffer STD_LOGIC_VECTOR (1 to 4) := "1111";
           CLK : in STD_LOGIC; --clock of 100MHz
           start:in std_logic;--start button of the fpga
           sold_btn:in std_logic; -- this is the sold button
           deposit_btn: in std_logic; --deposit
           withdrawal_btn : in std_logic; --withdrawal
           transfer_btn: in std_logic; --transfer
           AOP_ok : in STD_LOGIC; --aop
           btn_5: in std_logic; --butons for depositing banknotes
           btn_10: in std_logic;
           btn_20: in std_logic;
           btn_50: in std_logic;
           btn_100: in std_logic;
           LED_5: out std_logic; --led used in the withdrawal state for each type of banknote
           LED_10: out std_logic;
           LED_20: out std_logic;
           LED_50: out std_logic;
           LED_100: out std_logic;
           CATOD : out STD_LOGIC_VECTOR (6 downto 0); --SSD
           ANOD : out STD_LOGIC_VECTOR (7 downto 0));
end State_coding;

architecture Behavioral of State_coding is

component SSD is
    Port ( CLK100 : in STD_LOGIC; --clock of 100MHZ
            PIN :in STD_LOGIC_VECTOR (15 downto 0); -- this is not actually just the pin, is a BCD number on 16 bits
            mode:in std_logic_vector(3 downto 0); --mode is used for what we want to display
           CATOD : out STD_LOGIC_VECTOR (6 downto 0);
           ANOD : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component PMOD is
    Port ( rows : in STD_LOGIC_VECTOR (1 to 4);  --PMOD keypad conections
           columns : buffer STD_LOGIC_VECTOR (1 to 4) := "1111";
           Reset : in STD_LOGIC; --Reset beacuse it is for several other things not only for the pin
           PIN: out std_logic_vector(15 downto 0); --Pmod is actually used for pin,whitdrwal,and transfer
           next_ok: out std_logic; --the button "F" for transitioning from one state to another
           PIN_finished : out STD_LOGIC; --finished introducing 4 digits
           CLK : in STD_LOGIC); --100MHZ clock but we divide in the comp
end component;

component Top_Module_Verif is
    Port ( PIN :in std_logic_vector(15 downto 0); --The pin introduced from the pmod
           start:in std_logic; --this is the output PIn finished from the pmo
           clk : in STD_LOGIC; --100MHZ clk
           Reset : in STD_LOGIC; --Reset because we are using twice
           address : out STD_LOGIC_VECTOR(2 downto 0); --the adress of the pin, used for knowing at what address we update 
           PIN_OK : out STD_LOGIC); --fininshed signal to control the next state in some states
end component;

component RAM_SOLD is
    Port ( WE : in STD_LOGIC; --the write enable activates after we deposit or withdrawl a certain amount
           ADDR : in STD_LOGIC_VECTOR (2 downto 0); --the address of the memory is also the address that hold the pin value in the rom
           DIN : in STD_LOGIC_VECTOR (15 downto 0); --the sum that we are going to write when we update
           CLK : in STD_LOGIC;
           SUM: out STD_LOGIC_VECTOR (15 downto 0)); --each pin address holds the value of the sum on 16 bits
end component;

component sum_creator_deposit is --used for depositing with the debounced buttons(not monoimpulse)
    Port ( clk : in STD_LOGIC;--clk of 100 MHZ
           Reset : in STD_LOGIC;            
           input_5 : in STD_LOGIC; --the buttons from the FPGA
           input_10 : in STD_LOGIC;
           input_20 : in STD_LOGIC;
           input_50 : in STD_LOGIC;
           input_100 : in STD_LOGIC;
           sum_deposit: out std_logic_vector(15 downto 0); --The outputed sum,constructed for depositing
           cnt_5: out std_logic_vector(15 downto 0); --this are used for updating in the RAM vault, number of banknotes of each type introduced 
           cnt_10: out std_logic_vector(15 downto 0);
           cnt_20: out std_logic_vector(15 downto 0);
           cnt_50: out std_logic_vector(15 downto 0);
           cnt_100: out std_logic_vector(15 downto 0));
end component;

component  Update_Vault is
    Port ( CLK : in STD_LOGIC; --slow clk
           begin_update: in std_logic; --when to read or write in the RAM vault
           mode : in std_logic; --mode used for read or either write the updated bnks after greedy or write for the deposited bnks
           cnt_5: in std_logic_vector(15 downto 0); -- these are the outputs, nr of each banknote after depositing
           cnt_10: in std_logic_vector(15 downto 0);
           cnt_20: in std_logic_vector(15 downto 0);
           cnt_50: in std_logic_vector(15 downto 0);
           cnt_100: in std_logic_vector(15 downto 0);
           greedy_5 : in std_logic_vector(15 downto 0); --these are the updated bnks after greedy
           greedy_10 : in std_logic_vector(15 downto 0);
           greedy_20 : in std_logic_vector(15 downto 0);
           greedy_50 : in std_logic_vector(15 downto 0);
           greedy_100 : in std_logic_vector(15 downto 0);
           read_5_out : out std_logic_vector(15 downto 0); --these are the banknotes in the ram vault memory after reading from it
           read_10_out : out std_logic_vector(15 downto 0);
           read_20_out : out std_logic_vector(15 downto 0);
           read_50_out : out std_logic_vector(15 downto 0);
           read_100_out : out std_logic_vector(15 downto 0);
           Finished : out std_logic; --the output is '1' when we are done writing
           Reset:in std_logic); --reset
end component;

component Calculate_final_amount is
Port ( 
    input1: in std_logic_vector(15 downto 0); -- takes to inputs in BCD and is used for depositing
    input2 : in std_logic_vector(15 downto 0);
    sum: out std_logic_vector(15 downto 0); --the output of the sum is also in BCD after the update
    sum_ok:out std_logic :='1' --a verif signal to say if we can deposit or not
    );
end component;

component Verif_withdrawal_module is
    Port ( Sum_introduced : in STD_LOGIC_VECTOR (15 downto 0);  -- sum introduced from the pmod to withdraw
           Sum_PIN : in STD_LOGIC_VECTOR (15 downto 0); --sum at the current pin introduced
           Sum_to_write:out std_logic_vector(15 downto 0); --the sum to write after update in the RAM
           Verif_ok : out STD_LOGIC :='1'); -- a verif signal to say if we can extract or not
end component;

component Top_Module_Transfer is
    Port ( transfer_sum : in STD_LOGIC_VECTOR (15 downto 0); --the sum that we want to transfer
           summ1 : in STD_LOGIC_VECTOR (15 downto 0); --sum at each pin
           summ2 : in STD_LOGIC_VECTOR (15 downto 0);
           updated_sum1 : out STD_LOGIC_VECTOR (15 downto 0); --the sum after the subtraction for the first pin
           updated_sum2 : out STD_LOGIC_VECTOR (15 downto 0); --the sum after addition for the second pin
           verif_ok : out STD_LOGIC); -- if we can transfer
end component;

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
        start       : in std_logic; --start the algo
        end_alg :    out STD_LOGIC --end the algo
    );
end component;

component Slow_Clock is
port(
 clk: in std_logic; -- input clock on FPGA 100Mhz               
 slow_clk_enable: out std_logic
);
end component;

component save_greedy_values is --16 bit storing registers
    Port ( clk : in STD_LOGIC; --slow clk 
           input5 : in STD_LOGIC_VECTOR (15 downto 0); --the inputs of the register
           input10 : in STD_LOGIC_VECTOR (15 downto 0);
           input20 : in STD_LOGIC_VECTOR (15 downto 0);
           input50 : in STD_LOGIC_VECTOR (15 downto 0);
           input100 : in STD_LOGIC_VECTOR (15 downto 0);
           load_greedy_reg : in STD_LOGIC; --load
           reset_reg : in STD_LOGIC; --reset
           output5 : out STD_LOGIC_VECTOR(15 downto 0); --output of the regiters
           output10 : out STD_LOGIC_VECTOR(15 downto 0);
           output20 : out STD_LOGIC_VECTOR(15 downto 0);
           output50 : out STD_LOGIC_VECTOR(15 downto 0);
           output100 : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component Reg_hold_greedy is -- 1 bit storing register
    Port ( load : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           Q : out STD_LOGIC);
end component;

component Mux_2_to_1_1bit is -- mux used for control of the RAM vault
    Port ( input0 : in STD_LOGIC;
           input1 : in STD_LOGIC;
           sel : in STD_LOGIC;
           output : out STD_LOGIC);
end component;

type STATE_type is (idle,init,PIN_afis,Intr_Pin,ERR_PIN,ACC_PIN,OP,print_sold,deposit,ACC_DEPOSIT,ERR_DEPOSIT,AOP,withdrawal,ERR_withdrawal,ACC_withdrawal,transfer,ERR_PIN2,ACC_PIN2,Intr_transfer,ACC_transfer,ERR_transfer,print_5,print_10,print_20,print_50,print_100,dont1,dont2,dont3,dont4,dont5); 
signal current_state,next_state:STATE_type; --the defined states
signal display_mode:std_logic_vector(3 downto 0); --signal used for SSD, in the mux cathode to know what to print
signal counter: integer := 0; --for staying in the temporary states
constant TIMEOUT: integer := 300; --what time we stay in the temporary states

signal final_amount: std_logic_vector(15 downto 0) := (others=>'0'); --used for deposit
signal final_amount_deposit: std_logic_vector(15 downto 0) := (others=>'0'); --used for deposit
signal final_amount_withdrawal: std_logic_vector(15 downto 0) := (others=>'0'); --used for deposit
signal verif_withdrawal:std_logic; --verification signals
signal deposit_verif: std_logic;
signal verif_transfer:std_logic;
signal begin_update_RAM: std_logic; --to know when to write/read in the balance RAM(sum at each pin)
signal begin_update_vault:std_logic; --to read or write in the RAM vault
signal Reset_deposit:std_logic; --resets
signal Reset_PMOD: std_logic;
signal slow_clk: std_logic; --slow clock used for transitions
signal next_ok:std_logic; --signal to go from a next state to another based on the state diagram 
signal Number_from_Pmod:std_logic_vector(15 downto 0); --the outputed number from PMOD keypad
signal start_verif:std_logic; --signal to go into the verif component when the pin is finished computing
signal PIN_ok:std_logic; -- a signal to tell if the intorduced pin was correct or not
signal PIN_ok2:std_logic;--signal for the second pin
signal saved_address_of_the_pin:std_logic_vector(2 downto 0); --address in the ram
signal saved_address_of_the_pin2: std_logic_vector(2 downto 0); --the saved adresses of the pin for transfer
signal saved_address_of_the_pin1: std_logic_vector(2 downto 0);
signal sum_at_pin:std_logic_vector(15 downto 0); --the sum in the ram memory
signal sum1:std_logic_vector(15 downto 0); --the sum at the first pin 
signal sum2: std_logic_vector(15 downto 0); --the sum at the second pin
signal transfer_amount:std_logic_vector(15 downto 0); -- the sum introduced from pmod that we want to transfer
signal final_amount1: std_logic_vector(15 downto 0); -- the sum of the first account after we transfer the money
signal final_amount2: std_logic_vector(15 downto 0); -- the sum of the second account after we transfer the money
signal sum_to_deposit: std_logic_vector(15 downto 0); -- the sum to deposit
signal print_number_ssd: std_logic_vector(15 downto 0); -- depending on the current state, what to print on the ssd
signal pin_saved1 : std_logic_vector(15 downto 0);-- this is the the first pin intially introduced 
signal pin_saved2 :std_logic_vector (15 downto 0); -- the second pin intorduced for the transfer

signal nr_banknotes_5: std_logic_vector(15 downto 0); --outputs of the deposit.Each type of banknote that we want to deposit( in the deposit state
signal nr_banknotes_10: std_logic_vector(15 downto 0); --from the debounced buttons
signal nr_banknotes_20: std_logic_vector(15 downto 0);
signal nr_banknotes_50: std_logic_vector(15 downto 0);
signal nr_banknotes_100: std_logic_vector(15 downto 0);

signal read_bnk_5: STD_LOGIC_VECTOR(15 downto 0); --the banknotes in the RAM vault memory
signal read_bnk_10: STD_LOGIC_VECTOR(15 downto 0);
signal read_bnk_20: STD_LOGIC_VECTOR(15 downto 0);
signal read_bnk_50: STD_LOGIC_VECTOR(15 downto 0);
signal read_bnk_100: STD_LOGIC_VECTOR(15 downto 0);

signal output5_greedy:std_logic_vector(15 downto 0); --output of the number of banknotes after greedy aglorithm( not updated)
signal output10_greedy:std_logic_vector(15 downto 0);
signal output20_greedy:std_logic_vector(15 downto 0);
signal output50_greedy:std_logic_vector(15 downto 0);
signal output100_greedy:std_logic_vector(15 downto 0);

signal display5_greedy:std_logic_vector(15 downto 0); --used as outputs of the storing register(what we actually display on the SSD)
signal display10_greedy:std_logic_vector(15 downto 0);
signal display20_greedy:std_logic_vector(15 downto 0);
signal display50_greedy:std_logic_vector(15 downto 0);
signal display100_greedy:std_logic_vector(15 downto 0);


signal updated_bnk_5 : STD_LOGIC_VECTOR(15 downto 0); --updated banknnotes after the greedy algorithms
signal updated_bnk_10 : STD_LOGIC_VECTOR(15 downto 0);
signal updated_bnk_20 : STD_LOGIC_VECTOR(15 downto 0);
signal updated_bnk_50 : STD_LOGIC_VECTOR(15 downto 0);
signal updated_bnk_100 : STD_LOGIC_VECTOR(15 downto 0);

signal start_greedy : STD_LOGIC; --start or end greedy signals
signal end_greedy : STD_LOGIC;

signal reset_greedy_reg_val : std_logic;-- reset the registers which holds the outputs of the greedy algorithm
signal using_greedy_operator :std_logic; --this are the outputs of the 1 bit reg in order to know what to write in RAM vault
signal using_deposit_operator:std_logic;

signal updated5_greedy:std_logic_vector(15 downto 0); --the output of the register in where we store the updated banknotes to keep track of them(greedy)
signal updated10_greedy:std_logic_vector(15 downto 0);
signal updated20_greedy:std_logic_vector(15 downto 0);
signal updated50_greedy:std_logic_vector(15 downto 0);
signal updated100_greedy:std_logic_vector(15 downto 0);

signal mode: std_logic; --mode used for mux
signal mode_out : std_logic; --output of the 1 bit register for mode
signal ctrl_update : std_logic; --to know what mux we use in update vault
signal Finished : std_logic; --finished output of the update vault when we are done writing

begin


Transitions: process(slow_clk) --process for transitioning from one state to another
    begin
        if start = '0' then --start as input and async
            current_state <= idle;
        elsif rising_edge(slow_clk) then
                 current_state <= next_state; --compute the next state
                if current_state = PIN_afis or current_state=ERR_PIN or current_state=ACC_PIN or current_state=ACC_deposit or current_state=ERR_deposit or current_state=ERR_withdrawal
                 or current_state=ACC_PIN2 or current_state=ERR_PIN2 or current_state=ACC_transfer or 
                 current_state=ERR_transfer or current_state=ACC_withdrawal or current_state = print_5 or current_state = print_10 
                 or current_state = print_20 or current_state = print_50 or current_state = print_100 then 
                    if counter < TIMEOUT then --all the intermediate states
                        counter <= counter + 1; --this works like a freq divider,we stay in the intermediate states for around 3 seconds
                   else
                        counter <= 0; --if the counter is greater than timeout reset it
                    end if;
                else
                    counter <= 0; --if we are not in intermediate state it does not matter
                end if;
            end if;
 end process Transitions;
 
Computing_states: process(current_state,start,PIN_ok,PIN_ok2,sold_btn,next_ok,AOP_ok,deposit_btn,deposit_verif,withdrawal_btn,verif_withdrawal,transfer_btn,verif_transfer)
--process for computing all the states 
begin
    mode <= '0'; --default values at the startinf of the process is 0 for all the used signal
    reset_greedy_reg_val <= '0';
    start_greedy <= '0';
    display_mode <= "0000"; -- Default value 
    print_number_ssd <= (others => '0'); -- Default value
    begin_update_RAM<='0'; -- for knowing when to update the RAM
    begin_update_vault<='0';
    Reset_PMOD<='0'; 
    Reset_deposit<='0';
    LED_5 <= '0'; LED_10 <= '0'; LED_20 <= '0'; LED_50 <= '0'; LED_100 <= '0';
    case current_state is
        when idle => --in IDLE we print on SSD "- - - -"
        Reset_PMOD<='1'; --reset all the pmod
        Reset_deposit<='1'; --reset deposit
            if start = '1' then
                next_state <= init; --go to the init state
            else
                next_state <= idle;
            end if;

        when init =>
            if next_ok = '1' then --we need to press the button "F" on the pmod to go from one state to another
                next_state <= PIN_afis;
            else
                next_state <= init;
                display_mode <= "0001"; -- CArd
            end if;

        when PIN_afis =>
          display_mode <= "0010"; --PIn
            if counter >= TIMEOUT then
                    next_state <= Intr_PIN;
               else
                    next_state <= PIN_afis;
              end if;
              
      when Intr_PIN =>
       pin_saved1 <= Number_from_Pmod; --save pin to compare it with the second one
       print_number_ssd<=Number_from_Pmod;
        display_mode <= "0011"; --The pin introduced from the user
               if(next_ok ='1' and start_verif = '1') then --start verif if the pin is valid and pressed "F"
                     if(PIN_ok='1') then
                           next_state <=ACC_PIN;
                      else
                          next_state <=ERR_PIN;
                      end if;
                else
                    next_state<=Intr_PIN;
                end if;
                
       when ACC_PIN =>
               sum1 <= sum_at_pin; --we store the sum at the first pine
               display_mode <= "0100"; -- ACC
            if counter >= TIMEOUT  then
                    next_state <= OP;
               else
                    next_state <= ACC_PIN;
              end if;
              
       when ERR_PIN =>
             display_mode <= "0101"; -- Err
             Reset_PMOD<='1'; --reset the pmod component if err state
            if counter >= TIMEOUT  then
                    next_state <= Intr_PIN;
               else
                    next_state <= ERR_PIN;
              end if;
              
       when OP =>
       display_mode<="0110"; --OP
       begin_update_RAM <= '0';-- we read from ram in here
       sum1 <= sum_at_pin; --this is used for not loosing the info on the first pin
                if(next_ok='1') then  --then press the next ok
                    if(sold_btn ='1') then --firs choose the button,depending on what OP we want to choose
                        next_state<=print_sold;
                    elsif(deposit_btn='1') then
                        next_state<=deposit;
                    elsif(withdrawal_btn='1') then
                         Reset_PMOD<='1';
                        next_state<=withdrawal;
                    elsif(transfer_btn='1') then
                        Reset_PMOD<='1';
                        next_state<= transfer;
                    else
                        next_state<=OP; --stay in op
                    end if;
                  else
                  next_state<=OP; --stay in op
                 end if;
                 
        when print_sold=>
            display_mode <= "0011"; --The sum at the specific address
            print_number_ssd<=sum_at_pin; --after we are done with our pin, we can assign the value of the next thing we want to print, which is the sum
                if(next_ok='1') then
                    next_state<=AOP;
                else
                    next_state<=print_sold;
                end if;
                
         when deposit =>
            display_mode<="0011";
            print_number_ssd<=sum_to_deposit; --we print the sum in real time
            if(next_ok='1') then
               if(deposit_verif = '1') then --if next ok and we can deposit
                    begin_update_RAM<='1'; --update ram sold
                        begin_update_vault<='1';--and also the vault
                         mode <= '1'; --mode 1 is used in the update vault comp to write the number of each bnk deposited
                    next_state <= ACC_DEPOSIT;
               else 
                next_state <= ERR_DEPOSIT;
               end if;
             else
                next_state<=deposit;
             end if;

         when ACC_DEPOSIT =>
            display_mode <= "0100"; -- ACC
            if counter >= TIMEOUT then
                next_state <= AOP;
            else next_state <= ACC_DEPOSIT;
            end if;
            
            
         when ERR_DEPOSIT =>
            display_mode <= "1000";
             Reset_deposit <= '1';
            if counter >= TIMEOUT then
                next_state <= deposit;
            else 
                next_state <= ERR_DEPOSIT;
            end if;
            
          when withdrawal =>
           Reset_PMOD<='0'; --we already reseted it
           print_number_ssd<=Number_from_Pmod;
           display_mode <= "0011"; --The sum to withdrawal 
           if(next_ok='1' and start_verif='1') then
             start_greedy<='1'; --start the greedy async comp
                if(verif_withdrawal='1' and end_greedy='1') then --if the sum to withdrawal is ok and also the algorithm has endded
                    begin_update_RAM<='1'; --update the ram sold
                    mode <= '0'; --mode is 0 to udpate the vault with the updated greedy banknotes
                    next_state<=ACC_withdrawal;
               else
                    begin_update_RAM<='0'; --read the banknotes
                    next_state<= ERR_withdrawal; 
                  end if;
          else
            next_state<= withdrawal; 
             end if;
          
          when ACC_withdrawal =>
          display_mode <= "0100"; -- ACC
            if counter >= TIMEOUT then
                next_state <= dont1;
            else next_state <= ACC_withdrawal;
            end if;
            
         when dont1 =>
            next_state<=print_5;--this is a null state, to be able to transitions and stay in the temporary states and print the number of greedy banknotes
            
          when print_5 => 
          display_mode <= "0011";
             print_number_ssd <= display5_greedy; --display the nr of banknotes of 5
             LED_5 <= '1'; LED_10 <= '0'; LED_20 <= '0'; LED_50 <= '0'; LED_100 <= '0'; --activate the led5
           
             if counter >= TIMEOUT then
                next_state <= dont2;
             else next_state <= print_5;
             end if;
          --the same goes for all other printing states, as the first one, it only depends on the number of banknotes printed on the ssd
          when dont2 =>
           display_mode <= "0011";
          print_number_ssd <= display5_greedy;
          next_state<=print_10;
          
          when print_10 => display_mode <= "0011";
             print_number_ssd <= display10_greedy;
             LED_5 <= '0'; LED_10 <= '1'; LED_20 <= '0'; LED_50 <= '0'; LED_100 <= '0';
           
             if counter >= TIMEOUT then 
                next_state <= dont3;
             else next_state <= print_10;
             end if;
           
           when dont3=>
           display_mode <= "0011";
             print_number_ssd <= display10_greedy;
            next_state<=print_20;
             
          when print_20 => display_mode <= "0011";
             print_number_ssd <= display20_greedy;
             LED_5 <= '0'; LED_10 <= '0'; LED_20 <= '1'; LED_50 <= '0'; LED_100 <= '0';
           
             if counter >= TIMEOUT then
                next_state <= dont4;
             else next_state <= print_20;
             end if;
            
           when dont4=>
           display_mode <= "0011";
             print_number_ssd <= display20_greedy;
            next_state<=print_50;
            
            when print_50 => display_mode <= "0011";
             print_number_ssd <= display50_greedy;
             LED_5 <= '0'; LED_10 <= '0'; LED_20 <= '0'; LED_50 <= '1'; LED_100 <= '0';
           
             if counter >= TIMEOUT then 
                next_state <= dont5;
             else next_state <= print_50;
             end if;
             
             when dont5 =>
             display_mode <= "0011";
             print_number_ssd <= display50_greedy;
                next_state<=print_100;
                
            when print_100 => display_mode <= "0011";
             print_number_ssd <= display100_greedy;
             LED_5 <= '0'; LED_10 <= '0'; LED_20 <= '0'; LED_50 <= '0'; LED_100 <= '1';
           
             if counter >= TIMEOUT then 
                next_state <= AOP;
             else next_state <= print_100;
             end if;
             
          when ERR_withdrawal =>
          display_mode <= "0101"; -- Err
           Reset_PMOD<='1';
            if counter >= TIMEOUT then
                    next_state <= withdrawal;
               else
                    next_state <= ERR_withdrawal;
              end if;
              
          when transfer =>
            Reset_PMOD<='0'; --we already reseted it
            pin_saved2<=Number_from_Pmod; -- we save the pin to be able to work with it further on
            print_number_ssd<=Number_from_Pmod; -- the second introduced Pin
            display_mode<="0011"; 
            if(next_ok='1' and start_verif='1') then
                if(PIN_ok2='1'  and pin_saved1/=pin_saved2) then --check if the pin is ok and different from the first one
                next_state<=ACC_PIN2;
             else
                next_state<=ERR_PIN2;
                end if;
             else
                next_state<=transfer;
            end if;     
            
          when ACC_PIN2 =>
          begin_update_RAM<='0'; --read from the ram sold
          sum2<= sum_at_pin; -- this is the sum at the second address
            display_mode <= "0100"; -- ACC
            Reset_Pmod<='1'; --we reset regarding of the next_state, because we need to introduce the sum
            if counter >= TIMEOUT then
                    next_state <= Intr_transfer;
               else
                    next_state <= ACC_PIN2;
              end if;
           
         when ERR_PIN2 =>
         display_mode <= "0101"; -- Err
         Reset_Pmod<='1'; --we reset regarding of the next_state
            if counter >= TIMEOUT then
                    next_state <= transfer;
               else
                    next_state <= ERR_PIN2;
              end if;
         
         when Intr_transfer =>
         Reset_PMOD<='0'; --we already reseted it
         print_number_ssd<=Number_from_Pmod;
         transfer_amount<=Number_from_Pmod; --this is the sum to transfer
         begin_update_RAM<='1'; --we need to update the ram 2 times, one for the first pin and the other time for the second pin
         display_mode <= "0011"; --print it on the ssd
           if(next_ok='1' and start_verif='1') then
                if(verif_transfer='1') then
                    next_state<=ACC_transfer;
                 else
                    next_state<=ERR_transfer;
                 end if;
            else
                next_state<=Intr_transfer;                    
             end if;
             
         when ACC_transfer =>
          begin_update_RAM<='1';
         display_mode <= "0100"; -- ACC
            if counter >= TIMEOUT then
                    next_state <= AOP;
               else
                    next_state <= ACC_transfer;
              end if;
         
          when ERR_transfer =>
          display_mode <= "0101"; -- Err
           Reset_PMOD<='1';
            if counter >= TIMEOUT then
                    next_state <= Intr_transfer;
               else
                    next_state <= ERR_transfer;
              end if;

         when AOP =>
            display_mode<="0111";
            reset_greedy_reg_val <= '1'; --in aop we reset the register
            Reset_deposit<='1';
            if(next_ok='1') then
                if(AOP_ok = '1') then 
                    next_state <= OP;
                else
                Reset_PMOD<='1'; 
                next_state<= Init;
                end if;
            else
                next_state<= AOP;
             end if;
             
       when others=>
                next_state <= idle;
    end case;
end process Computing_states;

store_addresses: process (slow_clk) -- a process used for storing the address or the amounts to deposit/withdraw
begin
    if(rising_edge(slow_clk)) then
    case current_state is
        when ACC_PIN =>
            saved_address_of_the_pin<=saved_address_of_the_pin1; --used to save the address of the first pine
        when deposit =>
            final_amount <= final_amount_deposit;
        when withdrawal =>
            final_amount <= final_amount_withdrawal;
        when transfer=>
            saved_address_of_the_pin<=saved_address_of_the_pin2; --the address of the second pint
        when Intr_transfer =>
            final_amount<=final_amount2; --we update the second account
        when ACC_transfer =>
           saved_address_of_the_pin<=saved_address_of_the_pin1; --update the first account
           final_amount <=final_amount1; --do operations on the first pin
        when AOP =>
        saved_address_of_the_pin<=saved_address_of_the_pin1; -- in case we reach AOP, we make the operations on the first address of the pin
        when others =>
            final_amount <= (others => '0'); 
    end case;
    end if;
end process store_addresses;
--instantiasions of the components and connecting them
--What each component do is described in particular in their top module
c0: PMOD port map(rows,columns,Reset_PMOD ,Number_from_Pmod,next_ok,start_verif,CLK);
c1: Top_Module_verif port map(pin_saved1,start_verif,CLK,Reset_PMOD,saved_address_of_the_pin1,PIN_ok);
c2: RAM_SOLD port map(begin_update_RAM,saved_address_of_the_pin,final_amount,slow_clk,sum_at_pin);
c3: SSD port map(CLK,print_number_ssd,display_mode,CATOD,ANOD);
c4: Slow_Clock port map(CLK,slow_clk);
c5: sum_creator_deposit port map(CLK,Reset_deposit,btn_5,btn_10,btn_20,btn_50,btn_100,sum_to_deposit,nr_banknotes_5,nr_banknotes_10,nr_banknotes_20,nr_banknotes_50,nr_banknotes_100);
c6: Update_Vault port map(slow_clk,ctrl_update,mode_out,nr_banknotes_5,nr_banknotes_10,nr_banknotes_20,nr_banknotes_50,nr_banknotes_100,updated5_greedy,updated10_greedy,updated20_greedy,updated50_greedy,updated100_greedy,read_bnk_5,read_bnk_10,read_bnk_20,read_bnk_50,read_bnk_100,Finished,Reset_deposit);
c7: Calculate_final_amount port map(sum_at_pin,sum_to_deposit,final_amount_deposit,deposit_verif);
c8: Verif_withdrawal_module port map(Number_from_Pmod,sum_at_pin,final_amount_withdrawal,verif_withdrawal);
c9: Top_Module_verif port map(pin_saved2,start_verif,CLK,Reset_PMOD,saved_address_of_the_pin2,PIN_ok2); -- this is the verification for the second pin
c10: Top_Module_Transfer port map(transfer_amount,sum1,sum2,final_amount1,final_amount2,verif_transfer);
c11: greedy_banknotes port map(Number_from_Pmod,read_bnk_5,read_bnk_10,read_bnk_20,read_bnk_50,read_bnk_100,updated_bnk_5,updated_bnk_10,updated_bnk_20,updated_bnk_50,updated_bnk_100,output5_greedy,output10_greedy,output20_greedy,output50_greedy,output100_greedy,start_greedy,end_greedy);
c12 : save_greedy_values port map(slow_clk,output5_greedy,output10_greedy,output20_greedy,output50_greedy,output100_greedy,end_greedy,reset_greedy_reg_val,display5_greedy,display10_greedy,display20_greedy,display50_greedy,display100_greedy);
c13 : save_greedy_values port map(slow_clk,updated_bnk_5,updated_bnk_10,updated_bnk_20,updated_bnk_50,updated_bnk_100,end_greedy,reset_greedy_reg_val,updated5_greedy,updated10_greedy,updated20_greedy,updated50_greedy,updated100_greedy);
reg_hold_withdrawal: Reg_hold_greedy port map(end_greedy,slow_clk,Finished,using_greedy_operator);
reg_hold_deposit: Reg_hold_greedy port map(begin_update_vault,slow_clk,Finished,using_deposit_operator);
c14 : Mux_2_to_1_1bit port map(using_greedy_operator,using_deposit_operator,mode_out,ctrl_update);
reg_hold_mode: Reg_hold_greedy port map(mode,slow_clk,Finished,mode_out);
end Behavioral;

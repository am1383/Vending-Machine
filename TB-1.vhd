library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Vending_Testbench is
end entity Vending_Testbench;

architecture Testbench of Vending_Testbench is

    signal CLK, RST                     : std_logic;
    signal T4_Out, T5_Out, T15_Out      : std_logic;
    signal Not_Enough, Remaining_Money  : std_logic;
    signal Coin_in                      : std_logic_vector(1 downto 0);
    signal Ticket_Select                : std_logic_vector(1 downto 0);
    signal Submit                       : std_logic;

    constant CLK_PERIOD                 : time := 40 ns;

    component Vending
        port (
            CLK, RST                    : in std_logic;
            Ticket_Select               : in std_logic_vector(1 downto 0);
            T4_Out, T5_Out, T15_Out     : out std_logic;
            Coin_in                     : in  std_logic_vector(1 downto 0);
            Not_Enough, Remaining_Money : out std_logic;
            Submit                      : in  std_logic
        );
    end component;

begin
    UUT : Vending
        port map (
            CLK => CLK,
            RST => RST,
            Ticket_Select => Ticket_Select,
            T4_Out => T4_Out,
            T5_Out => T5_Out,
            T15_Out => T15_Out,
            Coin_in => Coin_in,
            Not_Enough => Not_Enough,
            Remaining_Money => Remaining_Money,
            Submit => Submit
        );

    CLK_process : process
    begin
        while now < 200 ns loop
            CLK <= '0';
            wait for CLK_PERIOD/2;
            CLK <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process CLK_process;

    Stimulus_Process : process
    begin

        -- Test Scenario 1
        Coin_in <= "01"; -- Coin 500
        wait for 10 ns;
        Coin_in <= "10"; -- Coin 1000
        wait for 10 ns;
        Submit <= '0'; 
	    wait for CLK_PERIOD / 2;
        Ticket_Select <= "01"; -- Select Ticket 500 
        Submit <= '1';

        wait;
    end process Stimulus_Process;

end Testbench;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Vending_Testbench is
end entity Vending_Testbench;

architecture Testbench of Vending_Testbench is

    component Vending
        port (
            CLK, RST: in std_logic;
            Coin_in: in std_logic_vector(1 downto 0);
            Ticket_Select: in std_logic_vector(1 downto 0);
            Submit: in std_logic
        );
    end component;

    signal CLK_Design, RST, Coin_in, Ticket_Select, Submit : std_logic;
    signal T4_Out, T5_Out, T15_Out, S500, S1000, Not_Enough, Remaning_Money : std_logic;

    constant CLK_Period : time := 40 ns;
    begin
        Vending_ENT : Vending port map (
                CLK => CLK_Design,
                RST => RST,
                Coin_in => Coin_in,
                Ticket_Select => Ticket_Select,
                Submit => Submit
            );

        CLK_Process: process
        begin
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end process;

        Stimulus_Process: process
        begin
    

            Coin_in <= "01"; -- Coin value 500
            Ticket_Select <= "01"; -- Select T4
            Submit <= '0';
            wait for 10 ns;
            Submit <= '1';
            wait for 10 ns;

            Coin_in <= "10"; -- Coin value 1000
            Ticket_Select <= "10"; -- Select T15
            Submit <= '0';
            wait for 10 ns;
            Submit <= '1';
            wait for 10 ns;

            Coin_in <= "11"; -- Coin value 1500
            Ticket_Select <= "11"; -- Select T5
            Submit <= '0';
            wait for 10 ns;
            Submit <= '1';
            wait for 10 ns;

            -- Add more test cases as needed

            wait;
        end process;

    end Testbench;

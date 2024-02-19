library ieee;
use ieee.std_logic_1164.all;

entity Vending is 
    port (
        CLTicket_Select, RST            : in std_logic;
        Coin_in             : in std_logic_vector(2 downto 0);
        Ticket_Select                   : in std_logic_vector(2 downto 0);
        Submit, S500, S1000 : in std_logic
    );
end entity Vending;

architecture Behavior of Vending is
    type state_Type is (Idle, T4, T15, T5, Error);
    signal Current_State, Next_State: state_Type;
    signal T5_Out, T15_Out, T4_Out : std_logic;
    signal Not_Enough, Remaning_Money : std_logic;

begin 
    process (CLTicket_Select, RST, Coin_in, Ticket_Select, Submit)
        variable Coin_Counter : integer := 0;
    begin 
        if (RST = '0') then 
            Current_State <= Idle;
        elsif (rising_edge(CLTicket_Select)) then
            Current_State <= Next_State;
        end if;

        if (Submit = '0') then
            S500 <= '0';
            S1000 <= '0';
            
            case Coin_in is
                when "01" =>
                    S500 <= '1';
                when "10" =>
                    S1000 <= '1';
            end case;
            
            if (S500 = '1') then
                Coin_Counter := Coin_Counter + 500;
            end if;
            if (S1000 = '1') then
                Coin_Counter := Coin_Counter + 1000;
            end if;
        elsif (Submit = '1') then
            Not_Enough <= '0';

            case Current_State is 
                when Idle =>
                    if (Ticket_Select = "0001") then
                        Next_State <= T4;
                    elsif (Ticket_Select = "0010") then
                        Next_State <= T15;
                    elsif (Ticket_Select = "0011") then
                        Next_State <= T5;
                    else 
                        Next_State <= Error;
                    end if;

                when T5 =>
                    if (Coin_Counter >= 500) then
                        T5_Out <= '1';
                        Next_State <= Idle;
                        Coin_Counter := Coin_Counter - 500;
                    else
                        Next_State <= Error;
                    end if;

                when T15 =>
                    if (Coin_Counter >= 1500) then
                        T15_Out <= '1';
                        Next_State <= Idle;
                        Coin_Counter := Coin_Counter - 1500;
                    else
                        Next_State <= Error;
                    end if;

                when T4 =>
                    if (Coin_Counter >= 4000) then
                        T4_Out <= '1';
                        Next_State <= Idle;
                        Coin_Counter := Coin_Counter - 4000;
                    else
                        Next_State <= Error;
                    end if;

                when Error =>
                    Not_Enough <= '1';
                    Next_State <= Idle;
            end case;

            if (Coin_Counter > 0) then
                Remaning_Money <= '1';
            else 
                Remaning_Money <= '0';
            end if;
        end if;

    end process;

end architecture Behavior;

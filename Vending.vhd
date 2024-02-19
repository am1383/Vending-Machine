library ieee;
use ieee.std_logic_1164.all;

entity Vending is 
    port (
        CLK, RST                        : in std_logic;
        Coin_in                         : in std_logic_vector(1 downto 0);
        Ticket_Select                   : in std_logic_vector(1 downto 0);
        Submit                          : in std_logic
    );
end entity Vending;

architecture Behavior of Vending is
    type state_Type is (Idle, T4, T5, T15, Error);

    signal Current_State, Next_State  : state_Type;
    signal T4_Out, T5_Out, T15_Out    : std_logic;
    signal S500, S1000                : std_logic;
    signal Not_Enough, Remaning_Money : std_logic;

begin 
    process (CLK, RST, Coin_in, Ticket_Select, Submit)
        variable Coin_Counter : integer := 0;
    begin 
        if (RST = '0') then 
            Current_State <= Idle;
        elsif (rising_edge(CLK)) then
            Current_State <= Next_State;
        end if;

        if (Submit = '0') then

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
                    if (Ticket_Select = "01") then
                        Next_State <= T4;
                    elsif (Ticket_Select = "10") then
                        Next_State <= T15;
                    elsif (Ticket_Select = "11") then
                        Next_State <= T5;
                    end if;

                when T5 =>
                    if (Coin_Counter >= 500) then
                        T5_Out <= '1';
                        Next_State <= Idle;
                        Coin_Counter := Coin_Counter - 500;
                    elsif (Coin_Counter < 500) then
                        Next_State <= Error;
                    end if;

                when T15 =>
                    if (Coin_Counter >= 1500) then
                        T15_Out <= '1';
                        Next_State <= Idle;
                        Coin_Counter := Coin_Counter - 1500;
                    elsif (Coin_Counter < 1500) then
                        Next_State <= Error;
                    end if;

                when T4 =>
                    if (Coin_Counter >= 4000) then
                        T4_Out <= '1';
                        Next_State <= Idle;
                        Coin_Counter := Coin_Counter - 4000;
                    elsif (Coin_Counter < 4000) then
                        Next_State <= Error;
                    end if;

                when Error =>
                    Not_Enough <= '1';
                    Next_State <= Idle;
            end case;

            if (Coin_Counter > 0) then
                Remaning_Money <= '1';
            elsif (Coin_Counter <= 0) then
                Remaning_Money <= '0';
            end if;
        end if;

    end process;

end architecture Behavior;

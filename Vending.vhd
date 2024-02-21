library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Vending is 
    port (
        CLK, RST                    : in  std_logic;
        Ticket_Select               : in  std_logic_vector(1 downto 0); -- "01" -> Ticket-500 / "10" -> Ticket-1500 / "11" -> Ticket-4000
        T4_Out, T5_Out, T15_Out     : out std_logic; -- Buying Ticket Result
        Coin_in                     : in  std_logic_vector(1 downto 0); -- Input Coins
        Not_Enough, Remaining_Money : out std_logic;
        Submit                      : in  std_logic -- Finish Button 
       
     );
end Vending;

architecture Behavior of Vending is
    
    type State_Type is (Idle, T4, T5, T15); -- FSM State

    signal Current_State, Next_State : State_Type;

begin 
    process (CLK, RST, Ticket_Select, Submit, Coin_in)
    
	variable Coin_Counter : integer range 0 to 1000000 := 0; -- Storage Money

    begin 
        if (RST = '0') then 
            Current_State <= Idle;

        elsif (clk'event and clk = '1') then
            Current_State <= Next_State;
        end if;

        case Coin_in is
            when "01" =>
                Coin_Counter := Coin_Counter + 500;
            when "10" =>
                Coin_Counter := Coin_Counter + 1000;
            when others =>
                Coin_Counter := Coin_Counter + 0;
            end case;

        if (Submit = '1') then

            case Current_State is 

                when Idle =>
                    if (Ticket_Select = "01") then
                        Next_State <= T5;
                    
                    elsif (Ticket_Select = "10") then
                        Next_State <= T15;

                    elsif (Ticket_Select = "11") then
                        Next_State <= T4;
                    end if;

                when T5 =>
                    if (Coin_Counter >= 500) then
                        T5_Out <= '1';
                        Coin_Counter := Coin_Counter - 500;
                        Next_State <= Idle;
                    else
                        T5_Out <= '0';
                        Not_Enough <= '1';
                        Next_State <= Idle;
                    end if;

                when T15 =>
                    if (Coin_Counter >= 1500) then
                        T15_Out <= '1';
                        Coin_Counter := Coin_Counter - 1500;
                        Next_State <= Idle;
                    else
                        T15_Out <= '0';
                        Not_Enough <= '1';
                        Next_State <= Idle;
                    end if;

                when T4 =>
                    if (Coin_Counter >= 4000) then
                        T4_Out <= '1';
                        Coin_Counter := Coin_Counter - 4000;
                        Next_State <= Idle;  
                    else
                        T4_Out <= '0';
                        Not_Enough <= '1';
                        Next_State <= Idle;
                    end if;          
            end case;
                        
            if (Coin_Counter > 0) then -- Check If Money After Buy Is Remaining Or Not
                Remaining_Money <= '1';
            else 
                Remaining_Money <= '0';
            end if;
            
        end if;
        
    end process;

end architecture Behavior;

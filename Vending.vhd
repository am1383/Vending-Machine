library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Vending is 
    port (
        CLK, RST                    : in  std_logic;
        Ticket_Select               : in  std_logic_vector(1 downto 0); -- "01" -> Ticket-500 / "10" -> Ticket-1500 / "11" -> Ticket-4000
        T4_Out, T5_Out, T15_Out     : out std_logic;
        Coin_in                     : in  std_logic_vector(3 downto 0); -- "01" -> 500T / "10" -> 1000T
        Not_Enough, Remaining_Money : out std_logic;
        Submit                      : in  std_logic -- Finish Button 
       
     );
end Vending;

architecture Behavior of Vending is
    
    type State_Type is (Idle, T4, T5, T15, Error);

    signal Current_State, Next_State : State_Type;

begin 
    process (CLK, RST, Ticket_Select, Submit, Coin_in)
    
	variable Coin_Counter : integer range 0 to 1000000 := 0;

    begin 
        if (RST = '0') then 
            Current_State <= Idle;

        elsif (clk'event and clk = '1') then
            Current_State <= Next_State;
        end if;
        
        if (Coin_in = "0001") then
            Coin_Counter := Coin_Counter + 500;
    
        elsif (Coin_in = "0010") then
            Coin_Counter := Coin_Counter + 1000;

        elsif (Coin_in = "0011") then
            Coin_Counter := Coin_Counter + 1500;
        
        elsif (Coin_in = "0100") then
            Coin_Counter := Coin_Counter + 2000;
        
        elsif (Coin_in = "0101") then
            Coin_Counter := Coin_Counter + 2500;
        
        elsif (Coin_in = "0110") then
            Coin_Counter := Coin_Counter + 3000;

        elsif (Coin_in = "0111") then   
            Coin_Counter := Coin_Counter + 3500;

        elsif (Coin_in = "1000") then
            Coin_Counter := Coin_Counter + 4000;

        elsif (Coin_in = "1001") then
            Coin_Counter := Coin_Counter + 4500;

        elsif (Coin_in = "1101") then
            Coin_Counter := Coin_Counter + 5000;
        
        elsif (Coin_in = "1110") then
            Coin_Counter := Coin_Counter + 5500;

        elsif (Coin_in = "1111") then
            Coin_Counter := Coin_Counter + 6000;

        end if;

        if (Submit = '1') then

            case Current_State is 

                when Idle =>
                    if (Ticket_Select = "01") then
                        if (Submit = '1') then
                        Next_State <= T5;
                        end if;
                    
                    elsif (Ticket_Select = "10") then
                        if (Submit = '1') then
                        Next_State <= T15;
                        end if;

                    elsif (Ticket_Select = "11") then
                        if (Submit = '1') then
                        Next_State <= T4;
                        end if;
                    end if;

                when T5 =>
                    if (Coin_Counter >= 500) then
                        T5_Out <= '1';
                        Coin_Counter := Coin_Counter - 500;
                        Next_State <= Idle;

                    else
                        T5_Out <= '0';
                        Next_State <= Error;
                    end if;

                when T15 =>
                    if (Coin_Counter >= 1500) then
                        T15_Out <= '1';
                        Coin_Counter := Coin_Counter - 1500;
                        Next_State <= Idle;

                    else
                        T15_Out <= '0';
                        Next_State <= Error;
                    end if;

                when T4 =>
                    if (Coin_Counter >= 4000) then
                        T4_Out <= '1';
                        Coin_Counter := Coin_Counter - 4000;
                        Next_State <= Idle;
                        
                    else
                        T4_Out <= '0';
                        Next_State <= Error;
                    end if;

                when Error =>
                    Not_Enough <= '1';
                    Next_State <= Idle;
                        
            end case; 
        end if;

        if (Coin_Counter /= 0) then
            Remaining_Money <= '1';
        else 
            Remaining_Money <= '0';
        end if;
        
    end process;

end architecture Behavior;

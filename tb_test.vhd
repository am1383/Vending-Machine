library ieee;
use ieee.std_logic_1164.all;

entity tb_Vending is
end entity tb_Vending;

architecture testbench of tb_Vending is
    signal CLK, RST, Submit, S500, S1000 : std_logic := '0';
    signal Coin_in, K : std_logic_vector(2 downto 0) := "000";
    
    signal T5_Out, T15_Out, T4_Out : std_logic;
    signal Not_Enough, Remaning_Money : std_logic;

    constant CLK_PERIOD : time := 10 ns; -- Adjust the period as needed

    component Vending
        port (
            CLK, RST            : in std_logic;
            Coin_in             : in std_logic_vector(2 downto 0);
            K                   : in std_logic_vector(2 downto 0);
            Submit, S500, S1000 : in std_logic
        );
    end component Vending;

    begin
        UUT : Vending
            port map (
                CLK => CLK,
                RST => RST,
                Coin_in => Coin_in,
                K => K,
                Submit => Submit,
                S500 => S500,
                S1000 => S1000
            );

        process
        begin
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end process;

        stimulus_process : process
        begin
            RST <= '1'; -- Reset active
            wait for CLK_PERIOD;
            RST <= '0'; -- Release reset
            wait for CLK_PERIOD;

            -- Test scenario 1
            Coin_in <= "01"; -- 500 coin
            K <= "0001";     -- Select T4
            Submit <= '0';
            wait for CLK_PERIOD;
            Submit <= '1';
            wait for CLK_PERIOD;

            -- Test scenario 2
            Coin_in <= "10"; -- 1000 coin
            K <= "0010";     -- Select T15
            Submit <= '0';
            wait for CLK_PERIOD;
            Submit <= '1';
            wait for CLK_PERIOD;

            -- Add more test scenarios as needed

            wait;
        end process stimulus_process;

        check_process : process
        begin
            wait until rising_edge(CLK);

            -- Add assertion checks here if needed

            wait;
        end process check_process;

    end architecture testbench;

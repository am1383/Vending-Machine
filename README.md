# Vending Machine VHDL Project

This VHDL code represents a vending machine controller with the following functionality:

Inputs:

CLK: Clock input.
RST: Reset input.
Coin_in: 2-bit vector representing the coin inserted. "01" corresponds to 500T, and "10" corresponds to 1000T.
Ticket_Select: 2-bit vector representing the selected ticket. "01" for Ticket-500, "10" for Ticket-1500, and "11" for Ticket-4000.
Submit: Finish button input.
Outputs:

T4_Out, T5_Out, T15_Out: Outputs indicating the result of the ticket purchase. One of these signals will be asserted based on the selected ticket and available funds.
Not_Enough: Output indicating if there is not enough money to purchase the selected ticket.
Remaining_Money: Output indicating whether there is remaining money after the purchase.
States:

The FSM has states Idle, T4, T5, and T15.
In the Idle state, it waits for a ticket selection (Ticket_Select) and transitions to the corresponding state (T4, T5, or T15) when the Submit button is pressed.
In the ticket states (T4, T5, T15), it checks if there is enough money (Coin_Counter) to purchase the selected ticket. If there is enough money, it sets the corresponding output signal (T4_Out, T5_Out, or T15_Out) and transitions back to Idle. If there is not enough money, it sets Not_Enough to '1' and transitions back to Idle.
Money Handling:

Money is added to Coin_Counter based on the value of Coin_in.
Remaining money is indicated by Remaining_Money. If Coin_Counter is greater than 0, Remaining_Money is asserted; otherwise, it is de-asserted.
Error Handling:

If there is not enough money to purchase the selected ticket, the Not_Enough signal is asserted, and the machine transitions back to the Idle state.
This VHDL code represents a simple vending machine that takes coins as input, allows the user to select a ticket, and processes the purchase based on the available funds. It also provides outputs indicating the result of the purchase and whether there is remaining money.
 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending_machine is
    port (
        clk: in std_logic;
        reset: in std_logic;
        coin: in std_logic;
        select: in std_logic;
        state: out std_logic_vector(3 downto 0);
        output: out std_logic_vector(3 downto 0)
    );
end entity vending_machine;

architecture behav of vending_machine is
    -- Define constants for the state machine states
    constant S_IDLE: std_logic_vector(3 downto 0) := "0000";
    constant S_COLLECTING: std_logic_vector(3 downto 0) := "0001";
    constant S_DISPENSING: std_logic_vector(3 downto 0) := "0010";
    constant S_CHANGE: std_logic_vector(3 downto 0) := "0011";
    
    -- Define internal signals
    signal next_state: std_logic_vector(3 downto 0);
    signal current_output: std_logic_vector(3 downto 0);
begin
    -- Define the state machine's output logic
    output_logic: process(next_state, coin, select)
    begin
        case state is
            when S_IDLE =>
                current_output <= "0000";
                if select = '1' then
                    next_state <= S_COLLECTING;
                else
                    next_state <= S_IDLE;
                end if;
                
            when S_COLLECTING =>
                current_output <= "0001";
                if coin = '1' then
                    next_state <= S_DISPENSING;
                else
                    next_state <= S_COLLECTING;
                end if;
                
            when S_DISPENSING =>
                current_output <= "0010";
                if next_state = S_COLLECTING then
                    next_state <= S_CHANGE;
                else
                    next_state <= S_IDLE;
                end if;
                
            when S_CHANGE =>
                current_output <= "0011";
                next_state <= S_IDLE;
                
            when others =>
                next_state <= S_IDLE;
        end case;
    end process output_logic;
    
    -- Assign outputs
    output_assign: process(clk, reset)
    begin
        if reset = '1' then
            state <= S_IDLE;
            output <= "0000";
        elsif rising_edge(clk) then
            state <= next_state;
            output <= current_output;
        end if;
    end process output_assign;
end architecture behav;

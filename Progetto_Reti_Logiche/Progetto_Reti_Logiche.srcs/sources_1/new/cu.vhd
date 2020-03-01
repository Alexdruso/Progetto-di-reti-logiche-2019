----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.02.2020 20:48:16
-- Design Name: 
-- Module Name: cu - behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity CU is
    Port ( clk,start,rst,loader_done : in STD_LOGIC;
           done : out STD_LOGIC;
           load_en: out STD_LOGIC;
           writer_en : out STD_LOGIC);
end CU;

architecture Behavioral of CU is
type state_type is (wait_start,load, write_result, done_up); --e se riducessimo gli stati a stop, start e done?
signal next_state, current_state : state_type;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= wait_start;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    lambda: process(current_state)
    begin
        case current_state is
            when wait_start =>
                done <= '0';
                load_en <= '0';
                writer_en <= '0';
            when load =>
                done <= '0';
                load_en <= '1';
                writer_en <= '0';
            when write_result =>
                done <= '0';
                load_en <= '0';
                writer_en <= '1';
            when done_up =>
                done <= '1';
                load_en <= '0';
                writer_en <= '0';
            when others =>
                done <= '-';
                load_en <= '-';
                writer_en <= '-';
        end case;
    end process;

    delta: process(current_state, start, loader_done)
    begin
        case current_state is
            when wait_start =>
                if start = '1' then
                    next_state <= load;
                else
                    next_state <= wait_start;
                end if;
            when load =>
                if loader_done = '1' then
                    next_state <= write_result;
                else
                    next_state <= load;
                end if;
            when write_result =>
                next_state <= done_up;
            when done_up =>
                if start = '0' then
                    next_state <= wait_start;
                else
                    next_state <= done_up;
                end if;
            when others =>
                next_state <= current_state;
        end case;
    end process;

end Behavioral;
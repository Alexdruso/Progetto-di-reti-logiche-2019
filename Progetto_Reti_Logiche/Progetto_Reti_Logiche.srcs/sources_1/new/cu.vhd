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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CU is
    Port ( clk,start,rst,loader_done,writer_done : in STD_LOGIC;
           done : out STD_LOGIC;
           loader_wz_en : out STD_LOGIC;
           loader_encode_en : out STD_LOGIC;
           writer_en : out STD_LOGIC);
end CU;

architecture Behavioral of CU is
type state_type is (S0, S1, S2, S3, S4, S5); --e se riducessimo gli stati a stop, start e done?
signal next_state, current_state : state_type;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= S0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    lambda: process(current_state)
    begin
        case current_state is
            when S0 =>
                done <= '0';
                loader_wz_en <= '0';
                loader_encode_en <= '0';
                writer_en <= '0';
            when S1 =>
                done <= '0';
                loader_wz_en <= '1';
                loader_encode_en <= '0';
                writer_en <= '0';
            when S2 =>
                done <= '0';
                loader_wz_en <= '0';
                loader_encode_en <= '1';
                writer_en <= '0';
            when S3 =>
                done <= '0';
                loader_wz_en <= '0';
                loader_encode_en <= '0';
                writer_en <= '1';
            when S4 =>
                done <= '1';
                loader_wz_en <= '0';
                loader_encode_en <= '0';
                writer_en <= '0';
            when S5 =>
                done <= '0';
                loader_wz_en <= '0';
                loader_encode_en <= '0';
                writer_en <= '0';
            when others =>
                done <= '-';
                loader_wz_en <= '-';
                loader_encode_en <= '-';
                writer_en <= '-';
        end case;
    end process;

    delta: process(current_state, start, loader_done, writer_done)
    begin
        case current_state is
            when S0 =>
                if start = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
            when S1 =>
                if loader_done = '1' then
                    next_state <= S2;
                else
                    next_state <= S1;
                end if;
            when S2 =>
                if loader_done = '1' then
                    next_state <= S3;
                else
                    next_state <= S2;
                end if;
            when S3 =>
                if writer_done = '1' then
                    next_state <= S4;
                else
                    next_state <= S3;
                end if;
            when S4 =>
                if start = '0' then
                    next_state <= S5;
                else
                    next_state <= S4;
                end if;
            when S5 =>
                if start = '1' then
                    next_state <= S2;
                else
                    next_state <= S5;
                end if;
            when others =>
                next_state <= current_state;
        end case;
    end process;

end Behavioral;

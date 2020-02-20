----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2020 15:17:40
-- Design Name: 
-- Module Name: Loader - Dataflow
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

entity Loader is
        
    port(
        clk,rst,loader_wz_en,loader_encode_en: in std_logic;
		data_ram_in: in std_logic_vector(7 downto 0);
		loader_done,driver_loader_en,reg_we: out std_logic;
		addr_ram_from_loader: out std_logic_vector(3 downto 0);
		addr_reg: out std_logic_vector(2 downto 0);
		data_from_loader: out std_logic_vector(7 downto 0)
		);
end Loader;

architecture Dataflow of Loader is

--component Loader_counter is
--    port(
--        clk,rst,loader_wz_en,loader_encode_en: in std_logic;
--        addr : out std_logic_vector(3 downto 0);
--        loader_done,encode_read_done : out std_logic
--        );
--end component;

component Register_D
    port(
        in1 : in std_logic_vector(7 downto 0);
        clk, rst, load : in std_logic; 
        out1 : out std_logic_vector(7 downto 0)
        );
end component;        


signal addr : std_logic_vector(3 downto 0);
type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11);
signal next_state, current_state : state_type;
--signal next_data_from_loader : std_logic_vector(7 downto 0);
signal update_latch : std_logic;
begin
    latch_data: Register_D port map(in1=>data_ram_in,clk=>clk,rst=>rst,load=>update_latch,out1=>data_from_loader);
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= S0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    lambda: process(current_state, data_ram_in)
    begin
        case current_state is
            when S0 =>
                loader_done <= '0';
                driver_loader_en <= '0';
                reg_we <= '-';
                addr_ram_from_loader <= "----";
                addr_reg <= "---";
                --next_data_from_loader <= "--------";
                update_latch <= '-';
            when S1 =>
                loader_done <= '0';
                driver_loader_en <= '1';
                reg_we <= '-';
                addr_ram_from_loader <= "0000";
                addr_reg <= "---";
                --next_data_from_loader <= "--------";
                update_latch <= '-';
            when S2 =>
                loader_done <= '0';
                driver_loader_en <= '1';
                reg_we <= '1';
                addr_ram_from_loader <= "0001";
                addr_reg <= "000";
                --next_data_from_loader <= data_ram_in;
                update_latch <= '1';
            when S3 =>
                loader_done <= '0';
                driver_loader_en <= '1';
                reg_we <= '1';
                addr_ram_from_loader <= "0010";
                addr_reg <= "001";
                --next_data_from_loader <= data_ram_in;
                update_latch <= '1';
            when S4 =>
                loader_done <= '0';
                driver_loader_en <= '1';
                reg_we <= '1';
                addr_ram_from_loader <= "0011";
                addr_reg <= "010";
                --next_data_from_loader <= data_ram_in;
                update_latch <= '1';
            when S5 =>
                loader_done <= '0';
                driver_loader_en <= '1';
                reg_we <= '1';
                addr_ram_from_loader <= "0100";
                addr_reg <= "011";
                --next_data_from_loader <= data_ram_in;
                update_latch <= '1';
            when S6 =>
                loader_done <= '0';
                driver_loader_en <= '1';
                reg_we <= '1';
                addr_ram_from_loader <= "0101";
                addr_reg <= "100";
                --next_data_from_loader <= data_ram_in;
                update_latch <= '1';
            when S7 =>
                loader_done <= '0';
                driver_loader_en <= '1';
                reg_we <= '1';
                addr_ram_from_loader <= "0110";
                addr_reg <= "101";
                --next_data_from_loader <= data_ram_in;
                update_latch <= '1';
            when S8 =>
                loader_done <= '0';
                driver_loader_en <= '1';
                reg_we <= '1';
                addr_ram_from_loader <= "0111";
                addr_reg <= "110";
                --next_data_from_loader <= data_ram_in;
                update_latch <= '1';
            when S9 =>
                loader_done <= '1';
                driver_loader_en <= '0';
                reg_we <= '1';
                addr_ram_from_loader <= "----";
                addr_reg <= "111";
                --next_data_from_loader <= data_ram_in;
                update_latch <= '1';
            when S10 =>
                loader_done <= '0';
                driver_loader_en <= '1';
                reg_we <= '0';
                addr_ram_from_loader <= "1000";
                addr_reg <= "---";
                --next_data_from_loader <= data_ram_in;
                update_latch <= '1';
            when S11 =>
                loader_done <= '1';
                driver_loader_en <= '0';
                reg_we <= '0';
                addr_ram_from_loader <= "----";
                addr_reg <= "---";
                --next_data_from_loader <= next_data_from_loader;
                update_latch <= '0';
            when others =>
                loader_done <= '-';
                driver_loader_en <= '-';
                reg_we <= '-';
                addr_ram_from_loader <= "----";
                addr_reg <= "---";
                --next_data_from_loader <= next_data_from_loader;
                update_latch <= '0';
        end case;
    end process;

    delta: process(current_state, loader_wz_en, loader_encode_en)
    begin
        case current_state is
            when S0 =>
                if loader_wz_en = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
            when S1 =>
                next_state <= S2;
            when S2 =>
                next_state <= S3;
            when S3 =>
                next_state <= S4;
            when S4 =>
                next_state <= S5;
            when S5 =>
                next_state <= S6;
            when S6 =>
                next_state <= S7;
            when S7 =>
                next_state <= S8;
            when S8 =>
                next_state <= S9;
            when S9 =>
                next_state <= S11;
            when S11 =>
                if loader_encode_en = '1' then
                    next_state <= S10;
                else
                    next_state <= S11;
                end if;
            when S10 =>
                next_state <= S11;
            when others =>
                next_state <= current_state;
        end case;
    end process;

    --data_from_loader <= data_ram_in;
    --driver_loader_en <= loader_wz_en or loader_encode_en;
    --LC: Loader_counter port map(clk=>clk,rst=>rst,
    --                            loader_wz_en=>loader_wz_en,loader_encode_en=>loader_encode_en,
    --                           addr=>addr,loader_done=>loader_done, encode_read_done=>reg_we);
    --addr_reg <= addr(2 downto 0);
    --addr_ram_from_loader <= addr;
    
        
end Dataflow;

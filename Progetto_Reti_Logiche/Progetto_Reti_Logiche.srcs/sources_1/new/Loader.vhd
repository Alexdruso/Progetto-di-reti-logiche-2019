library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Loader is
        
    port(
        clk,rst,load_en: in std_logic;
		data_ram_in: in std_logic_vector(7 downto 0);
		loader_done : out std_logic; 
		addr_ram_from_loader: out std_logic_vector(3 downto 0);
		addr_reg: out std_logic_vector(7 downto 0);
		data_from_loader: out std_logic_vector(6 downto 0)
		);
end Loader;

architecture Dataflow of Loader is

signal addr : std_logic_vector(3 downto 0);
type state_type is (load_0, load_1, load_2, load_3, load_4, load_5, load_6, load_7, load_first_addr, load_addr_done, prepare_next_load );
signal next_state, current_state : state_type;
begin
    data_from_loader <= data_ram_in(6 downto 0);
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= load_0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    lambda: process(current_state, data_ram_in)
    begin
        case current_state is
            when load_0 =>
                loader_done <= '0';
                addr_ram_from_loader <= "0000";
                addr_reg <= "--------";
            when load_1 =>
                loader_done <= '0';
                addr_ram_from_loader <= "0001";
                addr_reg <= "00000001";
            when load_2 =>
                loader_done <= '0';
                addr_ram_from_loader <= "0010";
                addr_reg <= "00000010";
            when load_3 =>
                loader_done <= '0';
                addr_ram_from_loader <= "0011";
                addr_reg <= "00000100";
            when load_4 =>
                loader_done <= '0';
                addr_ram_from_loader <= "0100";
                addr_reg <= "00001000";
            when load_5 =>
                loader_done <= '0';
                addr_ram_from_loader <= "0101";
                addr_reg <= "00010000";
            when load_6 =>
                loader_done <= '0';
                addr_ram_from_loader <= "0110";
                addr_reg <= "00100000";
            when load_7 =>
                loader_done <= '0';
                addr_ram_from_loader <= "0111";
                addr_reg <= "01000000";
            when load_first_addr =>
                loader_done <= '0';
                addr_ram_from_loader <= "1000";
                addr_reg <= "10000000";
            when load_addr_done =>
                loader_done <= '1';
                addr_ram_from_loader <= "1000";
                addr_reg <= "00000000";
            when prepare_next_load =>
                loader_done <= '0';
                addr_ram_from_loader <= "1000";
                addr_reg <= "00000000";
            when others =>
                loader_done <= '-';
                addr_ram_from_loader <= "----";
                addr_reg <= "--------";
        end case;
    end process;

    delta: process(current_state, load_en)
    begin
        case current_state is
            when load_0 =>
                if load_en = '1' then
                    next_state <= load_1;
                else
                    next_state <= load_0;
                end if;
            when load_1 =>
                next_state <= load_2;
            when load_2 =>
                next_state <= load_3;
            when load_3 =>
                next_state <= load_4;
            when load_4 =>
                next_state <= load_5;
            when load_5 =>
                next_state <= load_6;
            when load_6 =>
                next_state <= load_7;
            when load_7 =>
                next_state <= load_first_addr;
            when load_first_addr =>
                next_state <= load_addr_done;
            when load_addr_done =>
                next_state <= prepare_next_load;
            when prepare_next_load =>
                if load_en = '0' then
                    next_state <= prepare_next_load;
                elsif load_en = '1' then
                    next_state <=load_addr_done;
                end if;
            when others =>
                next_state <= current_state;
        end case;
    end process;
end Dataflow;

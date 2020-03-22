-- Riva Andrea
-- 10560217
-- Sanvito Alessandro
-- 10578314

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_reti_logiche is
    Port (
        i_clk : in STD_LOGIC;
        i_start : in STD_LOGIC;
        i_rst : in STD_LOGIC;
        i_data : in STD_LOGIC_VECTOR (7 downto 0);
        o_address : out STD_LOGIC_VECTOR (15 downto 0);
        o_done : out STD_LOGIC;
        o_en : out STD_LOGIC;
        o_we : out STD_LOGIC;
        o_data : out STD_LOGIC_VECTOR (7 downto 0)
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

component CU
    Port (
        clk, start, rst, loader_done: in STD_LOGIC;
        done: out STD_LOGIC;
        load_en: out STD_LOGIC;
        write_en: out STD_LOGIC
    );
end component;

component Loader
    port(
        clk, rst, load_en: in std_logic;
		data_ram_in: in std_logic_vector(7 downto 0);
		loader_done: out std_logic;
		addr_ram_from_loader: out std_logic_vector(3 downto 0);
		addr_reg: out std_logic_vector(7 downto 0);
		data_from_loader: out std_logic_vector(6 downto 0)
    );
end component;

component Memory
    port(
        addr_reg: in std_logic_vector(7 downto 0);  
        data_in: in std_logic_vector(6 downto 0);
        clk, rst: in std_logic;
        data0: out std_logic_vector(6 downto 0);
        data1: out std_logic_vector(6 downto 0);
        data2: out std_logic_vector(6 downto 0);
        data3: out std_logic_vector(6 downto 0);
        data4: out std_logic_vector(6 downto 0);
        data5: out std_logic_vector(6 downto 0);
        data6: out std_logic_vector(6 downto 0);
        data7: out std_logic_vector(6 downto 0)
    );
end component;

component Encoder
    port(
        wz0, wz1, wz2, wz3, wz4, wz5, wz6, wz7, to_be_coded: std_logic_vector(6 downto 0);
        coded_result: out std_logic_vector(7 downto 0)
    );
end component;

component Ram_driver
    port (
        addr_ram_from_loader: in STD_LOGIC_VECTOR (3 downto 0);
        data_ram_from_encoder: in STD_LOGIC_VECTOR (7 downto 0);
        driver_load_en: in STD_LOGIC;
        driver_write_en: in STD_LOGIC;
        addr_ram: out STD_LOGIC_VECTOR (15 downto 0);
        data_ram_out: out STD_LOGIC_VECTOR (7 downto 0);
        en_ram: out STD_LOGIC;
        we_ram: out STD_LOGIC
    );
end component;

signal loader_done: std_logic;
signal load_en: std_logic;
signal write_en: std_logic;
signal addr_ram_from_loader: std_logic_vector(3 downto 0);
signal addr_reg:  std_logic_vector(7 downto 0);
signal data_from_loader: std_logic_vector(6 downto 0);
signal data0: std_logic_vector(6 downto 0);
signal data1: std_logic_vector(6 downto 0);
signal data2: std_logic_vector(6 downto 0);
signal data3: std_logic_vector(6 downto 0);
signal data4: std_logic_vector(6 downto 0);
signal data5: std_logic_vector(6 downto 0);
signal data6: std_logic_vector(6 downto 0);
signal data7: std_logic_vector(6 downto 0);
signal coded_result: std_logic_vector(7 downto 0);

begin
    cu_instance: CU port map(
        clk=>i_clk, 
        start=>i_start, 
        rst=>i_rst, 
        loader_done=>loader_done, 
        done=>o_done, 
        load_en=>load_en,
        write_en=>write_en
    );
    
    loader_instance: Loader port map(
        clk=>i_clk, 
        rst=>i_rst, 
        load_en=>load_en,
        data_ram_in=>i_data,
        loader_done=>loader_done,
        addr_ram_from_loader=>addr_ram_from_loader,
        addr_reg=>addr_reg,
        data_from_loader=>data_from_loader
    );
    
    memory_instance: Memory port map(
        addr_reg=>addr_reg,
        data_in=>data_from_loader,
        clk=>i_clk, 
        rst=>i_rst, 
        data0=>data0,
        data1=>data1,
        data2=>data2,
        data3=>data3,
        data4=>data4,
        data5=>data5,
        data6=>data6,
        data7=>data7
    );
    
    encoder_instance: Encoder port map(
        wz0=>data0,
        wz1=>data1,
        wz2=>data2,
        wz3=>data3,
        wz4=>data4,
        wz5=>data5,
        wz6=>data6,
        wz7=>data7,
        to_be_coded=>data_from_loader,
        coded_result=>coded_result
    );
    
    ram_driver_instance: Ram_driver port map(
        addr_ram_from_loader=>addr_ram_from_loader,
        data_ram_from_encoder=>coded_result,
        driver_load_en=>load_en,
        driver_write_en=>write_en,
        addr_ram=>o_address,
        data_ram_out=>o_data,
        en_ram=>o_en,
        we_ram=>o_we
    );

end Behavioral;

-- execution lane

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use IEEE.NUMERIC_STD.ALL;

entity Execution_lane is

     port(
        wz_vector, data_in : in std_logic_vector(6 downto 0);
        valid : out std_logic;
        offset : out std_logic_vector(1 downto 0)
        );  
end Execution_lane;


architecture Dataflow of Execution_lane is

signal diff, padded_data_in, padded_wz_vector : std_logic_vector(7 downto 0);

begin

padded_data_in <= '0' & data_in;
padded_wz_vector <= '1' & wz_vector;
diff <= std_logic_vector(SIGNED(padded_data_in)+SIGNED(padded_wz_vector)+1);
offset<=diff(1 downto 0);
valid <= not( diff(7) or diff(6) or diff(5) or diff(4) or diff(3) or diff(2) );

end Dataflow;

-- flip flop d

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_D is
    port( in1 : in std_logic_vector(6 downto 0);
         clk, rst, load : in std_logic; 
         out1 : out std_logic_vector(6 downto 0) 
         );
         
end Register_D;

architecture Behavioral of Register_D is
begin
    process(clk, rst, load) 
    begin
    
        if rst = '1' then 
            out1 <= (others => '0'); 
        elsif rising_edge(clk) and load = '1'  then 
            out1 <= in1; 
        end if; 
    end process;

end Behavioral;

-- memory

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Memory is
    port(
        addr_reg : in std_logic_vector(7 downto 0);  
        data_in : in std_logic_vector(6 downto 0);
        clk, rst : in std_logic;
        data0 : out std_logic_vector(6 downto 0);
        data1 : out std_logic_vector(6 downto 0);
        data2 : out std_logic_vector(6 downto 0);
        data3 : out std_logic_vector(6 downto 0);
        data4 : out std_logic_vector(6 downto 0);
        data5 : out std_logic_vector(6 downto 0);
        data6 : out std_logic_vector(6 downto 0);
        data7 : out std_logic_vector(6 downto 0)
    );
end Memory;

architecture Dataflow of Memory is

component Register_D
    port(
        in1: in std_logic_vector(6 downto 0);
        clk, rst, load: in std_logic; 
        out1: out std_logic_vector(6 downto 0)
        );
end component;        
        
signal data_in_negated : std_logic_vector(6 downto 0);

begin
    data_in_negated <= not data_in;
        
    R0: Register_D port map(in1=>data_in_negated,clk=>clk,rst=>rst,load=>addr_reg(0),out1=>data0);
    R1: Register_D port map(in1=>data_in_negated,clk=>clk,rst=>rst,load=>addr_reg(1),out1=>data1);
    R2: Register_D port map(in1=>data_in_negated,clk=>clk,rst=>rst,load=>addr_reg(2),out1=>data2);
    R3: Register_D port map(in1=>data_in_negated,clk=>clk,rst=>rst,load=>addr_reg(3),out1=>data3);
    R4: Register_D port map(in1=>data_in_negated,clk=>clk,rst=>rst,load=>addr_reg(4),out1=>data4);
    R5: Register_D port map(in1=>data_in_negated,clk=>clk,rst=>rst,load=>addr_reg(5),out1=>data5);
    R6: Register_D port map(in1=>data_in_negated,clk=>clk,rst=>rst,load=>addr_reg(6),out1=>data6);
    R7: Register_D port map(in1=>data_in_negated,clk=>clk,rst=>rst,load=>addr_reg(7),out1=>data7);

end Dataflow;

-- ram driver

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ram_driver is
    Port (
        addr_ram_from_loader: in STD_LOGIC_VECTOR (3 downto 0);
        data_ram_from_encoder: in STD_LOGIC_VECTOR (7 downto 0);
        driver_load_en: in STD_LOGIC;
        driver_write_en: in STD_LOGIC;
        addr_ram: out STD_LOGIC_VECTOR (15 downto 0);
        data_ram_out: out STD_LOGIC_VECTOR (7 downto 0);
        en_ram: out STD_LOGIC;
        we_ram: out STD_LOGIC
    );
end Ram_driver;

architecture Dataflow of Ram_driver is
constant write_addr : STD_LOGIC_VECTOR (15 downto 0) := "0000000000001001";
signal padded_addr_ram_from_loader : STD_LOGIC_VECTOR (15 downto 0);
begin
    en_ram <= driver_load_en xor driver_write_en;
    we_ram <= driver_write_en;
    data_ram_out <= data_ram_from_encoder when driver_write_en='1' else
                    (others =>'-');
    padded_addr_ram_from_loader <= ("000000000000"&addr_ram_from_loader);
    addr_ram <= padded_addr_ram_from_loader  when driver_load_en='1' and driver_write_en='0' else
                write_addr  when driver_load_en='0' and driver_write_en='1' else
                (others =>'-');

end Dataflow;

-- cu

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity CU is
    Port ( clk,start,rst,loader_done : in STD_LOGIC;
           done : out STD_LOGIC;
           load_en: out STD_LOGIC;
           write_en : out STD_LOGIC);
end CU;

architecture Behavioral of CU is
type state_type is (wait_start,load, write_result, done_up);
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
                write_en <= '0';
            when load =>
                done <= '0';
                load_en <= '1';
                write_en <= '0';
            when write_result =>
                done <= '0';
                load_en <= '0';
                write_en <= '1';
            when done_up =>
                done <= '1';
                load_en <= '0';
                write_en <= '0';
            when others =>
                done <= '-';
                load_en <= '-';
                write_en <= '-';
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

-- decoder

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Decoder is
    generic(
        N: integer := 4
    );
        
    port(
        addr: in std_logic_vector(N-1 downto 0);
        out1: out std_logic_vector((2**N) - 1 downto 0)
    );
end Decoder;

architecture Behavioral of Decoder is
    begin
    
    process(addr)
    begin
    out1<=(others=>'0');
    out1(conv_integer(addr))<='1'; 
    end process;  

end Behavioral;

-- encoder

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Encoder is
    port(
        wz0, wz1, wz2, wz3, wz4, wz5, wz6, wz7, to_be_coded: std_logic_vector(6 downto 0);
        coded_result: out std_logic_vector(7 downto 0)
    );
end Encoder;

architecture Dataflow of Encoder is

component Execution_lane is
     port(
        wz_vector, data_in: in std_logic_vector(6 downto 0);
        valid: out std_logic;
        offset: out std_logic_vector(1 downto 0)
    );  
        
end component;

component Decoder 
    generic(
        N: integer := 4
    );
        
    port(
        addr: in std_logic_vector(N-1 downto 0);
        out1: out std_logic_vector((2**N) - 1 downto 0)
    );
end component; 

signal os0, os1, os2, os3, os4, os5, os6, os7, valid_offset: std_logic_vector(1 downto 0);
signal wz_num: std_logic_vector(2 downto 0);
signal one_hot_offset: std_logic_vector(3 downto 0);
signal coded_input: std_logic_vector(7 downto 0);
signal v0, v1, v2, v3, v4, v5, v6, v7, valid: std_logic;
signal diff0,diff1,diff2,diff3,diff4,diff5,diff6,diff7: std_logic_vector(7 downto 0);

begin

EL0: Execution_lane port map(wz_vector=>wz0,data_in=>to_be_coded,valid=>v0,offset=>os0);
EL1: Execution_lane port map(wz_vector=>wz1,data_in=>to_be_coded,valid=>v1,offset=>os1);
EL2: Execution_lane port map(wz_vector=>wz2,data_in=>to_be_coded,valid=>v2,offset=>os2);
EL3: Execution_lane port map(wz_vector=>wz3,data_in=>to_be_coded,valid=>v3,offset=>os3);
EL4: Execution_lane port map(wz_vector=>wz4,data_in=>to_be_coded,valid=>v4,offset=>os4);
EL5: Execution_lane port map(wz_vector=>wz5,data_in=>to_be_coded,valid=>v5,offset=>os5);
EL6: Execution_lane port map(wz_vector=>wz6,data_in=>to_be_coded,valid=>v6,offset=>os6);
EL7: Execution_lane port map(wz_vector=>wz7,data_in=>to_be_coded,valid=>v7,offset=>os7);

valid<=v0 or v1 or v2 or v3 or v4 or v5 or v6 or v7;

valid_offset<= os0 when v0='1' else
               os1 when v1='1' else
               os2 when v2='1' else
               os3 when v3='1' else
               os4 when v4='1' else
               os5 when v5='1' else
               os6 when v6='1' else
               os7 when v7='1' else
               "--";
           
decoder_instance: Decoder
    generic map(N=>2)
    port map(addr=>valid_offset, out1=>one_hot_offset);           
               
wz_num<= "000" when v0='1' else
     "001" when v1='1' else
     "010" when v2='1' else
     "011" when v3='1' else
     "100" when v4='1' else
     "101" when v5='1' else
     "110" when v6='1' else
     "111" when v7='1' else
     "---";  

coded_input<='1'&wz_num&one_hot_offset;     
     
coded_result<= '0'&to_be_coded when valid='0' else
               coded_input;     
              
end Dataflow;

-- loader

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

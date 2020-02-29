library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity project_tb is
end project_tb;

--same_encoding

architecture projecttb of project_tb is
constant c_CLOCK_PERIOD		: time := 100 ns;
signal   tb_done		: std_logic;
signal   mem_address		: std_logic_vector (15 downto 0) := (others => '0');
signal   tb_rst	                : std_logic := '0';
signal   tb_start		: std_logic := '0';
signal   tb_clk		        : std_logic := '0';
signal   mem_o_data,mem_i_data	: std_logic_vector (7 downto 0);
signal   enable_wire  		: std_logic;
signal   mem_we		        : std_logic;
signal   mem_address_from_uut		: std_logic_vector (15 downto 0) := (others => '0');
signal   mem_i_data_from_uut	: std_logic_vector (7 downto 0);
signal   enable_wire_from_uut  		: std_logic;
signal   mem_we_from_uut		        : std_logic;
signal   mem_address_from_tb		: std_logic_vector (15 downto 0) := std_logic_vector(to_unsigned( 8 , 16));
signal   mem_i_data_from_tb	: std_logic_vector (7 downto 0);
signal   enable_wire_from_tb  		: std_logic := '0';
signal   mem_we_from_tb		        : std_logic := '1';

type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);

signal RAM: ram_type := (
0 => std_logic_vector(to_unsigned(99 , 8)),
1 => std_logic_vector(to_unsigned(124 , 8)),
2 => std_logic_vector(to_unsigned(107 , 8)),
3 => std_logic_vector(to_unsigned(120 , 8)),
4 => std_logic_vector(to_unsigned(8 , 8)),
5 => std_logic_vector(to_unsigned(126 , 8)),
6 => std_logic_vector(to_unsigned(40 , 8)),
7 => std_logic_vector(to_unsigned(20 , 8)),
8 => std_logic_vector(to_unsigned(111 , 8)),
others => (others =>'0'));

component project_reti_logiche is
port (
      i_clk         : in  std_logic;
      i_start       : in  std_logic;
      i_rst         : in  std_logic;
      i_data        : in  std_logic_vector(7 downto 0);
      o_address     : out std_logic_vector(15 downto 0);
      o_done        : out std_logic;
      o_en          : out std_logic;
      o_we          : out std_logic;
      o_data        : out std_logic_vector (7 downto 0)
      );
end component project_reti_logiche;


begin
UUT: project_reti_logiche
port map (
          i_clk      	=> tb_clk,
          i_start       => tb_start,
          i_rst      	=> tb_rst,
          i_data    	=> mem_o_data,
          o_address  	=> mem_address_from_uut,
          o_done      	=> tb_done,
          o_en   	=> enable_wire_from_uut,
          o_we 		=> mem_we_from_uut,
          o_data    	=> mem_i_data_from_uut
          );

p_CLK_GEN : process is
begin
    wait for c_CLOCK_PERIOD/2;
    tb_clk <= not tb_clk;
end process p_CLK_GEN;


MEM : process(tb_clk)
begin
    if tb_clk'event and tb_clk = '1' then
        if enable_wire = '1' then
            if mem_we = '1' then
                RAM(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM(conv_integer(mem_address)) after 1 ns;
            end if;
        end if;
    end if;
end process;


ramdriver : process(mem_address_from_uut, mem_i_data_from_uut, enable_wire_from_uut, mem_we_from_uut, mem_address_from_tb, mem_i_data_from_tb, enable_wire_from_tb, mem_we_from_tb)
begin
    if enable_wire_from_tb = '1' then
        mem_address <= mem_address_from_tb;
        mem_i_data <= mem_i_data_from_tb;
        enable_wire <= enable_wire_from_tb;
        mem_we <= mem_we_from_tb;
    else
        mem_address <= mem_address_from_uut;
        mem_i_data <= mem_i_data_from_uut;
        enable_wire <= enable_wire_from_uut;
        mem_we <= mem_we_from_uut;
    end if;
end process;


test : process is
begin 

----------

--test section: weird
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

--RAM gia' inizializzata

wait for c_CLOCK_PERIOD;
tb_rst <= '0';

--RAM gia' inizializzata

tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 01101111
assert RAM(9) = std_logic_vector(to_unsigned( 111 , 8)) report "***** TEST 1.1 FALLITO! ***** Expected 111 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 1.1 PASSATO.";

--test section: sum_must_be_8_bits
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 0 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 125 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 1 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 55 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 2 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 31 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 3 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 37 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 4 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 45 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 5 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 77 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 6 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 91 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 7 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 100 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


wait for c_CLOCK_PERIOD;
tb_rst <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 00000000
assert RAM(9) = std_logic_vector(to_unsigned( 0 , 8)) report "***** TEST 2.1 FALLITO! ***** Expected 0 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 2.1 PASSATO.";

--test section: first_wz_first_addr
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 0 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 1 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 4 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 2 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 55 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 3 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 31 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 4 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 37 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 5 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 45 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 6 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 77 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 7 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 91 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


wait for c_CLOCK_PERIOD;
tb_rst <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-0001
assert RAM(9) = std_logic_vector(to_unsigned( 129 , 8)) report "***** TEST 3.1 FALLITO! ***** Expected 129 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 3.1 PASSATO.";

--test section: first_wz_last_addr
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 0 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 1 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 4 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 2 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 55 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 3 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 31 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 4 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 37 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 5 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 45 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 6 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 77 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 7 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 91 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 3 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


wait for c_CLOCK_PERIOD;
tb_rst <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 3 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-1000
assert RAM(9) = std_logic_vector(to_unsigned( 136 , 8)) report "***** TEST 4.1 FALLITO! ***** Expected 136 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 4.1 PASSATO.";

--test section: last_wz_first_addr
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 0 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 1 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 4 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 2 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 55 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 3 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 31 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 4 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 37 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 5 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 45 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 6 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 77 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 7 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 91 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 91 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


wait for c_CLOCK_PERIOD;
tb_rst <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 91 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-111-0001
assert RAM(9) = std_logic_vector(to_unsigned( 241 , 8)) report "***** TEST 5.1 FALLITO! ***** Expected 241 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 5.1 PASSATO.";

--test section: last_wz_last_addr
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 0 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 1 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 4 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 2 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 55 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 3 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 31 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 4 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 37 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 5 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 45 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 6 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 77 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 7 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 91 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 94 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


wait for c_CLOCK_PERIOD;
tb_rst <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 94 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-111-1000
assert RAM(9) = std_logic_vector(to_unsigned( 248 , 8)) report "***** TEST 6.1 FALLITO! ***** Expected 248 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 6.1 PASSATO.";

--test section: first_not_in_wz
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 0 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 1 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 4 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 2 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 55 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 3 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 31 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 4 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 37 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 5 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 45 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 6 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 77 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 7 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 91 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 95 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


wait for c_CLOCK_PERIOD;
tb_rst <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 95 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 01011111
assert RAM(9) = std_logic_vector(to_unsigned( 95 , 8)) report "***** TEST 7.1 FALLITO! ***** Expected 95 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 7.1 PASSATO.";

--test section: multiple_conversions
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 0 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 1 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 4 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 2 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 55 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 3 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 31 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 4 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 37 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 5 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 45 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 6 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 77 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 7 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 91 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 3 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


wait for c_CLOCK_PERIOD;
tb_rst <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 3 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-1000
assert RAM(9) = std_logic_vector(to_unsigned( 136 , 8)) report "***** TEST 8.1 FALLITO! ***** Expected 136 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 8.1 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 31 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-011-0001
assert RAM(9) = std_logic_vector(to_unsigned( 177 , 8)) report "***** TEST 8.2 FALLITO! ***** Expected 177 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 8.2 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 95 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 01011111
assert RAM(9) = std_logic_vector(to_unsigned( 95 , 8)) report "***** TEST 8.3 FALLITO! ***** Expected 95 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 8.3 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 94 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-111-1000
assert RAM(9) = std_logic_vector(to_unsigned( 248 , 8)) report "***** TEST 8.4 FALLITO! ***** Expected 248 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 8.4 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 3 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-1000
assert RAM(9) = std_logic_vector(to_unsigned( 136 , 8)) report "***** TEST 8.5 FALLITO! ***** Expected 136 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 8.5 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 2 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-0100
assert RAM(9) = std_logic_vector(to_unsigned( 132 , 8)) report "***** TEST 8.6 FALLITO! ***** Expected 132 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 8.6 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 2 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-0100
assert RAM(9) = std_logic_vector(to_unsigned( 132 , 8)) report "***** TEST 8.7 FALLITO! ***** Expected 132 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 8.7 PASSATO.";

--test section: extreme_wzs
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 0 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 1 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 124 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 2 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 72 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 3 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 44 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 4 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 55 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 5 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 66 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 6 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 77 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 7 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 88 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


wait for c_CLOCK_PERIOD;
tb_rst <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-0001
assert RAM(9) = std_logic_vector(to_unsigned( 129 , 8)) report "***** TEST 9.1 FALLITO! ***** Expected 129 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 9.1 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 127 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-001-1000
assert RAM(9) = std_logic_vector(to_unsigned( 152 , 8)) report "***** TEST 9.2 FALLITO! ***** Expected 152 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 9.2 PASSATO.";

--test section: extreme_addr_not_in_wzs
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 0 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 4 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 1 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 120 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 2 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 72 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 3 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 44 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 4 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 55 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 5 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 66 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 6 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 77 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 7 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 88 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


wait for c_CLOCK_PERIOD;
tb_rst <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 00000000
assert RAM(9) = std_logic_vector(to_unsigned( 0 , 8)) report "***** TEST 10.1 FALLITO! ***** Expected 0 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 10.1 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 127 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 01111111
assert RAM(9) = std_logic_vector(to_unsigned( 127 , 8)) report "***** TEST 10.2 FALLITO! ***** Expected 127 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 10.2 PASSATO.";

--test section: all_offsets
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 0 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 1 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 4 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 2 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 55 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 3 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 31 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 4 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 37 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 5 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 45 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 6 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 77 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 7 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 91 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


wait for c_CLOCK_PERIOD;
tb_rst <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-0001
assert RAM(9) = std_logic_vector(to_unsigned( 129 , 8)) report "***** TEST 11.1 FALLITO! ***** Expected 129 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 11.1 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 1 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-0010
assert RAM(9) = std_logic_vector(to_unsigned( 130 , 8)) report "***** TEST 11.2 FALLITO! ***** Expected 130 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 11.2 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 2 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-0100
assert RAM(9) = std_logic_vector(to_unsigned( 132 , 8)) report "***** TEST 11.3 FALLITO! ***** Expected 132 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 11.3 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 3 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-1000
assert RAM(9) = std_logic_vector(to_unsigned( 136 , 8)) report "***** TEST 11.4 FALLITO! ***** Expected 136 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 11.4 PASSATO.";

--test section: blurred_borders
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 0 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 1 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 4 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 2 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 8 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 3 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 12 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 4 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 16 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 5 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 20 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 6 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 24 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 7 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 28 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 3 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


wait for c_CLOCK_PERIOD;
tb_rst <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 3 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-1000
assert RAM(9) = std_logic_vector(to_unsigned( 136 , 8)) report "***** TEST 12.1 FALLITO! ***** Expected 136 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.1 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 4 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-001-0001
assert RAM(9) = std_logic_vector(to_unsigned( 145 , 8)) report "***** TEST 12.2 FALLITO! ***** Expected 145 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.2 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 7 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-001-1000
assert RAM(9) = std_logic_vector(to_unsigned( 152 , 8)) report "***** TEST 12.3 FALLITO! ***** Expected 152 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.3 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 8 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-010-0001
assert RAM(9) = std_logic_vector(to_unsigned( 161 , 8)) report "***** TEST 12.4 FALLITO! ***** Expected 161 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.4 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 11 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-010-1000
assert RAM(9) = std_logic_vector(to_unsigned( 168 , 8)) report "***** TEST 12.5 FALLITO! ***** Expected 168 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.5 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 12 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-011-0001
assert RAM(9) = std_logic_vector(to_unsigned( 177 , 8)) report "***** TEST 12.6 FALLITO! ***** Expected 177 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.6 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 15 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-011-1000
assert RAM(9) = std_logic_vector(to_unsigned( 184 , 8)) report "***** TEST 12.7 FALLITO! ***** Expected 184 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.7 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 16 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-100-0001
assert RAM(9) = std_logic_vector(to_unsigned( 193 , 8)) report "***** TEST 12.8 FALLITO! ***** Expected 193 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.8 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 19 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-100-1000
assert RAM(9) = std_logic_vector(to_unsigned( 200 , 8)) report "***** TEST 12.9 FALLITO! ***** Expected 200 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.9 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 20 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-101-0001
assert RAM(9) = std_logic_vector(to_unsigned( 209 , 8)) report "***** TEST 12.10 FALLITO! ***** Expected 209 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.10 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 23 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-101-1000
assert RAM(9) = std_logic_vector(to_unsigned( 216 , 8)) report "***** TEST 12.11 FALLITO! ***** Expected 216 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.11 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 24 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-110-0001
assert RAM(9) = std_logic_vector(to_unsigned( 225 , 8)) report "***** TEST 12.12 FALLITO! ***** Expected 225 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.12 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 27 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-110-1000
assert RAM(9) = std_logic_vector(to_unsigned( 232 , 8)) report "***** TEST 12.13 FALLITO! ***** Expected 232 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.13 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 28 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-111-0001
assert RAM(9) = std_logic_vector(to_unsigned( 241 , 8)) report "***** TEST 12.14 FALLITO! ***** Expected 241 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 12.14 PASSATO.";

--test section: same_encoding
wait for c_CLOCK_PERIOD;
tb_rst <= '1';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 0 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 1 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 124 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 2 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 72 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 3 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 44 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 4 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 55 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 5 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 66 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 6 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 77 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 7 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 88 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


wait for c_CLOCK_PERIOD;
tb_rst <= '0';

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-0001
assert RAM(9) = std_logic_vector(to_unsigned( 129 , 8)) report "***** TEST 13.1 FALLITO! ***** Expected 129 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 13.1 PASSATO.";


----------

wait for c_CLOCK_PERIOD;
mem_address_from_tb <= std_logic_vector(to_unsigned( 8 , 16));
mem_i_data_from_tb <= std_logic_vector(to_unsigned( 0 , 8));
enable_wire_from_tb <= '1';
wait for c_CLOCK_PERIOD;
enable_wire_from_tb <= '0';


tb_start <= '1';
wait for c_CLOCK_PERIOD;
wait until tb_done = '1';
wait for c_CLOCK_PERIOD;
tb_start <= '0';
wait until tb_done = '0';

-- Maschera di output = 1-000-0001
assert RAM(9) = std_logic_vector(to_unsigned( 129 , 8)) report "***** TEST 13.2 FALLITO! ***** Expected 129 found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;
report "TEST 13.2 PASSATO.";


----------
    
assert false report "Simulation Ended!" severity failure;
end process test;

end projecttb; 

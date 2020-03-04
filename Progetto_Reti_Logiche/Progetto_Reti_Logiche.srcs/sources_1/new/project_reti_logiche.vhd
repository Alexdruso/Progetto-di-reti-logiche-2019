----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.02.2020 21:43:51
-- Design Name: 
-- Module Name: project_reti_logiche - Behavioral
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
		--reg_we: out std_logic;
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
        --we: in std_logic;
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
--signal reg_we: std_logic;
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
        --reg_we=>reg_we,
        addr_ram_from_loader=>addr_ram_from_loader,
        addr_reg=>addr_reg,
        data_from_loader=>data_from_loader
    );
    
    memory_instance: Memory port map(
        addr_reg=>addr_reg,
        data_in=>data_from_loader,
        clk=>i_clk, 
        rst=>i_rst, 
        --we=>reg_we,
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

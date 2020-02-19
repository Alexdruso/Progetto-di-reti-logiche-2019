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
		loader_done,driver_loader_en,encode_read_done: out std_logic;
		addr_ram_from_loader: out std_logic_vector(3 downto 0);
		addr_reg: out std_logic_vector(2 downto 0);
		data_from_loader: out std_logic_vector(7 downto 0)
		);
end Loader;

architecture Dataflow of Loader is

component Loader_counter is
    port(
        clk,rst,loader_wz_en,loader_encode_en: in std_logic;
        addr : out std_logic_vector(3 downto 0);
        loader_done,encode_read_done : out std_logic
        );
end component;

signal addr : std_logic_vector(3 downto 0);

begin

    data_from_loader <= data_ram_in;
    driver_loader_en <= loader_wz_en or loader_encode_en;
    LC: Loader_counter port map(clk=>clk,rst=>rst,
                                loader_wz_en=>loader_wz_en,loader_encode_en=>loader_encode_en,
                                addr=>addr,loader_done=>loader_done, encode_read_done=>encode_read_done);
    addr_reg <= addr(2 downto 0);
    addr_ram_from_loader <= addr;
    
        
end Dataflow;

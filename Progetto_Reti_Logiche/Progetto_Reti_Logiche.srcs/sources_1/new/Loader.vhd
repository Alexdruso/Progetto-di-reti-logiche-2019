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
    generic(
        N: integer := 3
        );
        
    port(
        clk,rst,loader_wz_en,loader_encode_en: in std_logic;
		data_ram_in: in std_logic_vector(7 downto 0);
		loader_done,driver_loader_en: out std_logic;
		addr_ram_from_loader: out std_logic_vector(15 downto 0);
		addr_reg: out std_logic_vector(N downto 0);
		data_from_loader: out std_logic_vector(7 downto 0)
		);
end Loader;

architecture Dataflow of Loader is

begin


end Dataflow;

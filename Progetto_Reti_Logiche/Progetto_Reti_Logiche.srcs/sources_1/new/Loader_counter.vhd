----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2020 16:36:35
-- Design Name: 
-- Module Name: Loader_counter - Behavioral
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

entity Loader_counter is
    port(
        clk,rst,loader_wz_en,loader_encode_en: in std_logic;
        addr : out std_logic_vector(3 downto 0);
        loader_done,encode_read_done : out std_logic
        );
end Loader_counter;

architecture Behavioral of Loader_counter is

begin


end Behavioral;

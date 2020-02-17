----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2020 17:40:36
-- Design Name: 
-- Module Name: Execution_lane - Dataflow
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Execution_lane is

     port(
        wz_vector,data_in : in std_logic_vector(7 downto 0);
        valid : out std_logic;
        one_hot_code : out std_logic_vector(3 downto 0)
        );  
end Execution_lane;


architecture Dataflow of Execution_lane is

component Decoder 
    port(
        addr: in std_logic_vector(1 downto 0);
        out1: out std_logic_vector(3 downto 0)
   );
end component; 

signal diff : std_logic_vector(7 downto 0);

begin

diff <= data_in+wz_vector+1;
D: Decoder port map (addr=>diff(1 downto 0),out1=>one_hot_code);
valid <= not( diff(7) or diff(6) or diff(5) or diff(4) or diff(3) or diff(2) );
end Dataflow;

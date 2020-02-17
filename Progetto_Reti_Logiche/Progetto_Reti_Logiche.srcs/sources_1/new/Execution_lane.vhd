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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Execution_lane is

    generic(
        N : integer := 7
        );
    
     port(
        wz_vector,data_in : in std_logic_vector(N downto 0);
        coded_value : out std_logic_vector(N downto 0);
        valid : out std_logic
        );  
end Execution_lane;

architecture Dataflow of Execution_lane is

begin


end Dataflow;

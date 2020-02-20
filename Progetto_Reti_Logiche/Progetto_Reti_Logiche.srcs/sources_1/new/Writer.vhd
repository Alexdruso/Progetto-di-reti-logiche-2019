----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2020 16:17:39
-- Design Name: 
-- Module Name: Writer - Dataflow
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

entity Writer is
    port(
        data_in : in std_logic_vector(7 downto 0); 
        write_control : in std_logic; 
        data_to_write : out std_logic_vector(7 downto 0); 
        address_to_write : out std_logic_vector(3 downto 0); 
        write_enable : out std_logic 
    );
end Writer;

architecture Dataflow of Writer is
    
begin

    data_to_write<=data_in;
    address_to_write<="1001";
    write_enable<=write_control;

end Dataflow;

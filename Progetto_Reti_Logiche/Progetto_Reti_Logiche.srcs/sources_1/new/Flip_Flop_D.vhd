----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2019 19:41:52
-- Design Name: 
-- Module Name: Register_D - Behavioral
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

entity Register_D is
    port( in1 : in std_logic_vector(7 downto 0);
         clk, rst, load : in std_logic; 
         out1 : out std_logic_vector(7 downto 0) 
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

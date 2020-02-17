----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2020 21:08:18
-- Design Name: 
-- Module Name: Encoder - Dataflow
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

entity Encoder is
    generic(
        N : integer := 7
        );
    
    port(
        wz0,wz1,wz2,wz3,wz4,wz5,wz6,wz7,to_be_coded : std_logic_vector(N downto 0);
        coded_result : out std_logic_vector(N downto 0)
        );
end Encoder;

architecture Dataflow of Encoder is

component Execution_lane is

     port(
        wz_vector,data_in : in std_logic_vector(7 downto 0);
        valid : out std_logic;
        offset : out std_logic_vector(3 downto 0)
        );  
        
end component;

signal os0,os1,os2,os3,os4,os5,os6,os7 : std_logic_vector(3 downto 0);
signal v0,v1,v2,v3,v4,v5,v6,v7 : std_logic;

begin


end Dataflow;

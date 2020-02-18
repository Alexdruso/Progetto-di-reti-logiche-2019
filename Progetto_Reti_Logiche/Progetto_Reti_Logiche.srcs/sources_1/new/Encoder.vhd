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
        offset : out std_logic_vector(1 downto 0)
        );  
        
end component;

component Decoder 
    port(
        addr: in std_logic_vector(1 downto 0);
        out1: out std_logic_vector(3 downto 0)
   );
end component; 

signal os0,os1,os2,os3,os4,os5,os6,os7,valid_offset : std_logic_vector(1 downto 0);
signal wz_num: std_logic_vector(2 downto 0);
signal one_hot_offset : std_logic_vector(3 downto 0);
signal coded_input: std_logic_vector(7 downto 0);
signal v0,v1,v2,v3,v4,v5,v6,v7,valid : std_logic;

begin

EL0: Execution_lane port map(wz_vector=>wz0,data_in=>to_be_coded,valid=>v0,offset=>os0);
EL1: Execution_lane port map(wz_vector=>wz1,data_in=>to_be_coded,valid=>v1,offset=>os1);
EL2: Execution_lane port map(wz_vector=>wz2,data_in=>to_be_coded,valid=>v2,offset=>os2);
EL3: Execution_lane port map(wz_vector=>wz3,data_in=>to_be_coded,valid=>v3,offset=>os3);
EL4: Execution_lane port map(wz_vector=>wz4,data_in=>to_be_coded,valid=>v4,offset=>os4);
EL5: Execution_lane port map(wz_vector=>wz5,data_in=>to_be_coded,valid=>v5,offset=>os5);
EL6: Execution_lane port map(wz_vector=>wz6,data_in=>to_be_coded,valid=>v6,offset=>os6);
EL7: Execution_lane port map(wz_vector=>wz7,data_in=>to_be_coded,valid=>v7,offset=>os7);

valid<=v0 or v1 or v2 or v3 or v4 or v5 or v6 or v7;

valid_offset<= os0 when v0='1' else
               os1 when v1='1' else
               os2 when v2='1' else
               os3 when v3='1' else
               os4 when v4='1' else
               os5 when v5='1' else
               os6 when v6='1' else
               os7 when v7='1' else
               "--";
           
D: Decoder port map(addr=>valid_offset, out1=>one_hot_offset);           
               
wz_num<= "000" when v0='1' else
     "001" when v1='1' else
     "010" when v2='1' else
     "011" when v3='1' else
     "100" when v4='1' else
     "101" when v5='1' else
     "110" when v6='1' else
     "111" when v7='1' else
     "---";  

coded_input<='1'&wz_num&one_hot_offset;     
     
coded_result<= to_be_coded when valid='0' else
               coded_input;     
              
end Dataflow;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2020 21:09:01
-- Design Name: 
-- Module Name: Memory - Dataflow
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

entity Memory is
    port(
    
        addr_reg : in std_logic_vector(3 downto 0);  
        data_in : in std_logic_vector(6 downto 0);
        clk,rst,we : in std_logic;
        data0 : out std_logic_vector(7 downto 0);
        data1 : out std_logic_vector(7 downto 0);
        data2 : out std_logic_vector(7 downto 0);
        data3 : out std_logic_vector(7 downto 0);
        data4 : out std_logic_vector(7 downto 0);
        data5 : out std_logic_vector(7 downto 0);
        data6 : out std_logic_vector(7 downto 0);
        data7 : out std_logic_vector(7 downto 0)
        
        );
                            
end Memory;

architecture Dataflow of Memory is

component Decoder 

    generic(
        N: integer := 3
        );
        
    port(
        addr: in std_logic_vector(N downto 0);
        out1: out std_logic_vector(2**N-1 downto 0)
   );
end component; 

component Register_D
    port(
        in1 : in std_logic_vector(6 downto 0);
        clk, rst, load : in std_logic; 
        out1 : out std_logic_vector(6 downto 0)
        );
end component;        
        

signal sel , sel_enabled : std_logic_vector(7 downto 0);
signal out0,out1,out2,out3,out4, out5, out6, out7 : std_logic_vector(6 downto 0);

begin

    D: Decoder
        generic map(N=>3) 
        port map (addr=>addr_reg,out1=>sel); 
           
    enable_signal:
    for i in 7 downto 0 generate
        sel_enabled(i)<= (sel(i) and we);
    end generate;    
        
    R0: Register_D port map(in1=>data_in,clk=>clk,rst=>rst,load=>sel_enabled(0),out1=>out0);
    R1: Register_D port map(in1=>data_in,clk=>clk,rst=>rst,load=>sel_enabled(1),out1=>out1);
    R2: Register_D port map(in1=>data_in,clk=>clk,rst=>rst,load=>sel_enabled(2),out1=>out2);
    R3: Register_D port map(in1=>data_in,clk=>clk,rst=>rst,load=>sel_enabled(3),out1=>out3);
    R4: Register_D port map(in1=>data_in,clk=>clk,rst=>rst,load=>sel_enabled(4),out1=>out4);
    R5: Register_D port map(in1=>data_in,clk=>clk,rst=>rst,load=>sel_enabled(5),out1=>out5);
    R6: Register_D port map(in1=>data_in,clk=>clk,rst=>rst,load=>sel_enabled(6),out1=>out6);
    R7: Register_D port map(in1=>data_in,clk=>clk,rst=>rst,load=>sel_enabled(7),out1=>out7);
    data0<='1'&out0;
    data1<='1'&out1;
    data2<='1'&out2;
    data3<='1'&out3;
    data4<='1'&out4;
    data5<='1'&out5;
    data6<='1'&out6;
    data7<='1'&out7;
end Dataflow;

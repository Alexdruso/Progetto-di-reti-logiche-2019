library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use IEEE.NUMERIC_STD.ALL;

entity Execution_lane is

     port(
        wz_vector, data_in : in std_logic_vector(6 downto 0);
        valid : out std_logic;
        offset : out std_logic_vector(1 downto 0)
        );  
end Execution_lane;


architecture Dataflow of Execution_lane is

signal diff, padded_data_in, padded_wz_vector : std_logic_vector(7 downto 0);

begin

padded_data_in <= '0' & data_in;
padded_wz_vector <= '1' & wz_vector;
diff <= std_logic_vector(SIGNED(padded_data_in)+SIGNED(padded_wz_vector)+1);
offset<=diff(1 downto 0);
valid <= not( diff(7) or diff(6) or diff(5) or diff(4) or diff(3) or diff(2) );

end Dataflow;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_D is
    port( in1 : in std_logic_vector(6 downto 0);
         clk, rst, load : in std_logic; 
         out1 : out std_logic_vector(6 downto 0) 
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Decoder is
    generic(
        N: integer := 4
    );
        
    port(
        addr: in std_logic_vector(N-1 downto 0);
        out1: out std_logic_vector((2**N) - 1 downto 0)
    );
end Decoder;

architecture Behavioral of Decoder is
    begin
    
    process(addr)
    begin
    out1<=(others=>'0');
    out1(conv_integer(addr))<='1'; 
    end process;  

end Behavioral;

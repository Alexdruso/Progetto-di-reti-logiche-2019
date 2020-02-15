----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.02.2020 20:29:37
-- Design Name: 
-- Module Name: ram_driver - behavioral
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

entity ram_driver is
    Port ( addr_ram_from_loader : in STD_LOGIC_VECTOR (3 downto 0);
           addr_ram_from_writer : in STD_LOGIC_VECTOR (3 downto 0);
           data_ram_from_writer : in STD_LOGIC_VECTOR (7 downto 0);
           driver_loader_en : in STD_LOGIC;
           driver_writer_en : in STD_LOGIC;
           addr_ram : out STD_LOGIC_VECTOR (15 downto 0);
           data_ram_out : out STD_LOGIC_VECTOR (7 downto 0);
           en_ram : out STD_LOGIC;
           we_ram : out STD_LOGIC);
end ram_driver;

architecture behavioral of ram_driver is
signal padded_addr_ram_from_loader : STD_LOGIC_VECTOR (15 downto 0);
signal padded_addr_ram_from_writer : STD_LOGIC_VECTOR (15 downto 0);
begin
    en_ram <= driver_loader_en or driver_writer_en;
    we_ram <= driver_writer_en;
    data_ram_out <= data_ram_from_writer when driver_writer_en='1' else
                    "--------";
    padded_addr_ram_from_loader <= ("000000000000"&addr_ram_from_loader);
    padded_addr_ram_from_writer <= ("000000000000"&addr_ram_from_writer);
    addr_ram <= padded_addr_ram_from_loader  when driver_loader_en='1' and driver_writer_en='0' else
                padded_addr_ram_from_writer  when driver_loader_en='0' and driver_writer_en='1' else
                "----------------";

end behavioral;

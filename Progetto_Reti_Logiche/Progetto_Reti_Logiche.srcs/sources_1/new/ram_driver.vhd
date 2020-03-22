library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ram_driver is
    Port (
        addr_ram_from_loader: in STD_LOGIC_VECTOR (3 downto 0);
        data_ram_from_encoder: in STD_LOGIC_VECTOR (7 downto 0);
        driver_load_en: in STD_LOGIC;
        driver_write_en: in STD_LOGIC;
        addr_ram: out STD_LOGIC_VECTOR (15 downto 0);
        data_ram_out: out STD_LOGIC_VECTOR (7 downto 0);
        en_ram: out STD_LOGIC;
        we_ram: out STD_LOGIC
    );
end Ram_driver;

architecture Dataflow of Ram_driver is
constant write_addr : STD_LOGIC_VECTOR (15 downto 0) := "0000000000001001";
signal padded_addr_ram_from_loader : STD_LOGIC_VECTOR (15 downto 0);
begin
    en_ram <= driver_load_en xor driver_write_en;
    we_ram <= driver_write_en;
    data_ram_out <= data_ram_from_encoder when driver_write_en='1' else
                    (others =>'-');
    padded_addr_ram_from_loader <= ("000000000000"&addr_ram_from_loader);
    addr_ram <= padded_addr_ram_from_loader  when driver_load_en='1' and driver_write_en='0' else
                write_addr  when driver_load_en='0' and driver_write_en='1' else
                (others =>'-');

end Dataflow;

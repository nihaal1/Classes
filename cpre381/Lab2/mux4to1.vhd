library ieee;
use ieee.std_logic_1164.all;
 
entity Mux_4_To_1 is
  port (
    i_Select : in  std_logic_vector(1 downto 0);
    i_Data1  : in  std_logic;
    i_Data2  : in  std_logic;
    i_Data3  : in  std_logic;
    i_Data4  : in  std_logic;
    o_Data   : out std_logic
    );
end entity Mux_4_To_1;
 
architecture RTL of Mux_4_To_1 is
begin
  o_Data <= i_Data1 when i_Select = "00" else
            i_Data2 when i_Select = "01" else
            i_Data3 when i_Select = "10" else
            i_Data4;
 
  -- Alternatively:
  with i_Select select
    o_Data <= i_Data1 when "00", i_Data2 when "01", i_Data3 when "10", i_Data4 when others; -- Alternatively: p_Mux: process (i_Select, i_Data1, i_Data2, i_Data3, i_Data4) is begin case i_Select is when "00" =>
        o_Data <= i_Data1; when "01" =>
        o_Data <= i_Data2; when "10" =>
        o_Data <= i_Data3; when others =>
        o_Data <= i_Data4;
    end case;
  end process p_Mux;
   
end architecture RTL;
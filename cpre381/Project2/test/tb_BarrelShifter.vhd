library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_BarrelShifter is

end tb_BarrelShifter;

architecture mixed of tb_BarrelShifter is

component BarrelShifter is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Data          : in std_logic_vector(N-1 downto 0);
	i_Shift		: in std_logic_vector(4 downto 0);
	i_RoL		:in std_logic;
	i_AoL		:in std_logic;
       o_X          : out std_logic_vector(N-1 downto 0));

end component;


  signal s_Data         : std_logic_vector(31 downto 0);
  signal s_Shift         : std_logic_vector(4 downto 0);
  signal s_RoL         : std_logic;
  signal s_AoL		:std_logic;
  signal output     : std_logic_vector(31 downto 0);

begin

  DUT0: BarrelShifter
  port map(
            i_Data     => s_Data,
            i_Shift       => s_Shift,
            i_RoL       => s_RoL,
	    i_AoL     => s_AoL,
            o_X     => output);

  P_TEST_CASES: process
  begin
 

    
    s_Data   <= "00000000000000000000000000000001";  
    s_Shift   <= "00001";
    s_RoL <= '0';
    s_AoL <= '0';
 
    wait for 10 ns;
 
    s_Data   <= "00000000000000000000000000000001";  
    s_Shift   <= "00010";
    s_RoL <= '0';
    s_AoL <= '0';
 
    wait for 10 ns;

    s_Data   <= "00000000000000000000000000000001";  
    s_Shift   <= "00100";
    s_RoL <= '0';
    s_AoL <= '0';
 
    wait for 10 ns;

    s_Data   <= "00000000000000000000000000000001";  
    s_Shift   <= "01000";
    s_RoL <= '0';
    s_AoL <= '0';
 
    wait for 10 ns;

    s_Data   <= "00000000000000000000000000000001";  
    s_Shift   <= "10000";
    s_RoL <= '0';
    s_AoL <= '0';
 
    wait for 10 ns;

    s_Data   <= "10000000000000000000000000000000";  
    s_Shift   <= "00001";
    s_RoL <= '1';
    s_AoL <= '0';
 
    wait for 10 ns;
 
    s_Data   <= "10000000000000000000000000000000";  
    s_Shift   <= "00010";
    s_RoL <= '1';
    s_AoL <= '0';
 
    wait for 10 ns;

    s_Data   <= "10000000000000000000000000000000";  
    s_Shift   <= "00100";
    s_RoL <= '1';
    s_AoL <= '0';
 
    wait for 10 ns;

    s_Data   <= "10000000000000000000000000000000";  
    s_Shift   <= "01000";
    s_RoL <= '1';
    s_AoL <= '0';
 
    wait for 10 ns;

    s_Data   <= "10000000000000000000000000000000";  
    s_Shift   <= "10000";
    s_RoL <= '1';
    s_AoL <= '0';
 
    wait for 10 ns;

    s_Data   <= "10000000000000000000000000000000";  
    s_Shift   <= "00001";
    s_RoL <= '1';
    s_AoL <= '1';
 
    wait for 10 ns;
 
    s_Data   <= "01000000000000000000000000000000";  
    s_Shift   <= "00010";
    s_RoL <= '1';
    s_AoL <= '1';
 
    wait for 10 ns;

    s_Data   <= "10000000000000000000000000000000";  
    s_Shift   <= "00100";
    s_RoL <= '1';
    s_AoL <= '1';
 
    wait for 10 ns;

    s_Data   <= "01000000000000000000000000000000";  
    s_Shift   <= "01000";
    s_RoL <= '1';
    s_AoL <= '1';
 
    wait for 10 ns;

    s_Data   <= "10000000000000000000000000000000";  
    s_Shift   <= "10000";
    s_RoL <= '1';
    s_AoL <= '1';
 
    wait for 10 ns;
 

    
  end process;


end mixed;
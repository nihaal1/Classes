library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_dmem is
  generic(DATA_WIDTH : natural := 32;
	  ADDR_WIDTH : natural := 10;
  	  gCLK_HPER   : time := 10 ns);

end tb_dmem;

architecture mixed of tb_dmem is

constant cCLK_PER  : time := gCLK_HPER * 2;

component mem is
  port(clk		: in std_logic;
       addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
       data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
       we		: in std_logic := '1';
       q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
end component;

  signal addr         : std_logic_vector((ADDR_WIDTH-1) downto 0);
  signal data         : std_logic_vector((DATA_WIDTH-1) downto 0);
  signal we           : std_logic;
  signal q            : std_logic_vector((DATA_WIDTH -1) downto 0);
  signal i_CLK   :  std_logic;

begin

  dmem: mem
  port map(
            clk        => i_CLK,   -- maping clock to clocvk signal
            addr       => addr,
            data       => data,
            we         => we,
            q          => q);

  --Clock setup
  P_CLK: process
  begin
    i_CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    i_CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;


  P_TEST_CASES: process
  begin
 

-----------------------------      Read     --------------------------

    --00
    addr   <= "0000000000";  
    data   <= x"--------";
    we     <= '0';
 
    wait for cCLK_PER;
  

    --01
    addr   <= "0000000001";  
    data   <= x"--------";
    we     <= '0';
 
    wait for cCLK_PER;

    --02
    addr   <= "0000000010";  
    data   <= x"--------";
    we     <= '0';
 
    wait for cCLK_PER;
  

    --03
    addr   <= "0000000011";  
    data   <= x"--------";
    we     <= '0';
 
    wait for cCLK_PER;
    --04
    addr   <= "0000000100";  
    data   <= x"--------";
    we     <= '0';
 
    wait for cCLK_PER;
  

    --05
    addr   <= "0000000101";  
    data   <= x"--------";
    we     <= '0';
 
    wait for cCLK_PER;

    --06
    addr   <= "0000000110";  
    data   <= x"--------";
    we     <= '0';
 
    wait for cCLK_PER;
  

    --07
    addr   <= "0000000111";  
    data   <= x"--------";
    we     <= '0';
 
    wait for cCLK_PER;

    --08
    addr   <= "0000001000";  
    data   <= x"--------";
    we     <= '0';
 
    wait for cCLK_PER;
  

    --09
    addr   <= "0000001001";  
    data   <= x"--------";
    we     <= '0';
 

-----------------------------      Write     -------------------

    --11
    addr   <= "0100000000";  
    data   <= x"FFFFFFFF";
    we     <= '1';

    wait for cCLK_PER;

    --12
    addr   <= "0100000001";  
    data   <= x"FFFFFFFE";
    we     <= '1';

    wait for cCLK_PER;

    --13
    addr   <= "0100000010";  
    data   <= x"FFFFFFFD";
    we     <= '1';

    wait for cCLK_PER;

    --14
    addr   <= "0100000011";  
    data   <= x"FFFFFFFC";
    we     <= '1';

    wait for cCLK_PER;

    --15
    addr   <= "0100000100";  
    data   <= x"FFFFFFFB";
    we     <= '1';

    wait for cCLK_PER;

    --16
    addr   <= "0100000101";  
    data   <= x"FFFFFFFA";
    we     <= '1';

    wait for cCLK_PER;

    --17
    addr   <= "0100000110";  
    data   <= x"FFFFFFF9";
    we     <= '1';

    wait for cCLK_PER;

    --18
    addr   <= "0100000111";  
    data   <= x"FFFFFFF8";
    we     <= '1';

    wait for cCLK_PER;

    --19
    addr   <= "0100001000";  
    data   <= x"FFFFFFF7";
    we     <= '1';

    wait for cCLK_PER;

    --20
    addr   <= "0100001001";  
    data   <= x"FFFFFFF6";
    we     <= '1';
 
    wait;
 
  end process;

end mixed;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_n_bit_reg is
  generic(N : integer := 32;
  	  gCLK_HPER   : time := 10 ns);
end tb_n_bit_reg;

architecture mixed of tb_n_bit_reg is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

component n_bit_reg is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;   
       i_RST        : in std_logic;   
       i_WE         : in std_logic;  
       i_D          : in std_logic_vector(N-1 downto 0);
       o_Q          : out std_logic_vector(N-1 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal reset : std_logic := '0';

    signal   i_CLK       :  std_logic;   
    signal   i_RST       :  std_logic;   
    signal   i_WE        :  std_logic;  
    signal   i_D         :  std_logic_vector(N-1 downto 0);
    signal   o_Q         :  std_logic_vector(N-1 downto 0);


begin

  DUT0: n_bit_reg
  generic map(N => N)
  port map(
            i_CLK     => i_CLK,
            i_RST     => i_RST,
            i_WE      => i_WE,
            i_D       => i_D,
            o_Q     => o_Q);

  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    i_CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    i_CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;




  P_TEST_CASES: process
  begin
 

    i_RST   <= '1';  
    i_WE   <= '1';    
    i_D   <= x"00001010";  

    wait for 10 ns;

    i_RST   <= '0';  
    i_WE   <= '1';    
    i_D   <= x"0000FFFF";  
 
    wait for 10 ns;

    i_RST   <= '0';  
    i_WE   <= '0';    
    i_D   <= x"DEADBEEF";  
 
    wait for 10 ns;
 

    i_RST   <= '0';  
    i_WE   <= '1';    
    i_D   <= x"00003371";  
 
    wait;

    
  end process;


end mixed;

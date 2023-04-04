library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_decoder_32 is
  generic(N : integer := 32;
	  M : integer := 5);
end tb_decoder_32;

architecture mixed of tb_decoder_32 is

component decoder_32 is
  generic(N : integer := 32;
	  M : integer := 5);

  port(D_IN	: in std_logic_vector(M-1 downto 0);
	En	: in std_logic;	
	F_OUT	: out std_logic_vector(N-1 downto 0));
end component;


  signal S_IN        : std_logic_vector(M-1 downto 0);
  signal S_OUT        : std_logic_vector(N-1 downto 0);
  signal S_En        : std_logic;

begin

  DUT0: decoder_32
  generic map(N => N)
  port map(
            D_IN     => S_IN,
	    F_OUT     => S_OUT,
            En     => S_En);

  P_TEST_CASES: process
  begin
 

    
    S_IN   <= "00000";  
    S_En   <= '1';

    wait for 10 ns;
 
    S_IN   <= "11111";   
    S_En   <= '0';
 
    wait for 10 ns;
 
    S_IN   <= "11111";   
    S_En   <= '1';
 
    wait;

    
  end process;


end mixed;

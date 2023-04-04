library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_reg_file is
  generic(N : integer := 32;
	  M : integer := 5;
  	  gCLK_HPER   : time := 10 ns);
--port(MX_OUT1  : out std_logic_vector (31 downto 0);
 --    MX_OUT2  : out std_logic_vector (31 downto 0));

end tb_reg_file;

architecture mixed of tb_reg_file is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

component reg_file is
  generic(N : integer := 32;
	  M : integer := 5); -- Generic of type integer for input/output data width. Default value is 32.
  port (D_IN	 : in std_logic_vector(M-1 downto 0);
	En	 : in std_logic;	
        i_CLK    : in std_logic;   
        i_RST    : in std_logic;   
        i_D      : in std_logic_vector(N-1 downto 0);
        SEL1     : in std_logic_vector(4 downto 0);
        SEL2     : in std_logic_vector(4 downto 0);
        MX_OUT1  : out std_logic_vector (31 downto 0);
        MX_OUT2  : out std_logic_vector (31 downto 0));

end component;


    signal reset : std_logic := '0';

    signal      D_IN	 :  std_logic_vector(M-1 downto 0);
    signal      En	 :  std_logic;	
    signal      i_CLK    :  std_logic;   
    signal      i_RST    :  std_logic;   
    signal      i_D      :  std_logic_vector(N-1 downto 0);
    signal      SEL1     :  std_logic_vector(4 downto 0);
    signal      SEL2     :  std_logic_vector(4 downto 0);
    signal      MX_OUT1  :  std_logic_vector (31 downto 0);
    signal      MX_OUT2  :  std_logic_vector (31 downto 0);


begin

  DUT0: reg_file
  generic map(N => N, M => M)
  port map(
            D_IN     => D_IN,
            En     => En,
            i_CLK      => i_CLK,
            i_RST       => i_RST,
            i_D       => i_D,
            SEL1       => SEL1,
            SEL2       => SEL2,
            MX_OUT1       => MX_OUT1,
            MX_OUT2     => MX_OUT2);

  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    i_CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    i_CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

--  P_RST: process
--  begin
--  	i_RST <= '0';   
--    wait for gCLK_HPER/2;
--	i_RST <= '1';
--    wait for gCLK_HPER*2;
--	i_RST <= '0';
--	wait;
-- end process;  


  P_TEST_CASES: process
  begin
 

    D_IN   <= "00000";  
    En   <= '1';    
    i_RST   <= '0';        -- remove these resets to make it in sync
    i_D   <= x"00000000";  
    SEL1   <= "00000"; 
    SEL2   <= "00000"; 

    wait for 10 ns;


    D_IN   <= "00001";  
    En   <= '1';    
    i_RST   <= '0';        -- remove these resets to make it in sync
    i_D   <= x"0000FFFF";  
    SEL1   <= "00001"; 
    SEL2   <= "00000"; 

    wait for 10 ns;




 
    D_IN   <= "00010";  
    En   <= '1';    
    i_RST   <= '0';        -- remove these resets to make it in sync
    i_D   <= x"BEEBEEBF";  
    SEL1   <= "00001"; 
    SEL2   <= "00010"; 
 
    wait;

    
  end process;


end mixed;

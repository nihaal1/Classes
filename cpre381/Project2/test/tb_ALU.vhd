library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_ALU is
  generic(N : integer := 32);
end tb_ALU;

architecture mixed of tb_ALU is

component ALU is
  generic(N : integer := 32);

  port(A           : in std_logic_vector(N-1 downto 0);
       B           : in std_logic_vector(N-1 downto 0);
       replqb_in   : in std_logic_vector(7 downto 0);
       ALU_control : in std_logic_vector(3 downto 0);
       zero_out    : out std_logic;
       overflow    : out std_logic;
       Output      : out std_logic_vector(N-1 downto 0));
end component;


  signal s_A          : std_logic_vector(N-1 downto 0);
  signal s_B          : std_logic_vector(N-1 downto 0);
  signal S_repl       : std_logic_vector(7 downto 0);
  signal s_control    : std_logic_vector(3 downto 0);
  signal s_zero_out   : std_logic;
  signal s_overflow   : std_logic;
  signal s_Output     : std_logic_vector(N-1 downto 0);

begin

  ALU_test: ALU
generic map(N => N)
  port map(
            A             => s_A,
            B             => s_B,
            replqb_in     => S_repl,
            ALU_control   => s_control,
            zero_out      => s_zero_out,
            overflow      => s_overflow,
            Output        => s_Output);

  P_TEST_CASES: process
  begin
 

    
    s_A        <= x"00000001";  
    s_B        <= x"00000001";
    S_repl     <= x"AA";
    s_control  <= x"0";    -- + exepected: 0x00000002


 
    wait for 10 ns;
 
    s_A        <= x"00000001";  
    s_B        <= x"00000001";
    S_repl     <= x"AA";
    s_control  <= x"1";    -- - exepected: 0x00000000
 
    wait for 10 ns;

    s_A        <= x"FFFF0000";  
    s_B        <= x"F0000000";
    S_repl     <= x"A0";
    s_control  <= x"2";    -- and exepected: 0xF0000000
 
    wait for 10 ns;

    s_A        <= x"FFFF0000";  
    s_B        <= x"F000000F";
    S_repl     <= x"A0";
    s_control  <= x"3";    -- or exepected: 0xFFFF000F
 
    wait for 10 ns;
 
--#### BARREL SHIFTER

    s_A        <= x"0000FFFF";  
    s_B        <= x"00000004";
    S_repl     <= x"A0";
    s_control  <= x"4";    -- sll exepected: 0x000FFFF0
 
    wait for 10 ns;

    s_A        <= x"F000FFFF";  
    s_B        <= x"00000004";
    S_repl     <= x"A0";
    s_control  <= x"4";    -- sll exepected: 0x000FFFF0
 
    wait for 10 ns;

    s_A        <= x"FFFF0000";  
    s_B        <= x"00000004";
    S_repl     <= x"A0";
    s_control  <= x"5";    -- srl exepected: 0x0FFFF000 
 
    wait for 10 ns;

    s_A        <= x"FFFF000F";  
    s_B        <= x"00000004";
    S_repl     <= x"A0";
    s_control  <= x"5";    -- srl exepected: 0x0FFFF000 
 
    wait for 10 ns;

    s_A        <= x"FFFF0000";  
    s_B        <= x"00000004";
    S_repl     <= x"A0";
    s_control  <= x"6";    -- sra exepected: 0xFFFFF000 
 
    wait for 10 ns;

    s_A        <= x"FFFF000F";  
    s_B        <= x"00000004";
    S_repl     <= x"A0";
    s_control  <= x"6";    -- sra exepected: 0xFFFFF000 
 
    wait for 10 ns;
--#####

    s_A        <= x"F0001001";  
    s_B        <= x"F0000000";
    S_repl     <= x"A0";
    s_control  <= x"7";    -- xor exepected: 0x00001001
 
    wait for 10 ns;

    s_A        <= x"000000FF";  
    s_B        <= x"00FFFFFF";
    S_repl     <= x"A0";
    s_control  <= x"8";    -- slt exepected: 0x10000000
 
    wait for 10 ns;

--SLT not sure


    s_A        <= x"F0001001";  
    s_B        <= x"F0000000";
    S_repl     <= x"A0";
    s_control  <= x"9";    -- slt exepected: 
 
--    wait for 10 ns;



    s_A        <= x"FFFFFF00";  
    s_B        <= x"00000000";
    S_repl     <= x"A0";
    s_control  <= x"A";    -- repl exepected: 0xA0A0A0A0
 
    wait for 10 ns;

--movn

    s_A        <= x"F0001001";  
    s_B        <= x"F0000000";
    S_repl     <= x"A0";
    s_control  <= x"B";    -- movn exepected: 0xF0001001
 
    wait for 10 ns;
    
  end process;


end mixed;

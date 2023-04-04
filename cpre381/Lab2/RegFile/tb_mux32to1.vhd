library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; 
library std;
use std.env.all;             
use std.textio.all;             


entity tb_mux32to1 is
--  generic(N : integer := 32;
--	  M : integer := 5);
end tb_mux32to1;

architecture mixed of tb_mux32to1 is

component mux32to1 is
--  generic(N : integer := 32;
--	  M : integer := 5);

port ( D0:  in std_logic_vector (31 downto 0);
       D1:  in std_logic_vector (31 downto 0);
       D2:  in std_logic_vector (31 downto 0);
       D3:  in std_logic_vector (31 downto 0);
       D4:  in std_logic_vector (31 downto 0);
       D5:  in std_logic_vector (31 downto 0);
       D6:  in std_logic_vector (31 downto 0);
       D7:  in std_logic_vector (31 downto 0);
       D8:  in std_logic_vector (31 downto 0);
       D9:  in std_logic_vector (31 downto 0);
       D10: in std_logic_vector (31 downto 0);
       D11: in std_logic_vector (31 downto 0);
       D12: in std_logic_vector (31 downto 0);
       D13: in std_logic_vector (31 downto 0);
       D14: in std_logic_vector (31 downto 0);
       D15: in std_logic_vector (31 downto 0);

       D16: in std_logic_vector (31 downto 0);
       D17: in std_logic_vector (31 downto 0);
       D18: in std_logic_vector (31 downto 0);
       D19: in std_logic_vector (31 downto 0);
       D20: in std_logic_vector (31 downto 0);
       D21: in std_logic_vector (31 downto 0);
       D22: in std_logic_vector (31 downto 0);
       D23: in std_logic_vector (31 downto 0);
       D24: in std_logic_vector (31 downto 0);
       D25: in std_logic_vector (31 downto 0);
       D26: in std_logic_vector (31 downto 0);
       D27: in std_logic_vector (31 downto 0);
       D28: in std_logic_vector (31 downto 0);
       D29: in std_logic_vector (31 downto 0);
       D30: in std_logic_vector (31 downto 0);
       D31: in std_logic_vector (31 downto 0);

       SEL: in std_logic_vector(4 downto 0);
       MX_OUT : out std_logic_vector (31 downto 0));
end component;

  signal S_31        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_30        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_29        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_28        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_27        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_26        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_25        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_24        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_23        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_22        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_21        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_20        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_19        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_18        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_17        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_16        : std_logic_vector(31 downto 0) := (others => '0');

  signal S_15        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_14        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_13        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_12        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_11        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_10        : std_logic_vector(31 downto 0) := (others => '0');
  signal S_9         : std_logic_vector(31 downto 0) := (others => '0');
  signal S_8         : std_logic_vector(31 downto 0) := (others => '0');
  signal S_7         : std_logic_vector(31 downto 0) := (others => '0');
  signal S_6         : std_logic_vector(31 downto 0) := (others => '0');
  signal S_5         : std_logic_vector(31 downto 0) := (others => '0');
  signal S_4         : std_logic_vector(31 downto 0) := (others => '0');
  signal S_3         : std_logic_vector(31 downto 0) := (others => '0');
  signal S_2         : std_logic_vector(31 downto 0) := (others => '0');
  signal S_1         : std_logic_vector(31 downto 0) := (others => '0');
  signal S_0         : std_logic_vector(31 downto 0) := (others => '0');

  signal S_SEL       : std_logic_vector(4 downto 0);
  signal S_Out       : std_logic_vector (31 downto 0);


begin

  DUT0: mux32to1
--  generic map(N => N)
  port map(
            D0      => S_0,
            D1      => S_1,
            D2      => S_2,
            D3      => S_3,
            D4      => S_4,
            D5      => S_5,
            D6      => S_6,
            D7      => S_7,
            D8      => S_8,
            D9      => S_9,
            D10     => S_10,
            D11     => S_11,
            D12     => S_12,
            D13     => S_13,
            D14     => S_14,
            D15     => S_15,

            D16     => S_16,
            D17     => S_17,
            D18     => S_18,
            D19     => S_19,
            D20     => S_20,
            D21     => S_21,
            D22     => S_22,
            D23     => S_23,
            D24     => S_24,
            D25     => S_25,
            D26     => S_26,
            D27     => S_27,
            D28     => S_28,
            D29     => S_29,
            D30     => S_30,
            D31     => S_31,

	    SEL     => S_SEL,
            MX_OUT     => S_Out);

  P_TEST_CASES: process
  begin
 

    
    S_0   <= x"FFFFFFFF";   
    S_SEL   <= "00000";

    wait for 10 ns;
 
    S_5   <= x"12348765";   
    S_SEL   <= "00101";
 
    wait for 10 ns;
 
    S_5   <= x"12348765";   
    S_SEL   <= "00111";
 
    wait for 10 ns;

    S_7   <= x"33F44007";   
    S_SEL   <= "00111";
 
    wait;

    
  end process;


end mixed;


























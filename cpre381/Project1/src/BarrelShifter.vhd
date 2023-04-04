-------------------------------------------------------------------------
-- Derek Lengemann
-- 
-- Iowa State University
-------------------------------------------------------------------------


-- BarrelShifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity BarrelShifter is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Data          : in std_logic_vector(N-1 downto 0);
	i_Shift		: in std_logic_vector(4 downto 0);
	i_RoL		:in std_logic;
	i_AoL		:in std_logic;
        o_X          : out std_logic_vector(N-1 downto 0));

end BarrelShifter;

architecture structural of BarrelShifter is

  component Mux2to1 is
    port(S                  : in std_logic;
         A                 : in std_logic;
         B                 : in std_logic;
         O                  : out std_logic);
  end component;
  
  component mux2t1_N is
     generic(N : integer := 32);
     port(i_S		:in std_logic;
	  i_D0		:in std_logic_vector(N-1 downto 0);
	  i_D1		:in std_logic_vector(N-1 downto 0);
	  o_O		:out std_logic_vector(N-1 downto 0));
  end component;
signal s_B		: std_logic;
signal s_R, s_RI, s_RO, s_funky	: std_logic_vector(31 downto 0);
signal s_In		: std_logic_vector(31 downto 0);
type arr is array (0 to 5) of std_logic_vector(31 downto 0); 
	signal s_data : arr;
	signal s_A : arr;

  
begin
	s_R(0) <= i_Data(31);
	s_R(1) <= i_Data(30);
	s_R(2) <= i_Data(29);
	s_R(3) <= i_Data(28);
	s_R(4) <= i_Data(27);
	s_R(5) <= i_Data(26);
	s_R(6) <= i_Data(25);
	s_R(7) <= i_Data(24);
	s_R(8) <= i_Data(23);
	s_R(9) <= i_Data(22);
	s_R(10) <= i_Data(21);
	s_R(11) <= i_Data(20);
	s_R(12) <= i_Data(19);
	s_R(13) <= i_Data(18);
	s_R(14) <= i_Data(17);
	s_R(15) <= i_Data(16);
	s_R(16) <= i_Data(15);
	s_R(17) <= i_Data(14);
	s_R(18) <= i_Data(13);
	s_R(19) <= i_Data(12);
	s_R(20) <= i_Data(11);
	s_R(21) <= i_Data(10);
	s_R(22) <= i_Data(9);
	s_R(23) <= i_Data(8);
	s_R(24) <= i_Data(7);
	s_R(25) <= i_Data(6);
	s_R(26) <= i_Data(5);
	s_R(27) <= i_Data(4);
	s_R(28) <= i_Data(3);
	s_R(29) <= i_Data(2);
	s_R(30) <= i_Data(1);
	s_R(31) <= i_Data(0);
	

	RightorLeft: mux2t1_N
		
		port map (
			  i_S => i_RoL,
			  i_D0 => i_Data,
			  i_D1 => s_R,
			  o_O => s_In);
	s_data(0) <= s_In;
	AoL: Mux2to1
		port map (
			  S => i_AoL,
			  A => '0',
			  B => s_In(0),
			  O => s_B);

	generate_regs : for i in 1 to 5 generate
	s_A(i - 1) <= s_data(i - 1)((31 - 2 ** (i - 1)) downto 0) & ((2 ** (i - 1)) - 1 downto 0 => s_B);
	
	shift1: mux2t1_N
		port map (i_S => i_Shift(i - 1),
			  i_D0 => s_data(i - 1),
			  i_D1 => s_A(i - 1),
			  o_O  => s_data(i));


	end generate generate_regs;
	s_RI <= s_data(5);
	s_funky <= s_data(5);
	s_RO(0) <= s_RI(31);
	s_RO(1) <= s_RI(30);
	s_RO(2) <= s_RI(29);
	s_RO(3) <= s_RI(28);
	s_RO(4) <= s_RI(27);
	s_RO(5) <= s_RI(26);
	s_RO(6) <= s_RI(25);
	s_RO(7) <= s_RI(24);
	s_RO(8) <= s_RI(23);
	s_RO(9) <= s_RI(22);
	s_RO(10) <= s_RI(21);
	s_RO(11) <= s_RI(20);
	s_RO(12) <= s_RI(19);
	s_RO(13) <= s_RI(18);
	s_RO(14) <= s_RI(17);
	s_RO(15) <= s_RI(16);
	s_RO(16) <= s_RI(15);
	s_RO(17) <= s_RI(14);
	s_RO(18) <= s_RI(13);
	s_RO(19) <= s_RI(12);
	s_RO(20) <= s_RI(11);
	s_RO(21) <= s_RI(10);
	s_RO(22) <= s_RI(9);
	s_RO(23) <= s_RI(8);
	s_RO(24) <= s_RI(7);
	s_RO(25) <= s_RI(6);
	s_RO(26) <= s_RI(5);
	s_RO(27) <= s_RI(4);
	s_RO(28) <= s_RI(3);
	s_RO(29) <= s_RI(2);
	s_RO(30) <= s_RI(1);
	s_RO(31) <= s_RI(0);
	RightorLeft2: mux2t1_N
		
		port map (
			  i_S => i_RoL,
			  i_D0 => s_funky,
			  i_D1 => s_RO,
			  o_O => o_X);
end structural;
  		          
	

	

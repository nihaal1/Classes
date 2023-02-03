library IEEE;
use IEEE.std_logic_1164.all;

entity movn is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_RT         : in std_logic_vector(N-1 downto 0);
       i_ALUOp      : in std_logic_vector(3 downto 0); --       i_ALUOp      : in std_logic_vector(5 downto 0)
       i_RegWr      : in std_logic;
       o_O          : out std_logic);

end movn;

architecture behavioural of movn is
begin  
--change ALUOp to whatever we use to declare the instruction as movn
   --o_O <= '0' when ((i_ALUOp = "111111") and (i_RT = "00000000000000000000000000000000")) else i_RegWr;
o_O <= '0' when ((i_ALUOp = "1011") and (i_RT = "00000000000000000000000000000000")) else i_RegWr;          

  

end behavioural;

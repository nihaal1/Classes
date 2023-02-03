library IEEE;
use IEEE.std_logic_1164.all;

entity mux16to1 is
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

       SEL: in std_logic_vector(3 downto 0);
       MX_OUT : out std_logic_vector (31 downto 0));
end mux16to1;

architecture dataflow of mux16to1 is

begin

     with SEL select
	MX_OUT <= 
	D0  when "0000",    --add
	D1  when "0001",    --sub
	D2  when "0010",    -- and
	D3  when "0011",    --or
	D4  when "0100",    --sll
	D5  when "0101",    --srl
	D6  when "0110",    --sra
	D7  when "0111",    --xor
	D8  when "1000",    --nor
	D9  when "1001",    --slt
	D10 when "1010",    --repl.qb
	D11 when "1011",    --movn
	D12 when "1100",    --lui
	D13 when "1101",    --
	D14 when "1110",    --      
	D15 when "1111",    --
	x"00000000" when others;


end dataflow;





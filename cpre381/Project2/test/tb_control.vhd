library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_control is
  --generic(N : integer := 32);
end tb_control;

architecture mixed of tb_control is

component control is
  --generic(N : integer := 32);

  port (D_IN	  : in std_logic_vector(31 downto 0); 
	RegDst    : out std_logic;                   
	J_O       : out std_logic;                   
	J_link    : out std_logic;                   
	J_reg     : out std_logic;                    
	branch    : out std_logic;	              
	beq_bne   : out std_logic;	             
	MemtoReg  : out std_logic;                    
	ALUOp     : out std_logic_vector(3 downto 0); 
	MemWrite  : out std_logic;  
	ALUSrc    : out std_logic;                    
	RegWrite  : out std_logic; 
	Halt      : out std_logic); 
end component;


  signal s_D_IN      : std_logic_vector(31 downto 0);
  signal s_RegDst    : std_logic;
  signal S_J_O       : std_logic;
  signal s_J_link    : std_logic;
  signal s_J_reg     : std_logic;
  signal s_branch    : std_logic;
  signal s_beq_bne   : std_logic;
  signal s_MemtoReg  : std_logic;
  signal s_ALUOp     : std_logic_vector(3 downto 0);
  signal s_MemWrite  : std_logic;
  signal s_ALUSrc    : std_logic;
  signal s_RegWrite  : std_logic;
  signal s_Halt      : std_logic;

begin

  control_test: control
--generic map(N => N)
  port map(
            D_IN      => s_D_IN,
            RegDst    => s_RegDst,
            J_O       => S_J_O,
            J_link    => s_J_link,
            J_reg     => s_J_reg,
            branch    => s_branch,
            beq_bne   => s_beq_bne,
            MemtoReg  => s_MemtoReg,
            ALUOp     => s_ALUOp,
            MemWrite  => s_MemWrite,
            ALUSrc    => s_ALUSrc,
            RegWrite  => s_RegWrite,
            Halt      => s_Halt);

  P_TEST_CASES: process
  begin
 

    
    s_D_IN        <= x"00000020";   -- add    00 0000/ 10 0000
    wait for 10 ns;
 
    s_D_IN        <= x"20000000";   -- addi   00 1000
    wait for 10 ns;
    
    s_D_IN        <= x"24000000";   -- addiu   00 1001        
    wait for 10 ns;
    
    s_D_IN        <= x"00000021";   -- addu  
    wait for 10 ns;

    s_D_IN        <= x"00000024";   -- and  
    wait for 10 ns;
     
    s_D_IN        <= x"30000000";   -- andi  
    wait for 10 ns;
    
    s_D_IN        <= x"3F000000";   -- lui   
    wait for 10 ns;
    
    s_D_IN        <= x"8F000000";   -- lw    
    wait for 10 ns;

    s_D_IN        <= x"F8000000";   -- not
    wait for 10 ns;

    s_D_IN        <= x"00000027";   -- nor
    wait for 10 ns;
 
    s_D_IN        <= x"00000026";   -- xor  
    wait for 10 ns;
    
    s_D_IN        <= x"28000000";   -- xori   
    wait for 10 ns;
    
    s_D_IN        <= x"00000025";   -- or 
    wait for 10 ns;

    s_D_IN        <= x"34000000";   -- ori
    wait for 10 ns;
    
    s_D_IN        <= x"0000002A";   -- slt
    wait for 10 ns;
 
    s_D_IN        <= x"28000000";   -- slti  
    wait for 10 ns;
    
    s_D_IN        <= x"00000000";   -- sll   
    wait for 10 ns;
    
    s_D_IN        <= x"00000002";   -- srl 
    wait for 10 ns;

    s_D_IN        <= x"00000003";   -- sra
    wait for 10 ns;

    s_D_IN        <= x"AC000000";   -- sw
    wait for 10 ns;
 
    s_D_IN        <= x"00000023";   -- sub  
    wait for 10 ns;
    
    s_D_IN        <= x"10000000";   -- beq   
    wait for 10 ns;
    
    s_D_IN        <= x"14000000";   -- bne 
    wait for 10 ns;

    s_D_IN        <= x"08000000";   -- J
    wait for 10 ns;
    
    s_D_IN        <= x"0C000000";   -- jal
    wait for 10 ns;
 
    s_D_IN        <= x"00000008";   -- jr  
    wait for 10 ns;
    
    s_D_IN        <= x"7C000000";   -- repl   
    wait for 10 ns;
    
    s_D_IN        <= x"FC000000";   -- movn 
    wait for 10 ns;

    wait;


    
  end process;


end mixed;

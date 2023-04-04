library IEEE;
use IEEE.std_logic_1164.all;

entity control is
  --generic(N : integer := 32;
	--  M : integer := 5);


--we won't need MemToRead (cause its useless)
  port (D_IN	  : in std_logic_vector(31 downto 0); --32 bit instruction
	RegDst    : out std_logic;                    -- Do we store to [rd](R type) or to [rt] (I type)
	J_O       : out std_logic;                    -- Jump            J
	J_link    : out std_logic;                    -- Jump and link   JAL
	J_reg     : out std_logic;                    -- Jump register   JR
	branch    : out std_logic;	              -- branch enabler
	beq_bne   : out std_logic;	              -- 0 for beq and 1 bne
	MemtoReg  : out std_logic;                    -- select line for the mux which decided if it should read from the memory or ALU
	ALUOp     : out std_logic_vector(3 downto 0);                    -- OPcode for ALU
	MemWrite  : out std_logic;  -- Memory Enabler
	ALUSrc    : out std_logic;                    -- Chooses where rd will come from (register or immediate value)
	RegWrite  : out std_logic; -- Register Enabler
	Halt      : out std_logic; -- Halt Enabler
	Overflow  : out std_logic; -- Overflow control
	Extension : out std_logic); -- Sign and Zero Extension

end control;

architecture dataflow of control is

constant R     : std_logic_vector(5 downto 0) := "000000";

constant add   : std_logic_vector(5 downto 0) := "100000";
constant addi  : std_logic_vector(5 downto 0) := "001000";
constant addiu : std_logic_vector(5 downto 0) := "001001";
constant addu  : std_logic_vector(5 downto 0) := "100001";
constant and0  : std_logic_vector(5 downto 0) := "100100";
constant andi  : std_logic_vector(5 downto 0) := "001100";
constant lui   : std_logic_vector(5 downto 0) := "001111";
constant lw    : std_logic_vector(5 downto 0) := "100011";
constant not0  : std_logic_vector(5 downto 0) := "111110";
constant nor0  : std_logic_vector(5 downto 0) := "100111";
constant xor0  : std_logic_vector(5 downto 0) := "100110";
constant xori  : std_logic_vector(5 downto 0) := "001110";
constant or0   : std_logic_vector(5 downto 0) := "100101";
constant ori   : std_logic_vector(5 downto 0) := "001101";
constant slt   : std_logic_vector(5 downto 0) := "101010";
constant slti  : std_logic_vector(5 downto 0) := "001010";
constant sll0  : std_logic_vector(5 downto 0) := "000000";  --sll isKeyword
constant srl0  : std_logic_vector(5 downto 0) := "000010"; -- srl isKeyword
constant sra0  : std_logic_vector(5 downto 0) := "000011";  --sra isKeyword
constant sw    : std_logic_vector(5 downto 0) := "101011";
constant sub   : std_logic_vector(5 downto 0) := "100010";
constant subu  : std_logic_vector(5 downto 0) := "100011";
constant beq   : std_logic_vector(5 downto 0) := "000100";
constant bne   : std_logic_vector(5 downto 0) := "000101";
constant J     : std_logic_vector(5 downto 0) := "000010";
constant jal   : std_logic_vector(5 downto 0) := "000011";
constant jr    : std_logic_vector(5 downto 0) := "001000";
constant repl  : std_logic_vector(5 downto 0) := "011111";  --repl.qb
constant movn  : std_logic_vector(5 downto 0) := "001011";  -- 

signal func_aluOp  : std_logic_vector(3 downto 0);
signal RegWrite0  : std_logic;
signal RegWrite1  : std_logic;





--signal I_OUT	: std_logic_vector(31 downto 0);

begin
  
--with D_IN(31 downto 26) & D_In(5 downto 0) select -- for multiple ones
--I_OUT <= '1' when "000010", '1' when "00100"


-- RegDst 

with D_IN(31 downto 26) select
RegDst <= '1' when R, '0' when addi, '0' when addiu, '0' when andi, '0' when lui,
	  '0' when lw, '0' when ori,  '0' when xori,  '0' when slti, 
	  '0' when sw, '0' when beq,  '0' when bne,'1' when repl, 'X' when others;  --'1' when jr,

-- J                                       --J, jal, jr


--with D_IN(31 downto 26) & D_In(5 downto 0) select  
--	J_O <= '0' when R & jr,'1' when J & "XXXXXX",'1' when jal & "XXXXXX",'0' when others;

with D_IN(31 downto 26)  select  
	J_O <= '1' when J ,'1' when jal ,'0' when others;






--J_ins: process(D_IN) is
--begin

--with D_IN select
-- J_O <= '1' when J,
--	'1' when jal,
--	'1' when jr,
--	'0' when others;


--if D_IN(31 downto 26) /= R then 
--	with D_IN(31 downto 26) select
--		J_O <= '1' when J,'1' when jal,'0' when others; -- opcoder + other stuff + func code 

--else

--with D_IN(31 downto 26) & D_In(5 downto 0) select     
--J_O <= '0' when R & jr,'0' when others;        

--end if;
--end process  J_ins;




-- Jump_link                                       --jal  
with D_IN(31 downto 26) select
J_link <= '1' when jal, '0' when others;

      




-- Jump_register                                       --jr

with D_IN(31 downto 26) & D_In(5 downto 0) select     -- ################# not sure TODO if there is more to add!!
J_reg <= '1' when R & jr,'0' when others;        




-- branch                                  -- beq, bne 
with D_IN(31 downto 26) select
branch <= '1' when beq, '1' when bne, '0' when others;

-- beq_bne                                  -- 0 for beq and 1 bne
with D_IN(31 downto 26) select
beq_bne <= '0' when beq, '1' when bne, '0' when others;     

 
--MemtoReg (ignore MemRead, it's useless)   --lw, lui
with D_IN(31 downto 26) select
MemtoReg <= '1' when lw, '0' when others;

-- ALUOp 			    
--add, addi, addiu, addu, and, andi, nor, xor, xori, or, ori, slt, slti, sll, srl, sra, sub,subu repl.qb


with D_IN(31 downto 26) select
ALUOp <= func_ALUOp when R,
         "0000" when addi, 
         "0000" when addiu,
         "0010" when andi, 
	 "0111" when xori,
         "0011" when ori,
         "1001" when slti, 
	 "1010" when repl,
         "1100" when lui,
         "0000" when sw,
         "0000" when lw,
         "XXXX" when others; 


with D_IN(5 downto 0) select
func_ALUOp <= "0000" when add, "0000" when addu, "0010" when and0,  
	      "1000" when nor0, "0111" when xor0, "0011" when or0,  
	      "1001" when slt, "0100" when sll0, "0101" when srl0,  
	      "0110" when sra0, "0001" when sub, "0001" when subu,
              "1011" when movn, "XXXX" when others; 

--ALU_Op: process(D_IN) is
--begin

--if D_IN(31 downto 26) /= R then 
--with D_IN(31 downto 26) select      
--ALUOp <= "0000" when addi, "0000" when addiu, "0010" when andi, 
--	 "0111" when xori, "0011" when ori, "1001" when slti, 
--	 "1010" when repl, "1100" when lui, "0000" when others; 
--else
	             
--with D_IN(31 downto 26) & D_In(5 downto 0) select
--ALUOp <= "0000" when R & add, "0000" when R & addu, "0010" when R & and0,  
--	 "1000" when R & nor0, "0111" when R & xor0, "0011" when R & or0,  
--	 "1001" when R & slt, "0100" when R & sll0, "0101" when R & srl0,  
--	 "0110" when R & sra0, "0001" when R & sub, "0001" when R & subu,
--         "1011" when R & movn, "XXXX" when others; 
--end if;
--end process  ALU_Op;


-- MemWrite               		    --sw
with D_IN(31 downto 26) select
MemWrite <= '1' when sw, '0' when others;


--TODO
--Halt    --Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
-- Off all your control output signals when when the opcode is 01 0100

with D_IN(31 downto 26) select
Halt <= '1' when "010100" ,'0' when others;




-- ALUSrc              		    --addi, addiu, andi, lui
with D_IN(31 downto 26) select      -- lw, ori, xori, slti, sw, beq, bne,
ALUSrc <= '1' when addi, '1' when addiu, '1' when andi, '1' when lui,
	 '1' when lw, '1' when ori, '1' when xori, '1' when slti, 
	 '1' when sw,'1' when repl, '0' when beq, '0' when bne, '0' when others;

  

-- RegWrite     

  --add, addi, addiu, addu, and, andi, lui, lw, not, nor, xor, xori, or, ori, slt, slti, sll, srl, sra, sub, subu jr, repl.qb

with D_IN(31 downto 26) & D_In(5 downto 0) select
RegWrite0 <= '1' when R & add,  '1' when R & addu, '1' when R & and0,  
	 '1' when R & nor0, '1' when R & xor0, '1' when R & or0,  
	 '1' when R & slt,  '1' when R & sll0, '1' when R & srl0,  
	 '1' when R & sra0, '1' when R & sub, '1' when R & subu, 
         '1' when R & jr, '1' when R & movn, 
         '0' when others;



with D_IN(31 downto 26) select
RegWrite1 <=  '1' when addi, '1' when addiu , '1' when andi , '1' when lui ,
	 '1' when lw ,   '1' when not0,  '1' when xori, '1' when ori,
         '1' when jal ,  '1' when slti , '1' when repl, '0' when others;

RegWrite <= RegWrite0 or RegWrite1;



--Reg_write: process(D_IN) is
--begin

--if D_IN(31 downto 26) /= R then 
--with D_IN(31 downto 26) select      
--RegWrite <= '1' when addi, '1' when addiu, '1' when andi, '1' when lui,
--	 '1' when lw,   '1' when not0,  '1' when xori, '1' when ori,'1' when jal,
--	 '1' when slti, '1' when repl, '0' when others; 
	
--else 
             
--with D_IN(31 downto 26) & D_In(5 downto 0) select
--RegWrite <= '1' when R & add,  '1' when R & addu, '1' when R & and0,  
--	 '1' when R & nor0, '1' when R & xor0, '1' when R & or0,  
--	 '1' when R & slt,  '1' when R & sll0, '1' when R & srl0,  
--	 '1' when R & sra0, '1' when R & sub, '1' when R & subu, '1' when R & jr, '1' when R & movn, '0' when others;


--end if;
--end process  Reg_write;



-- Overflow              		    --add, addi, sub

with D_IN(31 downto 26) & D_In(5 downto 0) select
Overflow <= '1' when R & add, '1' when R & sub, '1' when addi & "XXXXXX", '0' when others;



--Overflow_0: process(D_IN) is
--begin

--if D_IN(31 downto 26) /= R then 
--with D_IN(31 downto 26) select     
   
--Overflow <= '1' when addi, '0' when others; 

--else 
             
--with D_IN(31 downto 26) & D_In(5 downto 0) select
--Overflow <= '1' when R & add, '1' when R & sub, '0' when others;


--end if;
--end process  Overflow_0;	 



  
-- Extension              		    --addi, addiu, lw, slti, sw
with D_IN(31 downto 26) select      
Extension <= '1' when addi, '1' when addiu, '1' when lw, '1' when slti,  '1' when bne, '1' when beq,'1' when sw, '0' when others; 
	   


end dataflow;




-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH;
	  M : integer := 5);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory "write enable" signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory "address input"
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory "data input"
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the "data memory output"
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high "write enable" input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final "destination register address" input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory "data input"

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  signal pc_plus4       : std_logic_vector(N-1 downto 0);

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

--Control Signals
  signal s_RegDst       : std_logic;
  signal s_J_O          : std_logic;
  signal s_J_link       : std_logic;
  signal s_JR           : std_logic;
  signal s_branch       : std_logic;
  signal s_beq_bne      : std_logic;
  signal s_MemtoReg     : std_logic;
  signal s_ALUOp        : std_logic_vector(3 downto 0);
  signal s_MemWrite     : std_logic;
  signal s_ALUSrc       : std_logic;
  signal s_overflow     : std_logic;
  signal s_Extension    : std_logic;
  signal temp_RegWr     : std_logic;

  signal ALU_Ovfl       : std_logic;



--Reg Signals
  signal RS              : std_logic_vector(N-1 downto 0); 
  signal RT              : std_logic_vector(N-1 downto 0); 
  signal S_extenderOut   : std_logic_vector(N-1 downto 0);
  signal S_MX_OUT_Reg        : std_logic_vector(N-1 downto 0);

--ALU
  signal s_zero_out      : std_logic;
  signal overflow        : std_logic;
  --signal s_ALU_Output        : std_logic_vector(N-1 downto 0);

-- MUX_ALUorDMem
  signal S_ALUorDMem     : std_logic_vector(N-1 downto 0);


--Branch (top right of processor design)
  signal o_shifted       : std_logic_vector(31 downto 0);
  signal s_ANDOut        : std_logic;
  signal s_XOROut        : std_logic;
  signal s_AddBranch     : std_logic_vector(31 downto 0);

--Jump (top right of processor design)
  signal s_JumpIn        : std_logic_vector(31 downto 0);
  signal s_JRIn          : std_logic_vector(31 downto 0);
  signal s_JAL_addr_MUX  : std_logic_vector(4 downto 0);
  signal s_MemToReg_old  : std_logic_vector(31 downto 0);

  signal s_finalPC       : std_logic_vector (31 downto 0);


-- Barrel Shifter 
  signal o_ImemShifted : std_logic_vector(31 downto 0);

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

component pc is
  port(i_CLK        : in std_logic;     
       i_RST        : in std_logic;     
       i_WE         : in std_logic;  
       i_D          : in std_logic_vector(31 downto 0);     
       o_Q          : out std_logic_vector(31 downto 0));
    end component;

component ripple_adder is
  port(A         : in std_logic_vector(N-1 downto 0);
       B         : in std_logic_vector(N-1 downto 0);
       Cin       : in std_logic;
       ovfl      : out std_logic;
       Cout      : out std_logic;
       O         : out std_logic_vector(N-1 downto 0));

  end component;

component xorg2 is         --NEW COMPONENT for branch instruction
     port(i_A          : in std_logic;
          i_B          : in std_logic;
          o_F          : out std_logic);
     end component;


component andg2 is         --NEW COMPONENT for branch instruction
     port(i_A          : in std_logic;
          i_B          : in std_logic;
          o_F          : out std_logic);
     end component;

component BarrelShifter is   --NEW COMPONENT for branch instruction
  port(i_Data           : in std_logic_vector(31 downto 0);
	i_Shift		: in std_logic_vector(4 downto 0);
	i_RoL		:in std_logic;
	i_AoL		:in std_logic;
        o_X             : out std_logic_vector(31 downto 0));
     end component;

component reg_file is
    port (D_IN	: in std_logic_vector(M-1 downto 0); 
	  En	: in std_logic;	 		      
          i_CLK   : in std_logic;   		     
          i_RST   : in std_logic;                       
          i_D     : in std_logic_vector(N-1 downto 0);
          SEL1     : in std_logic_vector(4 downto 0);   
          SEL2     : in std_logic_vector(4 downto 0);   
          MX_OUT1  : out std_logic_vector (31 downto 0);
          MX_OUT2  : out std_logic_vector (31 downto 0));
  end component;

component movn is
    port(i_RT       : in std_logic_vector(N-1 downto 0);
       i_ALUOp      : in std_logic_vector(3 downto 0);
       i_RegWr      : in std_logic;
       o_O          : out std_logic);
  end component;



component control is
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
	Halt      : out std_logic;
        Overflow  : out std_logic;
        Extension  : out std_logic);
    end component;


component extender
  port(input 		            : in std_logic_vector (15 downto 0);
       sel 		            : in std_logic;
       output 		            : out std_logic_vector (31 downto 0));

  end component;

 component mux2to1_32
    port ( D0:  in std_logic_vector (31 downto 0);
           D1:  in std_logic_vector (31 downto 0);
           SEL: in std_logic;
           MX_OUT : out std_logic_vector (31 downto 0));

  end component;

 component mux2to1_5
    port (D0:  in std_logic_vector (4 downto 0);
          D1:  in std_logic_vector (4 downto 0);
          SEL: in std_logic;
          MX_OUT : out std_logic_vector (4 downto 0)); 

  end component;


component ALU is
  generic(N : integer := 32);
  port(A           : in std_logic_vector(N-1 downto 0);
       B           : in std_logic_vector(N-1 downto 0);
       shamt       : in std_logic_vector(4 downto 0);
       replqb_in   : in std_logic_vector(7 downto 0);
       ALU_control : in std_logic_vector(3 downto 0);
       zero_out    : out std_logic;
       overflow    : out std_logic;
       Output      : out std_logic_vector(N-1 downto 0));
    end component;






begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

    s_Ovfl <= s_overflow and ALU_Ovfl; 


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);  --output of Imem
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);


   mux32_ALU_or_DMem : mux2to1_32
	  port MAP(D0       => oALUOut,
                   D1       => s_DMemOut,
                   SEL      => s_MemtoReg,
                   MX_OUT   => s_MemToReg_old);    


  Control_unit: control
    port map(D_IN      => s_Inst,
             RegDst    => s_RegDst,
             J_O       => s_J_O,
             J_link    => s_J_link,                -- #TODO
             J_reg     => s_JR,                 -- #TODO
             branch    => s_branch,
             beq_bne   => s_beq_bne ,                 -- #TODO
             MemtoReg  => s_MemtoReg,
             ALUOp     => s_ALUOp,
             MemWrite  => s_DMemWr,
             ALUSrc    => s_ALUSrc,
             RegWrite  => temp_RegWr,    
             Halt      => s_Halt,
	     Overflow  => s_Overflow,
	     Extension => s_Extension);

  PC_0: pc
    port map(
             i_CLK     => iCLK,
             i_RST     => iRST,
             i_we      => '1',
             i_D       => s_finalPC,
             o_Q       => s_NextInstAddr);

  PC_Adder: ripple_adder
    port map(A     => s_NextInstAddr,
             B     => x"00000004",
             Cin   => '0',
             ovfl  => open,
             Cout  => open,
             O     => pc_plus4);        


 --shiftLeftTwo: BarrelShifter    --shifted Imem that goes into the mux for the jump instruction
--	port MAP(i_Data          => "000000" & s_Inst(25 downto 0),                               -- TODO is this concotenation right in this case?
--	         i_Shift	 => "00010", 
--	         i_RoL		 => '0', 
--	         i_AoL		 => '0', 
--               o_X             => o_ImemShifted );                        -- #we only care about 27 downto 0

    o_ImemShifted <= "0000" & s_Inst(25 downto 0) & "00";
  
   mux32_JR : mux2to1_32       --MUX for JR instruction 
	  port MAP(D0       => s_JRIn,
                   D1       => RS,
                   SEL      => s_JR,
                   MX_OUT   => s_finalPC);

   mux32_jump : mux2to1_32       --MUX for jump 
	  port MAP(D0       => s_JumpIn,
                   D1       => pc_plus4(31 downto 28) & o_ImemShifted(27 downto 0),                       -- TODO is this concotenation right in this case?
                   SEL      => s_J_O,
                   MX_OUT   => s_JRIn);

   mux32_branch : mux2to1_32       --MUX for branch 
	  port MAP(D0       => pc_plus4,
                   D1       => s_AddBranch,
                   SEL      => s_ANDOut,
                   MX_OUT   => s_JumpIn);


  xorForBNE: xorg2               
	port MAP(i_A        => s_beq_bne,
		 i_B        => s_zero_out,
                 o_F        => s_XOROut); 


  andForBranch: andg2               --AND gate for branch instructions (top right of the processor design)
	port MAP(i_A        => s_branch,
		 i_B        => s_XOROut, 
                 o_F        => S_ANDOut); 

  branch_Adder: ripple_adder       --Adder for branch that adds output of PC_Adder with the sign-extended output shifted by 2
    port MAP(A     => pc_plus4,
             B     => S_extenderOut(29 downto 0) & "00",  
             Cin   => '0',
             ovfl  => open,
             Cout  => open,
             O     => S_AddBranch);  

   shiftLeft2: BarrelShifter    --shifted input that goes into the adder for the branch instruction
	port MAP(i_Data          => S_extenderOut, 
	         i_Shift	 => "00010", 
	         i_RoL		 => '0', 
	         i_AoL		 => '0', 
                 o_X             => o_shifted);




   reg1 : reg_file
	  port MAP(D_IN     => s_RegWrAddr,          
	 	   En	    => s_RegWr,	 		      
        	   i_CLK    => iCLK,   		     
       		   i_RST    => iRST,                       
        	   i_D      => s_RegWrData,   --dstData    
      		   SEL1     => s_Inst(25 downto 21),   
       		   SEL2     => s_Inst(20 downto 16),   
       		   MX_OUT1  => RS,
       		   MX_OUT2  => RT);
	s_DMemData <= RT;
                                
   mux5_Wr_Reg : mux2to1_5
	  port MAP(D0       => s_Inst(20 downto 16),
                   D1       => s_Inst(15 downto 11),
                   SEL      => s_RegDst,
                   MX_OUT   => s_JAL_addr_MUX);             


   extender_1 : extender
	  port MAP(input    => s_Inst(15 downto 0),
                   sel      => s_Extension,           
                   output   => S_extenderOut);

   mux32_ALU_imm : mux2to1_32
	  port MAP(D0       => RT,
                   D1       => S_extenderOut,
                   SEL      => s_ALUSrc,
                   MX_OUT   => S_MX_OUT_Reg);

   movn0 : movn
	  port MAP(i_RT       => RT,
                   i_ALUOp    => s_ALUOp,
                   i_RegWr    => temp_RegWr,
                   o_O        => s_RegWr);


   ALU_main : ALU
	  port MAP(A           => RS,
                   B           => S_MX_OUT_Reg,
                   shamt       => s_Inst(10 downto 6),
                   replqb_in   => s_Inst(23 downto 16),
                   ALU_control => s_ALUOp,
                   zero_out    => s_zero_out,
                   overflow    => ALU_Ovfl,                                            
                   Output      => s_DMemAddr); 

    oALUOut <= s_DMemAddr;

    mux32_JAL_address : mux2to1_5       --MUX for choosing b/w  
	  port MAP(D0       => s_JAL_addr_MUX,
                   D1       => "11111",
                   SEL      => s_J_link,
                   MX_OUT   => s_RegWrAddr);

   mux32_JAL_data : mux2to1_32       --MUX for branch 
	  port MAP(D0       => s_MemToReg_old,
                   D1       => pc_plus4,  -- ####################################################
                   SEL      => s_J_link,
                   MX_OUT   => s_RegWrData);


  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

end structure;


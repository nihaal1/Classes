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

--pipline registers
  signal dec_s_Inst : std_logic_vector(31 downto 0);
  signal dec_pc_plus4 : std_logic_vector(31 downto 0);
  signal dec1_pc_plus4 : std_logic_vector(31 downto 0);
  signal dec2_pc_plus4 : std_logic_vector(31 downto 0);
  signal dec3_pc_plus4 : std_logic_vector(31 downto 0);


	--pipline2
  signal dec1_s_Inst : std_logic_vector(31 downto 0);
  signal dec_MemtoReg : std_logic;
  signal dec_MemWrite : std_logic;
  signal dec_ALUOp : std_logic_vector(3 downto 0);
  signal dec_ALUSrc : std_logic;
  signal dec0_regWrite : std_logic; -- reg
  signal dec_regWrite : std_logic;
  signal dec_JumpLink : std_logic;
  signal dec_halt     : std_logic;
  signal dec_RegDst     : std_logic;

  signal dec_RS : std_logic_vector(N-1 downto 0);
  signal dec_RT : std_logic_vector(N-1 downto 0);
  signal dec0_reg_addr : std_logic_vector(4 downto 0);
  signal dec_reg_addr : std_logic_vector(4 downto 0);
  signal dec_SignExtended : std_logic_vector(N-1 downto 0);


	--pipline3
  signal dec_ALUOutput : std_logic_vector(N-1 downto 0);
  signal dec1_RT : std_logic_vector(N-1 downto 0);
  signal dec1_reg_addr : std_logic_vector(4 downto 0);

  signal dec1_MemtoReg : std_logic;
  signal dec1_MemWrite : std_logic;
  signal dec2_MemWrite : std_logic;
  signal dec1_regWrite : std_logic;
  signal dec1_JumpLink : std_logic;
  signal dec1_halt      : std_logic;
  signal dec1_RegDst     : std_logic;

	--pipline4
  signal dec2_MemtoReg : std_logic;
  signal dec2_regWrite : std_logic;
  signal dec2_JumpLink : std_logic;
  signal dec2_halt     : std_logic;
  signal dec2_RegDst     : std_logic;

  signal dec1_ALUOutput : std_logic_vector(N-1 downto 0);
  signal dec2_reg_addr : std_logic_vector(4 downto 0);

  signal dec_DMemOut : std_logic_vector(N-1 downto 0);

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

component zero_out is
  port(A           : in std_logic_vector(N-1 downto 0);
       B           : in std_logic_vector(N-1 downto 0);
       zero_Output : out std_logic);
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
       --zero_out    : out std_logic;
       overflow    : out std_logic;
       Output      : out std_logic_vector(N-1 downto 0));
    end component;


component registerIF_ID is
  generic(N : integer := 32);
    port(i_CLK          : in std_logic;     -- Clock input
       i_RST          : in std_logic;     -- Reset input
       i_WE           : in std_logic;     -- Write enable input
       i_Imem         : in std_logic_vector(N-1 downto 0);
       i_PCplus4      : in std_logic_vector(N-1 downto 0);
       o_PCplus4      : out std_logic_vector(N-1 downto 0);
       o_Imem         : out std_logic_vector(N-1 downto 0));
    end component;

component registerID_EX is
  generic(N : integer := 32);
      port(i_CLK          : in std_logic;     -- Clock input
       i_RST          : in std_logic;     -- Reset input
       i_WE           : in std_logic;     -- Write enable input

       i_MemtoReg     : in std_logic; 
       i_MemWrite     : in std_logic; 
       i_ALUOp        : in std_logic_vector(3 downto 0);   
       i_ALUSrc       : in std_logic; 
       i_regWrite     : in std_logic; 
       i_JumpLink     : in std_logic; 
       i_halt         : in std_logic;
       i_regDst       : in std_logic;
       i_PCplus4      : in std_logic_vector(N-1 downto 0);
       i_RS           : in std_logic_vector(N-1 downto 0);
       i_RT           : in std_logic_vector(N-1 downto 0);
       i_reg_addr     : in std_logic_vector(4 downto 0);
       i_SignExtended : in std_logic_vector(N-1 downto 0);
       i_Imem         : in std_logic_vector(31 downto 0);

       o_MemtoReg     : out std_logic; 
       o_MemWrite     : out std_logic; 
       o_ALUOp        : out std_logic_vector(3 downto 0); 
       o_ALUSrc       : out std_logic; 
       o_regWrite     : out std_logic; 
       o_JumpLink     : out std_logic; 
       o_halt         : out std_logic;
       o_regDst       : out std_logic;
       o_PCplus4      : out std_logic_vector(N-1 downto 0);
       o_RS           : out std_logic_vector(N-1 downto 0);
       o_RT           : out std_logic_vector(N-1 downto 0);
       o_reg_addr     : out std_logic_vector(4 downto 0);
       o_SignExtended : out std_logic_vector(N-1 downto 0);
       o_Imem         : out std_logic_vector(31 downto 0));
    end component;

component registerEX_MEM is
  generic(N : integer := 32);
    port(i_CLK          : in std_logic;     -- Clock input
       i_RST          : in std_logic;     -- Reset input
       i_WE           : in std_logic;     -- Write enable input

       i_ALU          : in std_logic_vector(N-1 downto 0);
       o_ALU          : out std_logic_vector(N-1 downto 0);
       i_PCplus4      : in std_logic_vector(N-1 downto 0);
       o_PCplus4      : out std_logic_vector(N-1 downto 0);
       i_RT           : in std_logic_vector(N-1 downto 0);
       o_RT           : out std_logic_vector(N-1 downto 0);
       i_reg_addr     : in std_logic_vector(4 downto 0);
       o_reg_addr     : out std_logic_vector(4 downto 0);

       i_MemReg       : in std_logic;
       o_MemReg       : out std_logic;
       i_MemWrite     : in std_logic;
       o_MemWrite     : out std_logic;
       i_regWrite     : in std_logic;
       o_regWrite     : out std_logic;
       i_JumpLink     : in std_logic;
       o_JumpLink     : out std_logic;
       i_regDst       : in std_logic;
       o_regDst       : out std_logic;
       i_halt         : in std_logic;
       o_halt         : out std_logic);
    end component;

component registerMEM_WB is
  generic(N : integer := 32);
  port(i_CLK          : in std_logic;     -- Clock input
       i_RST          : in std_logic;     -- Reset input
       i_WE           : in std_logic;     -- Write enable input

       i_MemtoReg     : in std_logic; 
       i_regWrite     : in std_logic; 
       i_JumpLink     : in std_logic; 
       i_halt         : in std_logic; 
       i_regDst       : in std_logic;
       i_PCplus4      : in std_logic_vector(N-1 downto 0);
       i_DMEM         : in std_logic_vector(N-1 downto 0);
       i_ALU          : in std_logic_vector(N-1 downto 0);
       i_reg_addr     : in std_logic_vector(4 downto 0);

       o_MemtoReg     : out std_logic; 
       o_regWrite     : out std_logic; 
       o_JumpLink     : out std_logic; 
       o_halt         : out std_logic; 
       o_regDst       : out std_logic;
       o_PCplus4      : out std_logic_vector(N-1 downto 0);
       o_DMEM         : out std_logic_vector(N-1 downto 0);
       o_ALU          : out std_logic_vector(N-1 downto 0);
       o_reg_addr     : out std_logic_vector(4 downto 0));
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
             data => s_DmemData,    -- s_DmemData, dec1_RT        -- needs mapping from EX/MEM reg
             we   => s_DMemWr,      -- s_DMemWr , dec1_MemWrite
             q    => s_DMemOut);    

s_DMemWr <= dec2_MemWrite;


   mux32_ALU_or_DMem : mux2to1_32
	  port MAP(D0       => dec1_ALUOutput,--s_DMemAddr,
                   D1       => dec_DMemOut,--s_DMemOut,
                   SEL      => dec2_MemtoReg,--s_MemtoReg,
                   MX_OUT   => s_MemToReg_old);    

  pipline1: registerIF_ID
    port map(
             i_CLK     => iCLK,
             i_RST     => iRST,
             i_we      => '1',
             i_Imem    => s_Inst,
             i_PCplus4 =>  pc_plus4,
             o_PCplus4 =>  dec_pc_plus4,
             o_Imem    =>  dec_s_Inst);


  Control_unit: control
    port map(D_IN      => dec_s_Inst,
             RegDst    => s_RegDst, --s_RegDst, dec_RegDst
             J_O       => s_J_O,
             J_link    => s_J_link,                -- #TODO
             J_reg     => s_JR,                 -- #TODO
             branch    => s_branch,
             beq_bne   => s_beq_bne ,                 -- #TODO
             MemtoReg  => s_MemtoReg,
             ALUOp     => s_ALUOp,
             MemWrite  => dec1_MemWrite,--s_DMemWr,
             ALUSrc    => s_ALUSrc,
             RegWrite  => temp_RegWr,    
             Halt      => dec_halt,
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


    o_ImemShifted <= "0000" & dec_s_Inst(25 downto 0) & "00";
  

   mux32_JR : mux2to1_32       --MUX for JR instruction 
	  port MAP(D0       => s_JRIn,
                   D1       => RS,
                   SEL      => s_JR,
                   MX_OUT   => s_finalPC);

   mux32_jump : mux2to1_32       --MUX for jump 
	  port MAP(D0       => s_JumpIn,
                   D1       => dec_pc_plus4(31 downto 28) & o_ImemShifted(27 downto 0),      
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
    port MAP(A     => dec_pc_plus4,
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
      		   SEL1     => dec_s_Inst(25 downto 21),   
       		   SEL2     => dec_s_Inst(20 downto 16),   
       		   MX_OUT1  => RS,
       		   MX_OUT2  => RT);


	s_RegWrAddr <= dec2_reg_addr;
	s_RegWr<= dec2_regWrite;
            

  pipline2: registerID_EX
    port map(
             i_CLK     => iCLK,
             i_RST     => iRST,
             i_we      => '1',

             i_MemtoReg     =>  s_MemtoReg,
             i_MemWrite     =>  dec1_MemWrite,--s_DMemWr,
             i_ALUOp        =>  s_ALUOp,
             i_ALUSrc       =>  s_ALUSrc,
             i_regWrite     =>  dec0_regWrite,
             i_JumpLink     =>  s_J_link,
	     i_halt         =>  dec_halt,
	     i_regDst       =>  dec_RegDst,
             i_PCplus4      =>  dec_pc_plus4,
             i_RS           =>  RS,
             i_RT           =>  RT,
             i_reg_addr     =>  dec0_reg_addr,--s_RegWrAddr,   --- ########### not sure
             i_SignExtended =>  S_extenderOut,
             i_Imem         =>  dec_s_Inst,

             o_MemtoReg     =>    dec_MemtoReg,
             o_MemWrite     =>    dec_MemWrite,
             o_ALUOp        =>    dec_ALUOp,
             o_ALUSrc       =>    dec_ALUSrc,
             o_regWrite     =>    dec_regWrite,
             o_JumpLink     =>    dec_JumpLink,
	     o_halt         =>    dec1_halt,
	     o_regDst       =>    dec1_RegDst,
             o_PCplus4      =>    dec1_pc_plus4,
             o_RS           =>    dec_RS,
             o_RT           =>    dec_RT,
             o_reg_addr     =>    dec_reg_addr,
             o_SignExtended =>    dec_SignExtended,
             o_Imem        =>    dec1_s_Inst);


   ALU_zero_out1 : zero_out
	  port MAP(A             => RS,
                   B             => RT,
                   zero_Output   => s_zero_out); 

                    
   mux5_Wr_Reg : mux2to1_5
	  port MAP(D0       => dec_s_Inst(20 downto 16),
                   D1       => dec_s_Inst(15 downto 11),
                   SEL      => s_RegDst,
                   MX_OUT   => s_JAL_addr_MUX);             


   extender_1 : extender
	  port MAP(input    => dec_s_Inst(15 downto 0),
                   sel      => s_Extension,           
                   output   => S_extenderOut);

   mux32_ALU_imm : mux2to1_32
	  port MAP(D0       => dec_RT,
                   D1       => dec_SignExtended,
                   SEL      => dec_ALUSrc,
                   MX_OUT   => S_MX_OUT_Reg);

   movn0 : movn
	  port MAP(i_RT       => RT,
                   i_ALUOp    => s_ALUOp,
                   i_RegWr    => temp_RegWr,
                   o_O        => dec0_regWrite);

-------- ############################################### THIS IS THE ALU ###########################

   ALU_main : ALU
	  port MAP(A           => dec_RS,
                   B           => S_MX_OUT_Reg,
                   shamt       => dec1_s_Inst(10 downto 6),  -- does this have to go through the next pipline.
                   replqb_in   => dec1_s_Inst(23 downto 16),
                   ALU_control => dec_ALUOp,
                   --zero_out    => s_zero_out,
                   overflow    => ALU_Ovfl,                                            
                   Output      => dec_ALUOutput); 


  pipline3: registerEX_MEM
    port map(
             i_CLK          => iCLK,
             i_RST          => iRST,
             i_we           => '1',

    	     i_ALU          => dec_ALUOutput,
    	     o_ALU          => s_DMemAddr,
     	     i_PCplus4      => dec1_pc_plus4,
             o_PCplus4      => dec2_pc_plus4,
      	     i_RT           => dec_RT,
       	     o_RT           => s_DmemData, --dec1_RT,
             i_reg_addr     => dec_reg_addr,
             o_reg_addr     => dec1_reg_addr,

             i_MemReg       => dec_MemtoReg,
             o_MemReg       => dec1_MemtoReg,
             i_MemWrite     => dec_MemWrite,
             o_MemWrite     => dec2_MemWrite,
             i_regWrite     => dec_regWrite,
             o_regWrite     => dec1_regWrite,
             i_JumpLink     => dec_JumpLink,
             o_JumpLink     => dec1_JumpLink,
             i_regDst       => dec1_RegDst,
             o_regDst       => dec2_RegDst,
	     i_halt         => dec1_halt,
	     o_halt         => dec2_halt);


  pipline4: registerMEM_WB
    port map(
             i_CLK          => iCLK,
             i_RST          => iRST,
             i_we           => '1',

             i_MemtoReg     => dec1_MemtoReg,
             i_regWrite     => dec1_regWrite,
             i_JumpLink     => dec1_JumpLink,
	     i_halt         => dec2_halt,
             i_PCplus4      => dec2_pc_plus4,
             i_DMEM         => s_DMemOut,
             i_ALU          => s_DMemAddr,
             i_reg_addr     => dec1_reg_addr,
             i_regDst       => dec2_RegDst,

             o_MemtoReg     => dec2_MemtoReg,
             o_regWrite     => dec2_regWrite,
             o_JumpLink     => dec2_JumpLink,
	     o_halt         => s_Halt,
             o_PCplus4      => dec3_pc_plus4,
             o_DMEM         => dec_DMemOut,
             o_ALU          => dec1_ALUOutput,
             o_regDst       => open,--s_RegDst,
             o_reg_addr     => dec2_reg_addr);


    oALUOut <= s_DMemAddr;                   --not sure whether to change
    s_RegWrAddr <= dec2_reg_addr;

    mux32_JAL_address : mux2to1_5       --MUX for choosing b/w  
	  port MAP(D0       => s_JAL_addr_MUX,
                   D1       => "11111",
                   SEL      => s_J_link,--s_J_link, dec2_JumpLink
                   MX_OUT   => dec0_reg_addr); --s_RegWrAddr

   mux32_JAL_data : mux2to1_32       --MUX for branch 
	  port MAP(D0       => s_MemToReg_old,
                   D1       => dec3_pc_plus4,--dec_pc_plus4,  
                   SEL      => dec2_JumpLink,--s_J_link,
                   MX_OUT   => s_RegWrData); 


  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

end structure;


---------------------------------------------------------------------------------------------
-- tal adoni 31987300
-- omri aviram 312192669
---------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.const_package.all;

ENTITY control IS
   PORT(
      clk_i,reset_tb		 : IN  STD_LOGIC;                               
      opcode_i               : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);            
      instruction_i          : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);           
      RegDst_ctrl_o          : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);            
      ALUSrc_ctrl_o          : OUT STD_LOGIC;                               
      MemtoReg_ctrl_o        : OUT STD_LOGIC;                               
      RegWrite_ctrl_o        : OUT STD_LOGIC;                               
      MemRead_ctrl_o         : OUT STD_LOGIC;                               
      MemWrite_ctrl_o        : OUT STD_LOGIC;                               
      Branch_ctrl_o          : OUT STD_LOGIC;                               
      BNEctrl_o              : OUT STD_LOGIC;                               
      BEQctrl_o              : OUT STD_LOGIC;                               
      jumpctrl_o             : OUT STD_LOGIC;                               
      ALUOp_ctrl_o           : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);            
      INTA                   : OUT STD_LOGIC;                               
      GIE                    : OUT STD_LOGIC;                               
      EPC_ctl_o              : OUT STD_LOGIC;                               
      flush_intr_o           : OUT STD_LOGIC;                               
      int_req_o              : IN  STD_LOGIC;                               
      INTR                   : IN  STD_LOGIC;                               
      type_address           : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);            
      type_en                : OUT STD_LOGIC;                               
      Key_reset_o            : OUT STD_LOGIC                                
   );
END control;

ARCHITECTURE behavior OF control IS
	signal rtype_sig: STD_LOGIC_VECTOR(1 DOWNTO 0); 
	signal lw_sig, sw_sig, beq_sig, itype_imm_sig, bne_sig, jmp_sig, jal_sig : STD_LOGIC;
	signal GIE_sig, pc_k1_sig, Flush_sig, TYPE_ctl_sig : STD_LOGIC;
	signal INTA_sig : STD_LOGIC := '1';
	signal i_opc, interrupt_process : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal reti_sig : STD_LOGIC;
	signal Key_reset_sig : STD_LOGIC;
BEGIN
   -- RETI detection (JR $k1)
   reti_sig <= '1' when
               instruction_i(31 downto 26) = "000000" and  -- R-type
               instruction_i(25 downto 21) = "11011" and   -- rs = $k1
               instruction_i(5 downto 0)   = "001000"      -- funct = JR
            else '0';

   -- Opcode-based decodes 
   rtype_sig(0)      <= '1' when ((opcode_i = R_TYPE_OPC) or (opcode_i = MUL_OPC)) else '0';
   rtype_sig(1)     <= '1' when (opcode_i = MUL_OPC) else '0';
   lw_sig         <= '1' when (opcode_i = LW_OPC)  else '0';
   sw_sig         <= '1' when (opcode_i = SW_OPC)  else '0';
   beq_sig        <= '1' when (opcode_i = BEQ_OPC) else '0';
   bne_sig        <= '1' when (opcode_i = BNE_OPC) else '0';
   jmp_sig        <= '1' when (opcode_i = JMP_OPC) else '0';
   jal_sig        <= '1' when (opcode_i = JAL_OPC) else '0';
   itype_imm_sig  <= '1' when ((opcode_i = ADDI_OPC)  or
                             (opcode_i = ORI_OPC)   or
                             (opcode_i = ANDI_OPC)  or
                             (opcode_i = LUI_OPC)   or
                             (opcode_i = ADDIU_OPC) or
                             (opcode_i = SLTI_OPC)  or
                             (opcode_i = XORI_OPC)) else '0';

	---------output assignments---------
	RegDst_ctrl_o(1)    <= '1' when (jal_sig = '1' or pc_k1_sig='1')  else '0';
	RegDst_ctrl_o(0)	<= '1' when (rtype_sig(0)='1' or rtype_sig(1)='1' or pc_k1_sig='1') else '0';
	BNEctrl_o        <= '1' when (bne_sig='1' and (pc_k1_sig)='0') else '0';
	BEQctrl_o        <= '1' when (beq_sig='1' and (pc_k1_sig)='0') else '0';
	jumpctrl_o       <= '1' when ((jmp_sig='1' or jal_sig='1') and (pc_k1_sig)='0') else '0';
	
	MemtoReg_ctrl_o  <= '1' when (lw_sig='1' and (pc_k1_sig)='0') else '0';
	RegWrite_ctrl_o  <= '1' when (rtype_sig(0) ='1' or rtype_sig(1)='1' or lw_sig='1' or itype_imm_sig='1' or jal_sig='1' or pc_k1_sig='1') else '0';
	MemWrite_ctrl_o  <= '1' when (sw_sig='1' and (pc_k1_sig)='0') else '0';
	MemRead_ctrl_o   <= '1' when (lw_sig='1' and (pc_k1_sig)='0') else '0';
	ALUSrc_ctrl_o    <= '1' when ((lw_sig='1' or sw_sig='1' or itype_imm_sig='1') and (pc_k1_sig)='0') else '0';
	
	Branch_ctrl_o    <= '1' when ((beq_sig='1' or bne_sig='1') and (pc_k1_sig)='0');

   ---new Interrupt signals---
   GIE              <= '1' when (GIE_sig='1' AND int_req_o='1') else '0'; 
   EPC_ctl_o        <= '1' when (GIE_sig='1') else '0';                 
   INTA             <= '1' when (INTA_sig) else '0';                
   flush_intr_o     <= Flush_sig;               
   type_en          <= TYPE_ctl_sig;            
   Key_reset_o      <= Key_reset_sig;           

   -- ALUOp 
   i_opc <= "000" when opcode_i = ADDI_OPC or opcode_i = ADDIU_OPC else
            "001" when opcode_i = ORI_OPC  else
            "010" when opcode_i = ANDI_OPC else
            "011" when opcode_i = XORI_OPC else
            "100" when opcode_i = LUI_OPC  else
            "101" when opcode_i = SLTI_OPC else
            "000";

   ALUOp_ctrl_o(0) <= beq_sig or bne_sig or i_opc(0);
   ALUOp_ctrl_o(1) <= rtype_sig(0) or i_opc(1);
   ALUOp_ctrl_o(2) <= rtype_sig(1) or i_opc(2);

   ----------------------------------------------------------------------------
   -- Interrupt control state machine
   ----------------------------------------------------------------------------
   PROCESS (clk_i)
   BEGIN
      IF rising_edge(clk_i) THEN
         IF reset_tb = '1' THEN              
            GIE_sig        <= '1';
            INTA_sig       <= '1';
            TYPE_ctl_sig   <= '0';
            pc_k1_sig      <= '0';
            Flush_sig      <= '0';
            interrupt_process  <= (OTHERS => '0');
            Key_reset_sig  <= '0';
         ELSIF INTR = '1' AND interrupt_process = "000" THEN
            pc_k1_sig         <= '1';
            Flush_sig         <= '1';
            interrupt_process(0)  <= '1';
         ELSIF interrupt_process = "001" THEN
			-- flush 		<= '1';
            GIE_sig           <= '0';
            pc_k1_sig         <= '0';
            interrupt_process(1)  <= '1';
         ELSIF interrupt_process = "011" THEN
			-- flush 		<= '1';
            INTA_sig          <= '0';
            TYPE_ctl_sig      <= '1'; -- type is requested from Interrupt controller
            interrupt_process(2)  <= '1';
         ELSIF interrupt_process = "111" THEN
            IF type_address = X"00" THEN --RESET
               GIE_sig        <= '1';
               Key_reset_sig  <= '1';
            END IF;
            INTA_sig          <= '1';
            Flush_sig         <= '0';
            TYPE_ctl_sig      <= '0';
            interrupt_process     <= (OTHERS => '0');
         ELSIF Key_reset_sig = '1' THEN
            Key_reset_sig     <= '0';
         ELSIF reti_sig = '1' THEN --return from ISR
            GIE_sig           <= '1';
         END IF;
      END IF;
   END PROCESS;

END behavior;

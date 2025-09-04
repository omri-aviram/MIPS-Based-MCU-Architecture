---------------------------------------------------------------------------------------------
-- tal adoni 31987300
-- omri aviram 312192669
---------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY HazardAndForwarding IS
  PORT(
    ------------------------ Forwarding Unit  -------------------------
    Rs_Reg_ID_i, Rt_Reg_ID_i                 : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
    Rs_Reg_EX_i, Rt_Reg_EX_i                 : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
    write_reg_addr_EX_i                      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
    write_reg_addr_DM_i                      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
    write_reg_addr_WB_i                      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0); 
    RegWrite_EX_i, RegWrite_DM_i, RegWrite_WB_i
                                             : IN  STD_LOGIC;                    
    ALU_A_MUX_o, ALU_B_MUX_o                 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); 

    ------------------------ Hazard Unit  -----------------------------
    MemtoReg_EX_i, MemtoReg_DM_i             : IN  STD_LOGIC;                    
    BEQ_ID_i, BNE_ID_i                        : IN  STD_LOGIC;                   

    ------------------------ Stalls/Flush -----------------------
    Stall_IF                                  : OUT STD_LOGIC;                   
    Stall_ID                                  : OUT STD_LOGIC;                   
    Flush_EX                                  : OUT STD_LOGIC;                   

    ------------------------ Branch comparator fwd --------------
    ForwardA_Branch                           : OUT STD_LOGIC;                   
    ForwardB_Branch                           : OUT STD_LOGIC                    
  );
END HazardAndForwarding;

ARCHITECTURE behavior OF HazardAndForwarding IS
  SIGNAL LwStall, BranchStall : BOOLEAN;
BEGIN
  ----------------------------- Stall and Flush  -----------------------------
  LwStall      <= (MemtoReg_EX_i = '1') AND ((Rt_Reg_EX_i = Rs_Reg_ID_i) OR (Rt_Reg_EX_i = Rt_Reg_ID_i));

  BranchStall  <= ((BEQ_ID_i = '1' OR BNE_ID_i = '1') AND (RegWrite_EX_i = '1') AND ((write_reg_addr_EX_i = Rs_Reg_ID_i) OR (write_reg_addr_EX_i = Rt_Reg_ID_i))) --writing to Reg
                  OR ((BEQ_ID_i = '1') AND (MemtoReg_DM_i = '1') AND ((write_reg_addr_DM_i = Rs_Reg_ID_i) OR (write_reg_addr_DM_i = Rt_Reg_ID_i))); -- Writing from mem to reg

  Stall_IF <= '1' WHEN (LwStall OR BranchStall) ELSE '0';
  Stall_ID <= '1' WHEN (LwStall OR BranchStall) ELSE '0';
  Flush_EX <= '1' WHEN (LwStall OR BranchStall) ELSE '0';

  ----------------------------- ALU result forwarding -----------------------
  -- A source Rs forward
  ALU_A_MUX_o <= "10" WHEN (RegWrite_DM_i = '1' AND write_reg_addr_DM_i /= "00000" AND write_reg_addr_DM_i = Rs_Reg_EX_i) --forward from DM
            ELSE  "01" WHEN (RegWrite_WB_i = '1' AND write_reg_addr_WB_i /= "00000" AND NOT (RegWrite_DM_i = '1' AND write_reg_addr_DM_i /= "00000" AND write_reg_addr_DM_i = Rs_Reg_EX_i) AND write_reg_addr_WB_i = Rs_Reg_EX_i) --forward from WB
            ELSE  "00";

  -- B source Rt forward
  ALU_B_MUX_o <= "10" WHEN (RegWrite_DM_i = '1' AND write_reg_addr_DM_i /= "00000" AND write_reg_addr_DM_i = Rt_Reg_EX_i) --forward from DM
				ELSE  "01" WHEN (RegWrite_WB_i = '1' AND write_reg_addr_WB_i /= "00000" AND NOT (RegWrite_DM_i = '1' AND write_reg_addr_DM_i /= "00000" AND write_reg_addr_DM_i = Rt_Reg_EX_i) AND write_reg_addr_WB_i = Rt_Reg_EX_i) --forward from WB
				ELSE  "00";

  ----------------------------- Branch comparator forwarding ----------------
  ForwardA_Branch <= '1' WHEN (Rs_Reg_ID_i /= "00000" AND Rs_Reg_ID_i = write_reg_addr_DM_i AND RegWrite_DM_i = '1')
                     ELSE '0';

  ForwardB_Branch <= '1' WHEN (Rt_Reg_ID_i /= "00000" AND Rt_Reg_ID_i = write_reg_addr_DM_i AND RegWrite_DM_i = '1')
                     ELSE '0';

END behavior;

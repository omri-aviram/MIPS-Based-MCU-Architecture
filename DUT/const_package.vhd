---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;


package const_package is
---------------------------------------------------------
--	IDECODE constants
---------------------------------------------------------
	constant R_TYPE_OPC : 	STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
	constant LW_OPC : 		STD_LOGIC_VECTOR(5 DOWNTO 0) := "100011";
	constant SW_OPC : 		STD_LOGIC_VECTOR(5 DOWNTO 0) := "101011";
	constant BEQ_OPC : 		STD_LOGIC_VECTOR(5 DOWNTO 0) := "000100";
	constant ANDI_OPC : 	STD_LOGIC_VECTOR(5 DOWNTO 0) := "001100";
	constant ORI_OPC : 		STD_LOGIC_VECTOR(5 DOWNTO 0) := "001101";
	constant ADDI_OPC : 	STD_LOGIC_VECTOR(5 DOWNTO 0) := "001000";
	
	
	----------------------------------------- added -----------------
	constant MUL_OPC : 	    STD_LOGIC_VECTOR(5 DOWNTO 0) := "011100";
	constant XORI_OPC : 	STD_LOGIC_VECTOR(5 DOWNTO 0) := "001110";
	constant LUI_OPC : 	    STD_LOGIC_VECTOR(5 DOWNTO 0) := "001111";
	constant ADDIU_OPC : 	STD_LOGIC_VECTOR(5 DOWNTO 0) := "001001";
	constant SLTI_OPC : 	STD_LOGIC_VECTOR(5 DOWNTO 0) := "001010";
	constant BNE_OPC : 		STD_LOGIC_VECTOR(5 DOWNTO 0) := "000101";
	constant JMP_OPC : 		STD_LOGIC_VECTOR(5 DOWNTO 0) := "000010";
    constant JAL_OPC : 		STD_LOGIC_VECTOR(5 DOWNTO 0) := "000011";




--------------------------------  OUR  ---------------------------	
	constant JUMP_OPC   : 		STD_LOGIC_VECTOR(5 DOWNTO 0) := "000010";
------------------ for pseudo instructions  ----------------------
	
	constant ADDUI_OPC  : 		STD_LOGIC_VECTOR(5 DOWNTO 0) := "001001"; --for li
	
--------------------------------------------------------
------------------ Final Project Addresses ----------------------

	-- GPIO without interrupt capability
	constant ADDR_PORT_LEDR   : std_logic_vector(11 downto 0) := x"800";
	constant ADDR_PORT_HEX0   : std_logic_vector(11 downto 0) := x"804";
	constant ADDR_PORT_HEX1   : std_logic_vector(11 downto 0) := x"805";
	constant ADDR_PORT_HEX2   : std_logic_vector(11 downto 0) := x"808";
	constant ADDR_PORT_HEX3   : std_logic_vector(11 downto 0) := x"809";
	constant ADDR_PORT_HEX4   : std_logic_vector(11 downto 0) := x"80C";
	constant ADDR_PORT_HEX5   : std_logic_vector(11 downto 0) := x"80D";
	constant ADDR_PORT_SW     : std_logic_vector(11 downto 0) := x"810";

	-- GPIO with interrupt capability
	constant ADDR_PORT_KEY    : std_logic_vector(11 downto 0) := x"814";
												  
	-- UART                                       
	constant ADDR_UCTL        : std_logic_vector(11 downto 0) := x"818";
	constant ADDR_RXBF        : std_logic_vector(11 downto 0) := x"819";
	constant ADDR_TXBF        : std_logic_vector(11 downto 0) := x"81A";
												  
	-- Basic Timer                                
	constant ADDR_BTCTL       : std_logic_vector(11 downto 0) := x"81C";
	constant ADDR_BTCNT       : std_logic_vector(11 downto 0) := x"820";
	constant ADDR_BTCCR0      : std_logic_vector(11 downto 0) := x"824";
	constant ADDR_BTCCR1      : std_logic_vector(11 downto 0) := x"828";
												  
	-- FIR filter                                 
	constant ADDR_FIRCTL      : std_logic_vector(11 downto 0) := x"82C";
	constant ADDR_FIRIN       : std_logic_vector(11 downto 0) := x"830";
	constant ADDR_FIROUT      : std_logic_vector(11 downto 0) := x"834";
	constant ADDR_COEF3_0     : std_logic_vector(11 downto 0) := x"838";
	constant ADDR_COEF7_4     : std_logic_vector(11 downto 0) := x"83C";
												  
	-- Interrupt Registers                        
	constant ADDR_IE          : std_logic_vector(11 downto 0) := x"840";
	constant ADDR_IFG         : std_logic_vector(11 downto 0) := x"841";
	constant ADDR_TYPE        : std_logic_vector(11 downto 0) := x"842";
	
	

end const_package;


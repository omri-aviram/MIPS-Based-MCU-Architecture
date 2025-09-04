---------------------------------------------------------------------------------------------
-- tal adoni 31987300
-- omri aviram 312192669
---------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;  -- Use numeric_std for modern arithmetic and type conversions
USE work.aux_package.all;  -- Assuming aux_package contains necessary utilities
---------------------------------------------------------
ENTITY Shifter IS
  GENERIC (n : INTEGER := 32; k : INTEGER := 5);
  PORT (
    Y_in   : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    X_in   : IN STD_LOGIC_VECTOR (k-1 DOWNTO 0);
    op           : IN STD_LOGIC_VECTOR (k DOWNTO 0); -- 000000 => shift left, 000010 => shift right, else => invalid (out=0)
    result       : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0)
  );
END Shifter;

---------------------------------------------------------

ARCHITECTURE data_calc OF Shifter IS

subtype Line_n IS std_logic_vector (n-1 DOWNTO 0);
type    matrix_k_n IS ARRAY (k-1 DOWNTO 0) OF Line_n;
signal Result_Left , Result_Right              : matrix_k_n ;
signal Carry_vec_right, Carry_vec_left		   : STD_LOGIC_VECTOR(k-1 DOWNTO 0 ); 
signal Zero_vec 		 					   : STD_LOGIC_VECTOR(n-1 DOWNTO 0 ); 
signal result_temp 		 					   : STD_LOGIC_VECTOR(n-1 DOWNTO 0 ); 



BEGIN

Zero_vec <= (others =>'0');
	
----------------   left shift Logic	------------------

Result_Left(0)(0) <= Y_in(0) when X_in(0) = '0' else '0' ;
Result_Left(0)(n-1 DOWNTO 1) <= Y_in(n-1 DOWNTO 1) when X_in(0) = '0' else Y_in(n-2 DOWNTO 0);
Carry_vec_left(0)   <= '0' when X_in(0) = '0' else Y_in(n-1) ;

left_shift : for stage in 1 to k-1 generate 
			Result_Left(stage)(2**stage-1 DOWNTO 0) <= Result_Left(stage-1)(2**stage-1 DOWNTO 0) when X_in(stage) = '0' else (others =>'0') ;
			Result_Left(stage)(n-1 DOWNTO 2**stage) <= Result_Left(stage-1)(n-1 DOWNTO 2**stage) when X_in(stage) = '0' else Result_Left(stage-1)(n-1-2**stage DOWNTO 0);
			Carry_vec_left(stage) <= Carry_vec_left(stage-1) when X_in(stage) = '0' else Result_Left(stage-1)(n-2**stage);
end generate;

----------------   right shift Logic	------------------

Result_Right(0)(n-1) <= Y_in(n-1) when X_in(0) = '0' else '0' ;
Result_Right(0)(n-2 DOWNTO 0) <= Y_in(n-2 DOWNTO 0) when X_in(0) = '0' else Y_in(n-1 DOWNTO 1);
Carry_vec_right(0)   <= '0' when X_in(0) = '0' else Y_in(0) ;



Right_shift : for stage in 1 to k-1 generate 
			Result_Right(stage)(n-1 DOWNTO n-2**stage) <= Result_Right(stage-1)(n-1 DOWNTO n-2**stage) when X_in(stage) = '0' 
														 else (others =>'0') ;
														 
			Result_Right(stage)(n-1-2**stage DOWNTO 0) <= Result_Right(stage-1)(n-1-2**stage DOWNTO 0) when X_in(stage) = '0' 
														 else Result_Right(stage-1)(n-1 DOWNTO 2**stage);
														 
			Carry_vec_right(stage) <= Carry_vec_right(stage-1) when X_in(stage) = '0' else Result_Right(stage-1)(2**(stage)-1);
end generate;

	with op select 
				result_temp <= Result_Left(k-1)    when "000000" ,
						  Result_Right(k-1)   when "000010" ,
						  (others =>'0') when others ;	
	
						   

result  <= result_temp;

END data_calc;



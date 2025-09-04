library ieee;
use ieee.std_logic_1164.all;

package FIR_package is

--    ------------------------------------------------------------------------
--    FIR_package FOR VECTOR TYPES
--    ------------------------------------------------------------------------

    -- Array of W-bit vectors 
    type vector_array_w is array (natural range <>) of std_logic_vector;

    -- Array of (W+q)-bit vectors 
    type vector_array_wq is array (natural range <>) of std_logic_vector;

    -- Array of q-bit vectors 
    type vector_array_q is array (natural range <>) of std_logic_vector;

end FIR_package;


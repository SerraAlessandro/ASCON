library ieee;
use ieee.std_logic_1164.all;
 
package ascon_pkg is

	subtype w8_t is std_ulogic_vector(7 downto 0);
	type w8_array_t is array(natural range <>) of w8_t;
	subtype w64_t is std_ulogic_vector(63 downto 0);
	type w64_array_t is array(natural range <>) of w64_t;
	subtype ascon_state_t is w64_array_t(0 to 4);

	constant ascon_const_c: w8_array_t(0 to 15) := (
    x"3c", x"2d", x"1e", x"0f", x"f0", x"e1", x"d2", x"c3", x"b4", x"a5", x"96", x"87", x"78", x"69", x"5a", x"4b"
	);

	function ascon_pc_f(state: ascon_state_t; rnd: natural range 0 to 16; i: natural range 0 to 15) return ascon_state_t;
	function ascon_ps_f(state: ascon_state_t) return ascon_state_t;
	function ascon_pl_f(state: ascon_state_t) return ascon_state_t;
	function ascon_p_f(state: ascon_state_t; rnd: natural range 0 to 16; i: natural range 0 to 15) return ascon_state_t;
	function ascon_f_full(state: ascon_state_t; ad: std_ulogic_vector; l_ad: positive; pl: std_ulogic_vector; l_pl: positive) return std_ulogic_vector;
	function reverse_byte( vec : std_ulogic_vector ) return std_ulogic_vector;
	
end package ascon_pkg;

package body ascon_pkg is 

	function reverse_byte( vec : std_ulogic_vector ) return std_ulogic_vector is
        	variable res : std_ulogic_vector(vec'length - 1 downto 0);
        	constant n_bytes  : integer := vec'length/8;
    		begin

        		-- Check that vector length is actually byte aligned.
        		assert (vec'length mod 8 = 0)
            		report "Vector size must be in multiple of Bytes!" severity failure;

        		-- Loop over every byte of vec and reorder it in res.
        		for i in 0 to (n_bytes - 1) loop
            			res(8*(i+1) - 1 downto 8*i) := vec(8*(n_bytes - i) - 1 downto 8*(n_bytes - i - 1));
        		end loop;

        	return res;
    	end function reverse_byte;

	function ascon_f_full (state: ascon_state_t; ad: std_ulogic_vector; l_ad: positive; pl: std_ulogic_vector; l_pl: positive) return std_ulogic_vector is
		variable tmp1: ascon_state_t := state;
		variable tmp2: ascon_state_t;
		variable ad_tmp, pl_tmp: std_ulogic_vector(127 downto 0);
		variable ad_words,pl_words: natural := 0;
		variable T: std_ulogic_vector(127 downto 0);
	
		begin

-- ******************** INITIALIZATION ********************
			
			tmp1(1) := reverse_byte(tmp1(1));
			tmp1(2) := reverse_byte(tmp1(2));
			tmp1(3) := reverse_byte(tmp1(3));
			tmp1(4) := reverse_byte(tmp1(4));
			init: for j in 0 to 11 loop
				tmp1 := ascon_p_f(tmp1,12,j);
			end loop init;

			tmp1(3) := tmp1(3) xor reverse_byte(state(1));
			tmp1(4) := tmp1(4) xor reverse_byte(state(2));
			
-- ******************** ASSOCIATED DATA ********************	
		
			while ad_words /= (l_ad-1) loop
				
				ad_tmp := ad((ad'high - 128*ad_words) downto (ad'high - 128*(ad_words+1)+1));
				ad_tmp := reverse_byte(ad_tmp);
				
				tmp1(0) := tmp1(0) xor ad_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor ad_tmp(127 downto 64);
				ad_processing: for j in 0 to 7 loop

					tmp1 := ascon_p_f(tmp1,8,j);

				end loop ad_processing;
				ad_words := ad_words + 1;
			end loop;

			if (ad'high +1 -(128*(ad_words+1)) = 0) then
				ad_tmp := ad((ad'high - 128*(ad_words)) downto 0);
				ad_tmp := reverse_byte(ad_tmp);
				tmp1(0) := tmp1(0) xor ad_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor ad_tmp(127 downto 64);

				ad_processing_last_full: for j in 0 to 7 loop
					tmp1 := ascon_p_f(tmp1,8,j);
				end loop ad_processing_last_full;
				
				ad_tmp := x"00000000000000000000000000000000";
				ad_tmp(127 downto 120) := "00000001";
				
			else
				ad_tmp := x"00000000000000000000000000000000";
				ad_tmp(127 downto 127-(ad'high-(128*ad_words))-8) :=  ad((ad'high-(128*ad_words)) downto 0) & "00000001";
			end if;
			ad_tmp := reverse_byte(ad_tmp);
			tmp1(0) := tmp1(0) xor ad_tmp(63 downto 0);
			tmp1(1) := tmp1(1) xor ad_tmp(127 downto 64);
			ad_processing_last: for j in 0 to 7 loop
				tmp1 := ascon_p_f(tmp1,8,j);
			end loop ad_processing_last;
	
			tmp1(4)(63) := tmp1(4)(63) xor '1';

-- ******************** PLAINTEXT ********************

			while (pl_words /= (l_pl - 1)) loop
				
				pl_tmp := pl((pl'high - 128*pl_words) downto (pl'high - 128*(pl_words+1)+1));
				pl_tmp := reverse_byte(pl_tmp);
				
				tmp1(0) := tmp1(0) xor pl_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor pl_tmp(127 downto 64);

				pl_processing: for j in 0 to 7 loop

					tmp1 := ascon_p_f(tmp1,8,j);

				end loop pl_processing;
				pl_words := pl_words + 1;
			end loop;

			if (pl'high-(128*(pl_words+1) + 1) = 0) then
				pl_tmp := pl((pl'high - 128*(pl_words)) downto 0);
				pl_tmp := reverse_byte(pl_tmp);
				tmp1(0) := tmp1(0) xor pl_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor pl_tmp(127 downto 64);

				pl_processing_last_full: for j in 0 to 7 loop
					tmp1 := ascon_p_f(tmp1,8,j);
				end loop pl_processing_last_full;
				
				pl_tmp := x"00000000000000000000000000000000";
				pl_tmp(127 downto 120) := "00000001";
				
			else
				pl_tmp := x"00000000000000000000000000000000";
				pl_tmp(127 downto 127-(pl'high-(128*pl_words))-8) :=  pl((pl'high-(128*pl_words)) downto 0) & "00000001";
			end if;
			pl_tmp := reverse_byte(pl_tmp);
			tmp1(0) := tmp1(0) xor pl_tmp(63 downto 0);
			tmp1(1) := tmp1(1) xor pl_tmp(127 downto 64);

-- ******************** FINALIZATION ********************
			tmp1(2) := tmp1(2) xor reverse_byte(state(1));
			tmp1(3) := tmp1(3) xor reverse_byte(state(2));

			fin: for j in 0 to 11 loop
				tmp1 := ascon_p_f(tmp1,12,j);
			end loop fin;

			T(63 downto 0) := tmp1(3) xor reverse_byte(state(1));
			T(127 downto 64) := tmp1(4) xor reverse_byte(state(2));

			T := reverse_byte(T);
			

			
		return T;
	end function ascon_f_full;

	function ascon_p_f (state: ascon_state_t; rnd: natural range 0 to 16; i: natural range 0 to 15) return ascon_state_t is
		variable tmp1: ascon_state_t := state;
		begin

			tmp1 := ascon_pc_f(tmp1, rnd, i);
			tmp1 := ascon_ps_f(tmp1);
			tmp1 := ascon_pl_f(tmp1);

		return tmp1;
	end function ascon_p_f;

	function ascon_pc_f(state: ascon_state_t; rnd: natural range 0 to 16; i: natural range 0 to 15) return ascon_state_t is
		variable tmp: ascon_state_t := state;
		begin
			assert i < rnd severity failure;
			tmp(2)(7 downto 0) := state(2)(7 downto 0) xor ascon_const_c(16 - rnd + i);
		return tmp;
	end function ascon_pc_f;
	
	
	function ascon_ps_f(state: ascon_state_t) return ascon_state_t is
		variable x0,x1,x2,x3,x4: w64_t;
		variable t0,t1,t2: w64_t;
		variable tmp: ascon_state_t;
		begin
			x0 := state(0);
			x1 := state(1);
			x2 := state(2);
			x3 := state(3);
			x4 := state(4);
			
			x0 := x0 XOR x4;
         		x2 := x2 XOR x1;
			x4 := x4 XOR x3;
    
			t0 := x0;
			t1 := x1;
			x0 := x0 XOR (NOT x1 AND x2);
			x1 := x1 XOR (NOT x2 AND x3);
			x2 := x2 XOR (NOT x3 AND x4);
			x3 := x3 XOR (NOT x4 AND t0);
			x4 := x4 XOR (NOT t0 AND t1);
    
			x1 := x1 XOR x0;
			x3 := x3 XOR x2;
			x0 := x0 XOR x4;
			x2 := NOT x2;
			
			tmp(0) := x0;
			tmp(1) := x1;
			tmp(2) := x2;
			tmp(3) := x3;
			tmp(4) := x4;
			
		return tmp;
	end function ascon_ps_f;
	
	function ascon_pl_f(state: ascon_state_t) return ascon_state_t is
		variable x0,x1,x2,x3,x4: w64_t;
		variable tmp: ascon_state_t;
		begin
			x0 := state(0);
			x1 := state(1);
			x2 := state(2);
			x3 := state(3);
			x4 := state(4);
			
			x0 := x0 XOR (x0(18 DOWNTO 0) & x0(63 DOWNTO 19)) XOR (x0(27 DOWNTO 0) & x0(63 DOWNTO 28));
         		x1 := x1 XOR (x1(60 DOWNTO 0) & x1(63 DOWNTO 61)) XOR (x1(38 DOWNTO 0) & x1(63 DOWNTO 39));
			x2 := x2 XOR (x2(0 DOWNTO 0) & x2(63 DOWNTO 1)) XOR (x2(5 DOWNTO 0) & x2(63 DOWNTO 6));
			x3 := x3 XOR (x3(9 DOWNTO 0) & x3(63 DOWNTO 10)) XOR (x3(16 DOWNTO 0) & x3(63 DOWNTO 17));
			x4 := x4 XOR (x4(6 DOWNTO 0) & x4(63 DOWNTO 7)) XOR (x4(40 DOWNTO 0) & x4(63 DOWNTO 41));
			
			tmp(0) := x0;
			tmp(1) := x1;
			tmp(2) := x2;
			tmp(3) := x3;
			tmp(4) := x4;
		return tmp;
	end function ascon_pl_f;

end package body ascon_pkg;
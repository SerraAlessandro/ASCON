library ieee;
use ieee.std_logic_1164.all;
 
package ascon_pkg is

	subtype w8_t is std_ulogic_vector(0 to 7);
	type w8_array_t is array(natural range <>) of w8_t;
	subtype w64_t is std_ulogic_vector(0 to 63);
	type w64_array_t is array(natural range <>) of w64_t;
	subtype ascon_state_t is w64_array_t(0 to 4);

	constant ascon_const_c: w8_array_t(0 to 15) := (
    x"3c", x"2d", x"1e", x"0f", x"f0", x"e1", x"d2", x"c3", x"b4", x"a5", x"96", x"87", x"78", x"69", x"5a", x"4b"
	);

	function ascon_pc_f(state: ascon_state_t; rnd: natural range 0 to 16; i: natural range 0 to 15) return ascon_state_t;
	function ascon_ps_f(state: ascon_state_t) return ascon_state_t;
	function ascon_pl_f(state: ascon_state_t) return ascon_state_t;
	function ascon_p_f(state: ascon_state_t; rnd: natural range 0 to 16; i: natural range 0 to 15) return ascon_state_t;
	function ascon_enc_f(state: ascon_state_t; ad: std_ulogic_vector;  pl: std_ulogic_vector) return std_ulogic_vector;
	function reverse_byte( vec : std_ulogic_vector ) return std_ulogic_vector;
	
end package ascon_pkg;

package body ascon_pkg is 

	function reverse_byte( vec : std_ulogic_vector ) return std_ulogic_vector is
        	--variable res : std_ulogic_vector(vec'length - 1 downto 0);
		variable res : std_ulogic_vector(0 to vec'length-1);
        	constant n_bytes  : integer := vec'length/8;
    		begin

        		-- Check that vector length is actually byte aligned.
        		assert (vec'length mod 8 = 0)
            		report "Vector size must be in multiple of Bytes!" severity failure;

        		-- Loop over every byte of vec and reorder it in res.
        		for i in 0 to (n_bytes - 1) loop
            			--res(8*(i+1) - 1 downto 8*i) := vec(8*(n_bytes - i) - 1 downto 8*(n_bytes - i - 1));
				res(8*i to (8*(i+1)) -1) := vec(8*(n_bytes-1-i) to (8*(n_bytes-i))-1);
        		end loop;

        	return res;
    	end function reverse_byte;

	function ascon_enc_f (state: ascon_state_t; ad: std_ulogic_vector; pl: std_ulogic_vector) return std_ulogic_vector is
		variable tmp1: ascon_state_t := state;
		variable tmp2: ascon_state_t;
		variable ad_tmp, pl_tmp: std_ulogic_vector(0 to 127);
		variable ad_words,pl_words: natural := 0;
		variable T: std_ulogic_vector(0 to 127);
	
		begin
			
			

-- ******************** INITIALIZATION ********************
			
			
		
			init: for j in 0 to 11 loop
				tmp1 := ascon_p_f(tmp1,12,j);
			end loop init;

			tmp1(3) := tmp1(3) xor state(1);
			tmp1(4) := tmp1(4) xor state(2);

			
			
-- ******************** ASSOCIATED DATA ********************	
		
			while (ad'length - 128*ad_words > 128) loop
				
				ad_tmp := ad(ad'length-(128*(ad_words+1)) to ad'length-(128*ad_words)-1);
				tmp1(0) := tmp1(0) xor ad_tmp(64 to 127);
				tmp1(1) := tmp1(1) xor ad_tmp(0 to 63);
				
				ad_processing: for j in 0 to 7 loop

					tmp1 := ascon_p_f(tmp1,8,j);

				end loop ad_processing;
				ad_words := ad_words + 1;
			end loop;

			if (ad'high +1 -(128*(ad_words+1)) = 0) then
				ad_tmp := ad(ad'length-(128*(ad_words+1)) to ad'length-(128*ad_words)-1);
				
				tmp1(0) := tmp1(0) xor ad_tmp(64 to 127);
				tmp1(1) := tmp1(1) xor ad_tmp(0 to 63);

				ad_processing_last_full: for j in 0 to 7 loop
					tmp1 := ascon_p_f(tmp1,8,j);
				end loop ad_processing_last_full;
				
				ad_tmp := x"00000000000000000000000000000001";
				
			else
				ad_tmp := x"00000000000000000000000000000000";
				ad_tmp(128-(ad'length-(128*ad_words)+8) to 127) := "00000001" & ad(0 to ad'length-(128*ad_words)-1) ;
				
			end if;

			
			tmp1(0) := tmp1(0) xor ad_tmp(64 to 127);
			tmp1(1) := tmp1(1) xor ad_tmp(0 to 63);
			ad_processing_last: for j in 0 to 7 loop
				tmp1 := ascon_p_f(tmp1,8,j);
			end loop ad_processing_last;
	
			tmp1(4)(0) := tmp1(4)(0) xor '1';

			
		

---- ******************** PLAINTEXT ********************

			while (pl'length - 128*pl_words > 128) loop
				pl_tmp := pl(pl'length-(128*(pl_words+1)) to pl'length-(128*pl_words)-1);
				tmp1(0) := tmp1(0) xor pl_tmp(64 to 127);
				tmp1(1) := tmp1(1) xor pl_tmp(0 to 63);
				
				pl_processing: for j in 0 to 7 loop

					tmp1 := ascon_p_f(tmp1,8,j);

				end loop pl_processing;
				pl_words := pl_words + 1;
			end loop;

			if (pl'high +1 -(128*(pl_words+1)) = 0) then
				pl_tmp := pl(pl'length-(128*(pl_words+1)) to pl'length-(128*pl_words)-1);
				
				tmp1(0) := tmp1(0) xor pl_tmp(64 to 127);
				tmp1(1) := tmp1(1) xor pl_tmp(0 to 63);

				pl_processing_last_full: for j in 0 to 7 loop
					tmp1 := ascon_p_f(tmp1,8,j);
				end loop pl_processing_last_full;
				
				pl_tmp := x"00000000000000000000000000000001";
			
			else
				pl_tmp := x"00000000000000000000000000000000";
				pl_tmp(128-(pl'length-(128*pl_words)+8) to 127) := "00000001" & pl(0 to pl'length-(128*pl_words)-1) ;
			end if;

			tmp1(0) := tmp1(0) xor pl_tmp(64 to 127);
			tmp1(1) := tmp1(1) xor pl_tmp(0 to 63);

			

---- ******************** FINALIZATION ********************

			tmp1(2) := tmp1(2) xor state(1);
			tmp1(3) := tmp1(3) xor state(2);

			fin: for j in 0 to 11 loop
				tmp1 := ascon_p_f(tmp1,12,j);
			end loop fin;

			T(64 to 127) := tmp1(3) xor state(1);
			T(0 to 63) := tmp1(4) xor state(2);

			T := reverse_byte(T);
			
		return T;
	end function ascon_enc_f;

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
			tmp(2)(56 to 63) := state(2)(56 to 63) xor ascon_const_c(16 - rnd + i);
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
			
			x0 := x0 XOR (x0(45 to 63) & x0(0 to 44)) XOR (x0(36 to 63) & x0(0 to 35));
         		x1 := x1 XOR (x1(3 to 63) & x1(0 to 2)) XOR (x1(25 to 63) & x1(0 to 24));
			x2 := x2 XOR (x2(63 to 63) & x2(0 to 62)) XOR (x2(58 to 63) & x2(0 to 57));
			x3 := x3 XOR (x3(54 to 63) & x3(0 to 53)) XOR (x3(47 to 63) & x3(0 to 46));
			x4 := x4 XOR (x4(57 to 63) & x4(0 to 56)) XOR (x4(23 to 63) & x4(0 to 22));
			
			tmp(0) := x0;
			tmp(1) := x1;
			tmp(2) := x2;
			tmp(3) := x3;
			tmp(4) := x4;
		return tmp;
	end function ascon_pl_f;

end package body ascon_pkg;
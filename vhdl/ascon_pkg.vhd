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

	subtype w128_t is std_ulogic_vector(127 downto 0);
	type ascon_enc_out_t is record
	c: std_ulogic_vector; -- ciphertext
	t: w128_t; -- tag
	end record;


	function ascon_pc_f(state: ascon_state_t; rnd: natural range 0 to 16; i: natural range 0 to 15) return ascon_state_t;
	function ascon_ps_f(state: ascon_state_t) return ascon_state_t;
	function ascon_pl_f(state: ascon_state_t) return ascon_state_t;
	function ascon_p_f(state: ascon_state_t; rnd: natural range 0 to 16; i: natural range 0 to 15) return ascon_state_t;
	function ascon_enc_f (key: std_ulogic_vector; nonce: std_ulogic_vector; ad: std_ulogic_vector; pl: std_ulogic_vector) return ascon_enc_out_t;
--	function ascon_enc_f (key: std_ulogic_vector; nonce: std_ulogic_vector; ad: std_ulogic_vector; pl: std_ulogic_vector) return ascon_state_t;
	function reverse_byte( vec : std_ulogic_vector ) return std_ulogic_vector;
	
end package ascon_pkg;

package body ascon_pkg is 

	function reverse_byte( vec : std_ulogic_vector ) return std_ulogic_vector is
        	variable res : std_ulogic_vector(vec'length - 1 downto 0);
		--variable res : std_ulogic_vector(0 to vec'length-1);
        	constant n_bytes  : integer := vec'length/8;
    		begin

        		-- Check that vector length is actually byte aligned.
        		assert (vec'length mod 8 = 0)
            		report "Vector size must be in multiple of Bytes!" severity failure;

        		-- Loop over every byte of vec and reorder it in res.
        		for i in 0 to (n_bytes - 1) loop
            			res(8*(i+1) - 1 downto 8*i) := vec(8*(n_bytes - i) - 1 downto 8*(n_bytes - i - 1));
				--res(8*i to (8*(i+1)) -1) := vec(8*(n_bytes-1-i) to (8*(n_bytes-i))-1);
        		end loop;

        	return res;
    	end function reverse_byte;

	function ascon_enc_f (key: std_ulogic_vector; nonce: std_ulogic_vector; ad: std_ulogic_vector; pl: std_ulogic_vector) return ascon_enc_out_t is
--	function ascon_enc_f (key: std_ulogic_vector; nonce: std_ulogic_vector; ad: std_ulogic_vector; pl: std_ulogic_vector) return ascon_state_t is

		constant a_len: natural := ad'length;
		constant a_local: std_ulogic_vector(a_len - 1 downto 0) := ad;
		constant p_len: natural := pl'length;
		constant p_local: std_ulogic_vector(p_len - 1 downto 0) := pl;
		constant k_len: natural := key'length;
		constant k_local: std_ulogic_vector(k_len - 1 downto 0) := key;
		constant n_len: natural := nonce'length;
		constant n_local: std_ulogic_vector(n_len - 1 downto 0) := nonce;
		constant iv: std_ulogic_vector(63 downto 0) := x"00001000808c0001";

		variable state: ascon_state_t;
		variable tmp1: ascon_state_t;
		variable k,n: w128_t;
		variable tmp12: w128_t;
		variable ad_tmp, pl_tmp: w128_t;
		variable ad_words,pl_words: natural := 0;
		variable T: w128_t;
		variable res: ascon_enc_out_t(c(p_len - 1 downto 0)) := (c => (others => '0'),t => (others => '0'));

		begin
			
			state(0) := iv;
			state(1) := k_local(63 downto 0);
			state(2) := k_local(127 downto 64);
			state(3) := n_local(63 downto 0);
			state(4) := n_local(127 downto 64);
			tmp1 := state;
			
-- ******************** INITIALIZATION ********************
			
			init: for j in 0 to 11 loop
				tmp1 := ascon_p_f(tmp1,12,j);
			end loop init;

			tmp1(3) := tmp1(3) xor state(1);
			tmp1(4) := tmp1(4) xor state(2);
		
-- ******************** ASSOCIATED DATA ********************	
		
			while (a_len - 128*ad_words > 128) loop
				ad_tmp := ad((128*(ad_words+1))-1 downto 128*ad_words);
				tmp1(0) := tmp1(0) xor ad_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor ad_tmp(127 downto 64);
				ad_processing: for j in 0 to 7 loop
					tmp1 := ascon_p_f(tmp1,8,j);
				end loop ad_processing;
				ad_words := ad_words + 1;
			end loop;

			if (a_len -(128*(ad_words+1)) = 0) then
				ad_tmp := ad((128*(ad_words+1))-1 downto 128*ad_words);
				tmp1(0) := tmp1(0) xor ad_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor ad_tmp(127 downto 64);
				ad_processing_last_full: for j in 0 to 7 loop
					tmp1 := ascon_p_f(tmp1,8,j);
				end loop ad_processing_last_full;
				ad_tmp := x"00000000000000000000000000000001";
			else
				ad_tmp := x"00000000000000000000000000000000";
				ad_tmp(8 + a_len - 1 - 128*ad_words downto 0) := x"01" & ad(a_len - 1 downto 128*ad_words);
			end if;

			tmp1(0) := tmp1(0) xor ad_tmp(63 downto 0);
			tmp1(1) := tmp1(1) xor ad_tmp(127 downto 64);

			ad_processing_last: for j in 0 to 7 loop
				tmp1 := ascon_p_f(tmp1,8,j);
			end loop ad_processing_last;
	
			tmp1(4)(63) := tmp1(4)(63) xor '1';

-- ******************** PLAINTEXT ********************

			while (p_len - 128*pl_words > 128) loop
				pl_tmp := pl((128*(pl_words+1))-1 downto 128*pl_words);
				tmp1(0) := tmp1(0) xor pl_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor pl_tmp(127 downto 64);
				res.c((128*(pl_words+1))-1 downto 128*pl_words) := tmp1(1) & tmp1(0);
				pl_processing: for j in 0 to 7 loop
					tmp1 := ascon_p_f(tmp1,8,j);
				end loop pl_processing;
				pl_words := pl_words + 1;
			end loop;

			if (p_len -(128*(pl_words+1)) = 0) then
				pl_tmp := pl((128*(pl_words+1))-1 downto 128*pl_words);
				tmp1(0) := tmp1(0) xor pl_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor pl_tmp(127 downto 64);
				res.c((128*(pl_words+1))-1 downto 128*pl_words) := tmp1(1) & tmp1(0);
				pl_processing_last_full: for j in 0 to 7 loop
					tmp1 := ascon_p_f(tmp1,8,j);
				end loop pl_processing_last_full;
				pl_tmp := x"00000000000000000000000000000001";
				tmp1(0) := tmp1(0) xor pl_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor pl_tmp(127 downto 64);
			else
				pl_tmp := x"00000000000000000000000000000000";
				pl_tmp(8 + p_len - 1 - 128*pl_words downto 0) := x"01" & pl(p_len - 1 downto 128*pl_words);
				tmp1(0) := tmp1(0) xor pl_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor pl_tmp(127 downto 64);
				tmp12 := tmp1(1) & tmp1(0);
				res.c(p_len-1 downto 128*pl_words) := tmp12(p_len-1-128*pl_words downto 0);
			end if;
			
-- ******************** FINALIZATION ********************

			tmp1(2) := tmp1(2) xor state(1);
			tmp1(3) := tmp1(3) xor state(2);

			fin: for j in 0 to 11 loop
				tmp1 := ascon_p_f(tmp1,12,j);
			end loop fin;
			
			T(63 downto 0) := tmp1(3) xor state(1);
			T(127 downto 64) := tmp1(4) xor state(2);

			res.t := T;
			
		return res;

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
			tmp(2) := state(2) XOR (x"00000000000000" & ascon_const_c(16 - rnd + i));
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
			
			x0 := x0 XOR (x0 ror 19) XOR (x0 ror 28);
			x1 := x1 XOR (x1 ror 61) XOR (x1 ror 39);
			x2 := x2 XOR (x2 ror 1) XOR (x2 ror 6);
			x3 := x3 XOR (x3 ror 10) XOR (x3 ror 17);
			x4 := x4 XOR (x4 ror 7) XOR (x4 ror 41);
			
			tmp(0) := x0;
			tmp(1) := x1;
			tmp(2) := x2;
			tmp(3) := x3;
			tmp(4) := x4;
		return tmp;
	end function ascon_pl_f;

end package body ascon_pkg;
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
	
end package ascon_pkg;

package body ascon_pkg is

	function ascon_p_f (state: ascon_state_t; rnd: natural range 0 to 16; i: natural range 0 to 15) return ascon_state_t is
		variable tmp1,tmp2,tmp3: ascon_state_t := state;
		begin
			tmp1 := ascon_pc_f(state, rnd, i);
			tmp2 := ascon_ps_f(tmp1);
			tmp3 := ascon_pl_f(tmp2);
		return tmp3;
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
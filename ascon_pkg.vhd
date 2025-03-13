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

end package ascon_pkg;

package body ascon_pkg is

  function ascon_pc_f(state: ascon_state_t; rnd: natural range 0 to 16; i: natural range 0 to 15) return ascon_state_t is
    variable tmp: ascon_state_t := state;
  begin
    assert i < rnd severity failure;
    tmp(2)(7 downto 0) := state(2)(7 downto 0) xor ascon_const_c(16 - rnd + i);
    return tmp;
  end function ascon_pc_f;

end package body ascon_pkg;

use std.textio.all;
use std.env.all;

library ieee;
use ieee.std_logic_1164.all;

-- use work.ascon_pkg.all;
use work.ascon_sim_pkg.all;

entity ascon_pkg_sim is
  generic(kat_file_name: string);
end entity ascon_pkg_sim;

architecture sim of ascon_pkg_sim is

begin

  process
  begin
    check_ascon_pkg_p(kat_file_name);
    finish;
  end process;

end architecture sim;

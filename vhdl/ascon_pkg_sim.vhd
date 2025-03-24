use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;

use work.ascon_pkg.all;
use work.kat_pkg.all;

entity ascon_pkg_sim is
end entity ascon_pkg_sim;

architecture sim of ascon_pkg_sim is

  impure function ascon_check_f return boolean is
    variable l: line;
  begin
    for i in 1 to tv'length loop
      write(l, string'("Count = "));
      write(l, tv(i).count);
      writeline(output, l);
      write(l, string'("Key = "));
      hwrite(l, tv(i).key);
      writeline(output, l);
      write(l, string'("Nonce = "));
      hwrite(l, tv(i).nonce);
      writeline(output, l);
      write(l, string'("PT = "));
      if tv(i).pt_len > 0 then
        hwrite(l, tv(i).pt(0 to tv(i).pt_len - 1));
      end if;
      writeline(output, l);
      write(l, string'("AD = "));
      if tv(i).ad_len > 0 then
        hwrite(l, tv(i).ad(0 to tv(i).ad_len - 1));
      end if;
      writeline(output, l);
      write(l, string'("CT = "));
      if tv(i).pt_len > 0 then
        hwrite(l, tv(i).ct(0 to tv(i).pt_len - 1));
      end if;
      hwrite(l, tv(i).tag);
      writeline(output, l);
      writeline(output, l);
    end loop;
    return true;
  end function ascon_check_f;

begin

  assert ascon_check_f severity failure;

end architecture sim;

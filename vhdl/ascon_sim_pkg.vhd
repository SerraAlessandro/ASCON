use std.textio.all;
use std.env.all;

library ieee;
use ieee.std_logic_1164.all;

use work.ascon_pkg.all;

package ascon_sim_pkg is

  type std_ulogic_vector_ptr_t is access std_ulogic_vector;

  subtype w128_t is std_ulogic_vector(127 downto 0);

  type test_vector_t is record
    count:  natural;
    key:    w128_t;
    nonce:  w128_t;
    pt:     std_ulogic_vector_ptr_t;
    ad:     std_ulogic_vector_ptr_t;
    ct:     std_ulogic_vector_ptr_t;
    tag:    w128_t;
  end record;

  procedure print(t: inout test_vector_t);

  procedure check_ascon_pkg_p(kat_file_name: in string);

end package ascon_sim_pkg;

package body ascon_sim_pkg is

  procedure print(s: string) is
    variable l: line;
  begin
    write(l, s);
    writeline(output, l);
  end procedure print;

  procedure print(t: inout test_vector_t) is
    variable l: line;
  begin
    write(l, string'("Count = "));
    write(l, t.count);
    writeline(output, l);
    write(l, string'("Key = "));
    hwrite(l, t.key);
    writeline(output, l);
    write(l, string'("Nonce = "));
    hwrite(l, t.nonce);
    writeline(output, l);
    write(l, string'("PT = "));
    if t.pt'length /= 0 then
      hwrite(l, t.pt.all);
    end if;
    writeline(output, l);
    write(l, string'("AD = "));
    if t.ad'length /= 0 then
      hwrite(l, t.ad.all);
    end if;
    writeline(output, l);
    write(l, string'("CT = "));
    if t.ct'length /= 0 then
      hwrite(l, t.ct.all);
    end if;
    writeline(output, l);
    write(l, string'("TAG = "));
    hwrite(l, t.tag);
    writeline(output, l);
    print("");
  end procedure print;

  -- Read from "l" an hexadecimal text string of "len" bytes (2 digits each) "B(0),B(1),...,B(len-1)", converts it to std_ulogic_vector "v" of length 8*"len",
  -- with per 64-bits word byte reordering: B(7),B(6),...,B(0),B(15),...,B(8),...
  procedure read_hexbytestring(l: inout line; len: in natural; v: out std_ulogic_vector) is
    variable lv: std_ulogic_vector(0 to 8 * len - 1);
    variable good: boolean;
    variable n: natural := 0;
  begin
    for i in 0 to len / 8 loop
      for j in 7 downto 0 loop
        if 8 * i + j < len then
          hread(l, lv(n to n + 7), good);
          assert good
            report "read_hexbytestring(l=" & l.all & ",len=" & to_string(len) & ",v): invalid string byte length"
            severity failure;
          n := n + 8;
        end if;
      end loop;
    end loop;
--    v := reverse_byte(lv);
    v := lv;
  end procedure read_hexbytestring;

  procedure check_ascon_pkg_p(kat_file_name: in string) is
    variable tv: test_vector_t;
    variable pt: std_ulogic_vector_ptr_t;
    variable ct: std_ulogic_vector_ptr_t;
    variable tag: w128_t;
    variable pt_len, ad_len: natural;
    variable l: line;
    file kat_file: text;
  begin
    file_open(kat_file, kat_file_name, read_mode);
    while not endfile(kat_file) loop
      readline(kat_file, l);
      read(l, tv.count);
      read_hexbytestring(l, 16, tv.key);
      read_hexbytestring(l, 16, tv.nonce);
      read(l, pt_len);
      tv.pt := new std_ulogic_vector(4 * pt_len - 1 downto 0);
      pt := new std_ulogic_vector(4 * pt_len - 1 downto 0);
      tv.ct := new std_ulogic_vector(4 * pt_len - 1 downto 0);
      ct := new std_ulogic_vector(4 * pt_len - 1 downto 0);
      if pt_len /= 0 then
        read_hexbytestring(l, pt_len / 2, tv.pt.all);
      end if;
      read(l, ad_len);
      tv.ad := new std_ulogic_vector(4 * ad_len - 1 downto 0);
      if ad_len /= 0 then
        read_hexbytestring(l, ad_len / 2, tv.ad.all);
      end if;
      if pt_len /= 0 then
        read_hexbytestring(l, pt_len / 2, tv.ct.all);
      end if;
      read_hexbytestring(l, 16, tv.tag);
      print(tv);
      ascon_enc_p(tv.key, tv.nonce, tv.ad.all, tv.pt.all, ct.all, tag);
      if ct.all /= tv.ct.all then
        write(l, string'("ERROR ascon_enc_p returned CT = "));
        hwrite(l, ct.all);
        write(l, string'(" instead of "));
        hwrite(l, tv.ct.all);
        writeline(output, l);
        assert false severity failure;
      end if;
      if tag /= tv.tag then
        write(l, string'("ERROR ascon_enc_f returned TAG = "));
        hwrite(l, tag);
        write(l, string'(" instead of "));
        hwrite(l, tv.tag);
        writeline(output, l);
        assert false severity failure;
      end if;
      ascon_dec_p(tv.key, tv.nonce, tv.ad.all, tv.ct.all, pt.all, tag);
      if pt.all /= tv.pt.all then
        write(l, string'("ERROR ascon_dec_p returned PT = "));
        hwrite(l, pt.all);
        write(l, string'(" instead of "));
        hwrite(l, tv.pt.all);
        writeline(output, l);
        assert false severity failure;
      end if;
      if tag /= tv.tag then
        write(l, string'("ERROR ascon_dec_p returned TAG = "));
        hwrite(l, tag);
        write(l, string'(" instead of "));
        hwrite(l, tv.tag);
        writeline(output, l);
        assert false severity failure;
      end if;
      deallocate(tv.pt);
      deallocate(pt);
      deallocate(tv.ct);
      deallocate(ct);
      deallocate(tv.ad);
    end loop;
    print("Regression test passed!");
  end procedure check_ascon_pkg_p;

end package body ascon_sim_pkg;

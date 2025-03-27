use std.textio.all;
use std.env.all;

library ieee;
use ieee.std_logic_1164.all;

-- use work.ascon_pkg.all;

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

  procedure ascon_enc_f(ad: in std_ulogic_vector; pt: in std_ulogic_vector; key: in w128_t; nonce: in w128_t; ct: out std_ulogic_vector; tag: out w128_t);
  procedure ascon_dec_f(ad: in std_ulogic_vector; ct: in std_ulogic_vector; key: in w128_t; nonce: in w128_t; tag: in w128_t; pt: out std_ulogic_vector; success: out boolean);

  procedure check_ascon_pkg_p(kat_file_name: in string);

end package ascon_sim_pkg;

package body ascon_sim_pkg is

  impure function to_hexbytestring(v: std_ulogic_vector) return string is
    constant len: natural := v'length;
    constant lv: std_ulogic_vector(0 to len - 1) := v;
    variable l: line;
  begin
    assert len mod 8 = 0 report "to_hexbytestring: invalid vector length (" & to_string(len) & ")" severity failure;
    for i in 0 to len / 64 loop
      for j in 7 downto 0 loop
        if 64 * i + 8 * j < len then
          hwrite(l, lv(64 * i + 8 * j to 64 * i + 8 * j + 7));
        end if;
      end loop;
    end loop;
    return l.all;
  end function to_hexbytestring;

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
    write(l, to_hexbytestring(t.key));
    writeline(output, l);
    write(l, string'("Nonce = "));
    write(l, to_hexbytestring(t.nonce));
    writeline(output, l);
    write(l, string'("PT = "));
    write(l, to_hexbytestring(t.pt.all));
    writeline(output, l);
    write(l, string'("AD = "));
    write(l, to_hexbytestring(t.ad.all));
    writeline(output, l);
    write(l, string'("CT = "));
    write(l, to_hexbytestring(t.ct.all));
    writeline(output, l);
    write(l, string'("Tag = "));
    write(l, to_hexbytestring(t.tag));
    writeline(output, l);
  end procedure print;

  procedure check_ascon_pkg_p(kat_file_name: in string) is
    variable tv: test_vector_t;
    variable pt, ct: std_ulogic_vector_ptr_t;
    variable tag: w128_t;
    variable success: boolean;
    variable pt_len, ad_len: natural;
    variable l: line;
    file kat_file: text;
  begin
    file_open(kat_file, kat_file_name, read_mode);
    while not endfile(kat_file) loop
      readline(kat_file, l);
      read(l, tv.count);
      hread(l, tv.key);
      hread(l, tv.nonce);
      read(l, pt_len);
      tv.pt := new std_ulogic_vector(4 * pt_len - 1 downto 0);
      pt := new std_ulogic_vector(4 * pt_len - 1 downto 0);
      tv.ct := new std_ulogic_vector(4 * pt_len - 1 downto 0);
      ct := new std_ulogic_vector(4 * pt_len - 1 downto 0);
      if pt_len /= 0 then
        hread(l, tv.pt.all);
      end if;
      read(l, ad_len);
      tv.ad := new std_ulogic_vector(4 * ad_len - 1 downto 0);
      if ad_len /= 0 then
        hread(l, tv.ad.all);
      end if;
      if pt_len /= 0 then
        hread(l, tv.ct.all);
      end if;
      hread(l, tv.tag);
      ascon_enc_f(tv.ad.all, tv.pt.all, tv.key, tv.nonce, ct.all, tag);
      if ct.all /= tv.ct.all or tag /= tv.tag then
        print("ERROR! With test vector:");
        print(tv);
        print("ascon_enc_f returned:");
        write(l, string'("CT = "));
        write(l, to_hexbytestring(ct.all));
        writeline(output, l);
        write(l, string'("Tag = "));
        write(l, to_hexbytestring(tag));
        writeline(output, l);
        assert false severity failure;
      end if;
      ascon_dec_f(tv.ad.all, tv.ct.all, tv.key, tv.nonce, tv.tag, pt.all, success);
      if pt.all /= tv.pt.all or (not success) then
        print("ERROR! With test vector:");
        print(tv);
        print("ascon_dec_f returned:");
        write(l, string'("PT = "));
        write(l, to_hexbytestring(pt.all));
        writeline(output, l);
        write(l, string'("Success = "));
        write(l, success);
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

  procedure ascon_enc_f(ad: in std_ulogic_vector; pt: in std_ulogic_vector; key: in w128_t; nonce: in w128_t; ct: out std_ulogic_vector; tag: out w128_t) is
  begin
    ct := pt;
    tag := (others => '0');
  end procedure ascon_enc_f;

  procedure ascon_dec_f(ad: in std_ulogic_vector; ct: in std_ulogic_vector; key: in w128_t; nonce: in w128_t; tag: in w128_t; pt: out std_ulogic_vector; success: out boolean) is
  begin
    pt := ct;
    success := false;
  end procedure ascon_dec_f;

end package body ascon_sim_pkg;

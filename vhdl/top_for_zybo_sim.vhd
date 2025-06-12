use std.env.all;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

library common;
use common.axi_pkg.all;
use common.rnd_pkg.all;
use common.utils_pkg.all;

use work.ascon_sim_pkg.all;

entity top_for_zybo_sim is
  generic(
    stim_file_name:    string := "stim.txt";
    meminit_file_name: string := "meminit.txt"
  );
end entity top_for_zybo_sim;

architecture sim of top_for_zybo_sim is

  signal aclk:           std_ulogic;
  signal aresetn:        std_ulogic;
  signal s0_axi_araddr:  std_ulogic_vector(11 downto 0);
  signal s0_axi_arvalid: std_ulogic;
  signal s0_axi_arready: std_ulogic;
  signal s0_axi_rdata:   std_ulogic_vector(31 downto 0);
  signal s0_axi_rresp:   std_ulogic_vector(1 downto 0);
  signal s0_axi_rvalid:  std_ulogic;
  signal s0_axi_rready:  std_ulogic;
  signal s0_axi_awaddr:  std_ulogic_vector(11 downto 0);
  signal s0_axi_awvalid: std_ulogic;
  signal s0_axi_awready: std_ulogic;
  signal s0_axi_wdata:   std_ulogic_vector(31 downto 0);
  signal s0_axi_wstrb:   std_ulogic_vector(3 downto 0);
  signal s0_axi_wvalid:  std_ulogic;
  signal s0_axi_wready:  std_ulogic;
  signal s0_axi_bvalid:  std_ulogic;
  signal s0_axi_bresp:   std_ulogic_vector(1 downto 0);
  signal s0_axi_bready:  std_ulogic;
  signal m0_axi_araddr:  std_ulogic_vector(31 downto 0);
  signal m0_axi_arvalid: std_ulogic;
  signal m0_axi_arready: std_ulogic;
  signal m0_axi_rdata:   std_ulogic_vector(31 downto 0);
  signal m0_axi_rresp:   std_ulogic_vector(1 downto 0);
  signal m0_axi_rvalid:  std_ulogic;
  signal m0_axi_rready:  std_ulogic;
  signal m0_axi_awaddr:  std_ulogic_vector(31 downto 0);
  signal m0_axi_awvalid: std_ulogic;
  signal m0_axi_awready: std_ulogic;
  signal m0_axi_wdata:   std_ulogic_vector(31 downto 0);
  signal m0_axi_wstrb:   std_ulogic_vector(3 downto 0);
  signal m0_axi_wvalid:  std_ulogic;
  signal m0_axi_wready:  std_ulogic;
  signal m0_axi_bvalid:  std_ulogic;
  signal m0_axi_bresp:   std_ulogic_vector(1 downto 0);
  signal m0_axi_bready:  std_ulogic;

begin

  dut: entity work.top_for_zybo
  port map(
    aclk           => aclk,
    aresetn        => aresetn,
    s0_axi_araddr  => s0_axi_araddr,
    s0_axi_arvalid => s0_axi_arvalid,
    s0_axi_arready => s0_axi_arready,
    s0_axi_rdata   => s0_axi_rdata,
    s0_axi_rresp   => s0_axi_rresp,
    s0_axi_rvalid  => s0_axi_rvalid,
    s0_axi_rready  => s0_axi_rready,
    s0_axi_awaddr  => s0_axi_awaddr,
    s0_axi_awvalid => s0_axi_awvalid,
    s0_axi_awready => s0_axi_awready,
    s0_axi_wdata   => s0_axi_wdata,
    s0_axi_wstrb   => s0_axi_wstrb,
    s0_axi_wvalid  => s0_axi_wvalid,
    s0_axi_wready  => s0_axi_wready,
    s0_axi_bvalid  => s0_axi_bvalid,
    s0_axi_bresp   => s0_axi_bresp,
    s0_axi_bready  => s0_axi_bready,
    m0_axi_araddr  => m0_axi_araddr,
    m0_axi_arvalid => m0_axi_arvalid,
    m0_axi_arready => m0_axi_arready,
    m0_axi_rdata   => m0_axi_rdata,
    m0_axi_rresp   => m0_axi_rresp,
    m0_axi_rvalid  => m0_axi_rvalid,
    m0_axi_rready  => m0_axi_rready,
    m0_axi_awaddr  => m0_axi_awaddr,
    m0_axi_awvalid => m0_axi_awvalid,
    m0_axi_awready => m0_axi_awready,
    m0_axi_wdata   => m0_axi_wdata,
    m0_axi_wstrb   => m0_axi_wstrb,
    m0_axi_wvalid  => m0_axi_wvalid,
    m0_axi_wready  => m0_axi_wready,
    m0_axi_bvalid  => m0_axi_bvalid,
    m0_axi_bresp   => m0_axi_bresp,
    m0_axi_bready  => m0_axi_bready
  );

  u0: entity common.axi_memory
  generic map(
    na   => 20,
    nb   => 2,
    fin  => meminit_file_name,
    fout => "/dev/null"
  )
  port map(
    aclk           => aclk,
    aresetn        => aresetn,
    dump           => '0',
    s0_axi_araddr  => m0_axi_araddr(19 downto 0),
    s0_axi_arvalid => m0_axi_arvalid,
    s0_axi_arready => m0_axi_arready,
    s0_axi_awaddr  => m0_axi_awaddr(19 downto 0),
    s0_axi_awvalid => m0_axi_awvalid,
    s0_axi_awready => m0_axi_awready,
    s0_axi_wdata   => m0_axi_wdata,
    s0_axi_wstrb   => m0_axi_wstrb,
    s0_axi_wvalid  => m0_axi_wvalid,
    s0_axi_wready  => m0_axi_wready,
    s0_axi_rdata   => m0_axi_rdata,
    s0_axi_rresp   => m0_axi_rresp,
    s0_axi_rvalid  => m0_axi_rvalid,
    s0_axi_rready  => m0_axi_rready,
    s0_axi_bresp   => m0_axi_bresp,
    s0_axi_bvalid  => m0_axi_bvalid,
    s0_axi_bready  => m0_axi_bready
  );

  process
  begin
    aclk <= '0';
    wait for 1 ns;
    aclk <= '1';
    wait for 1 ns;
  end process;

  process
    variable tv: test_vector_t;
    variable pt: std_ulogic_vector_ptr_t;
    variable ct: std_ulogic_vector_ptr_t;
    variable tag: w128_t;
    variable pt_len, ad_len: natural;
    variable l: line;
    file stim_file: text;
  begin
    aresetn        <= '0';
    s0_axi_arvalid <= '0';
    s0_axi_rready  <= '0';
    s0_axi_awvalid <= '0';
    s0_axi_wvalid  <= '0';
    s0_axi_bready  <= '0';
    for i in 1 to 10 loop
      wait until rising_edge(aclk);
    end loop;
    aresetn <= '1';
    for i in 1 to 10 loop
      wait until rising_edge(aclk);
    end loop;
    file_open(stim_file, stim_file_name, read_mode);
    while not endfile(stim_file) loop
      readline(stim_file, l);
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
      if ct.all /= tv.ct.all then
        write(l, string'("ERROR ascon_enc_p returned CT = "));
        hwrite(l, ct.all);
        write(l, string'(" instead of "));
        hwrite(l, tv.ct.all);
        writeline(output, l);
        assert false severity failure;
      end if;
      if tag /= tv.tag then
        write(l, string'("ERROR ascon_enc_p returned TAG = "));
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
  end process;

end architecture sim;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

library common;
use common.axi_pkg.all;
use common.rnd_pkg.all;
use common.utils_pkg.all;

entity top_for_zybo_sim is
  generic(
    stim:    string := "kat.txt";
    meminit: string := "meminit.txt";
    results: string := "results.txt"
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
    fin  => meminit,
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

end architecture sim;

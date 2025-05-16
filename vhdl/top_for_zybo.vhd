library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

library common;
use common.axi_pkg.all;

entity top_for_zybo is
    port(
        aclk:           in  std_ulogic;
        aresetn:        in  std_ulogic;
        s0_axi_araddr:  in  std_ulogic_vector(11 downto 0);
        s0_axi_arvalid: in  std_ulogic;
        s0_axi_arready: out std_ulogic;
        s0_axi_rdata:   out std_ulogic_vector(31 downto 0);
        s0_axi_rresp:   out std_ulogic_vector(1 downto 0);
        s0_axi_rvalid:  out std_ulogic;
        s0_axi_rready:  in  std_ulogic;
        s0_axi_awaddr:  in  std_ulogic_vector(11 downto 0);
        s0_axi_awvalid: in  std_ulogic;
        s0_axi_awready: out std_ulogic;
        s0_axi_wdata:   in  std_ulogic_vector(31 downto 0);
        s0_axi_wstrb:   in  std_ulogic_vector(3 downto 0);
        s0_axi_wvalid:  in  std_ulogic;
        s0_axi_wready:  out std_ulogic;
        s0_axi_bvalid:  out std_ulogic;
        s0_axi_bresp:   out std_ulogic_vector(1 downto 0);
        s0_axi_bready:  in  std_ulogic;
        m0_axi_araddr:  out std_ulogic_vector(31 downto 0);
        m0_axi_arvalid: out std_ulogic;
        m0_axi_arready: in  std_ulogic;
        m0_axi_rdata:   in  std_ulogic_vector(31 downto 0);
        m0_axi_rresp:   in  std_ulogic_vector(1 downto 0);
        m0_axi_rvalid:  in  std_ulogic;
        m0_axi_rready:  out std_ulogic;
        m0_axi_awaddr:  out std_ulogic_vector(31 downto 0);
        m0_axi_awvalid: out std_ulogic;
        m0_axi_awready: in  std_ulogic;
        m0_axi_wdata:   out std_ulogic_vector(31 downto 0);
        m0_axi_wstrb:   out std_ulogic_vector(3 downto 0);
        m0_axi_wvalid:  out std_ulogic;
        m0_axi_wready:  in  std_ulogic;
        m0_axi_bvalid:  in  std_ulogic;
        m0_axi_bresp:   in  std_ulogic_vector(1 downto 0);
        m0_axi_bready:  out std_ulogic
    );
end entity top_for_zybo;

architecture rtl of top_for_zybo is

  signal start_in:   std_ulogic;
  signal addr_in:    std_ulogic_vector(31 downto 0);
  signal len_in:     std_ulogic_vector(29 downto 0);
  signal eot_in:     std_ulogic;
  signal resp_in:    std_ulogic_vector(1 downto 0);
  signal tvalid_in:  std_ulogic;
  signal tready_in:  std_ulogic;
  signal tdata_in:   std_ulogic_vector(31 downto 0);
  signal tlast_in:   std_ulogic;
  signal start_out:  std_ulogic;
  signal addr_out:   std_ulogic_vector(31 downto 0);
  signal eot_out:    std_ulogic;
  signal resp_out:   std_ulogic_vector(1 downto 0);
  signal tvalid_out: std_ulogic;
  signal tready_out: std_ulogic;
  signal tdata_out:  std_ulogic_vector(31 downto 0);
  signal tlast_out:  std_ulogic;
  signal key:        std_ulogic_vector(127 downto 0);
  signal nonce:      std_ulogic_vector(127 downto 0);
  signal tag_valid:  std_ulogic;
  signal tag_ready:  std_ulogic;
  signal tag:        std_ulogic_vector(127 downto 0);

begin

  dma_in_0: entity work.dma_in
  port map(
    aclk           => aclk,
    aresetn        => aresetn,
    start          => start_in,
    addr           => addr_in,
    len            => len_in,
    eot            => eot_in,
    resp           => resp_in,
    m0_axi_araddr  => m0_axi_araddr,
    m0_axi_arvalid => m0_axi_arvalid,
    m0_axi_arready => m0_axi_arready,
    m0_axi_rdata   => m0_axi_rdata,
    m0_axi_rresp   => m0_axi_rresp,
    m0_axi_rvalid  => m0_axi_rvalid,
    m0_axi_rready  => m0_axi_rready,
    m1_axi_tvalid  => tvalid_in,
    m1_axi_tready  => tready_in,
    m1_axi_tdata   => tdata_in,
    m1_axi_tlast   => tlast_in
  );

  dma_out_0: entity work.dma_out
  port map(
    aclk           => aclk,
    aresetn        => aresetn,
    start          => start_out,
    addr           => addr_out,
    eot            => eot_out,
    resp           => resp_out,
    m0_axi_awaddr  => m0_axi_awaddr,
    m0_axi_awvalid => m0_axi_awvalid,
    m0_axi_awready => m0_axi_awready,
    m0_axi_wdata   => m0_axi_wdata,
    m0_axi_wstrb   => m0_axi_wstrb,
    m0_axi_wvalid  => m0_axi_wvalid,
    m0_axi_wready  => m0_axi_wready,
    m0_axi_bresp   => m0_axi_bresp,
    m0_axi_bvalid  => m0_axi_bvalid,
    m0_axi_bready  => m0_axi_bready,
    s0_axi_tvalid  => tvalid_out,
    s0_axi_tready  => tready_out,
    s0_axi_tdata   => tdata_out,
    s0_axi_tlast   => tlast_out
  );

  axi_lite_interface_0: entity work.axi_lite_interface
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
    start_in       => start_in,
    addr_in        => addr_in,
    len_in         => len_in,
    eot_in         => eot_in,
    resp_in        => resp_in,
    start_out      => start_out,
    addr_out       => addr_out,
    eot_out        => eot_out,
    resp_out       => resp_out,
    key            => key,
    nonce          => nonce,
    tag_valid      => tag_valid,
    tag_ready      => tag_ready,
    tag            => tag
  );

  crypto_core_0: entity work.crypto_core
  port map(
    aclk       => aclk,
    aresetn    => aresetn,
    key        => key,
    nonce      => nonce,
    tag_valid  => tag_valid,
    tag_ready  => tag_ready,
    tag        => tag,
    tvalid_in  => tvalid_in,
    tready_in  => tready_in,
    tdata_in   => tdata_in,
    tlast_in   => tlast_in,
    tvalid_out => tvalid_out,
    tready_out => tready_out,
    tdata_out  => tdata_out,
    tlast_out  => tlast_out
  );

end architecture rtl;

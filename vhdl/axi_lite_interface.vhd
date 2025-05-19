-- Copyright © Telecom Paris
-- Copyright © Renaud Pacalet (renaud.pacalet@telecom-paris.fr)
-- 
-- This file must be used under the terms of the CeCILL. This source
-- file is licensed as described in the file COPYING, which you should
-- have received as part of this distribution. The terms are also
-- available at:
-- https://cecill.info/licences/Licence_CeCILL_V2.1-en.html

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

library common;
use common.axi_pkg.all;

entity axi_lite_interface is
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
    start_in:       out std_ulogic;                      -- start input DMA engine
    addr_in:        out std_ulogic_vector(31 downto 0);  -- start memory address for input DMA transfers
    len_in:         out std_ulogic_vector(29 downto 0);  -- length (in 4-bytes words) of input DMA transfers
    eot_in:         in  std_ulogic;                      -- end of input DMA transfers
    resp_in:        in  std_ulogic_vector(1 downto 0);   -- last AXI error response during an input DMA transfer
    start_out:      out std_ulogic;                      -- start output DMA engine
    addr_out:       out std_ulogic_vector(31 downto 0);  -- start memory address for output DMA transfers
    eot_out:        in  std_ulogic;                      -- end of output DMA transfers
    resp_out:       in  std_ulogic_vector(1 downto 0);   -- last AXI error response during an output DMA transfer
    key:            out std_ulogic_vector(127 downto 0); -- secret key
    nonce:          out std_ulogic_vector(127 downto 0); -- nonce
    tag_valid:      in  std_ulogic;                      -- tag input is valid
    tag_ready:      out std_ulogic;                      -- tag input acknowledge
    tag:            in  std_ulogic_vector(127 downto 0)  -- authentication tag
  );
end entity axi_lite_interface;

architecture rtl of axi_lite_interface is
begin
end architecture rtl;

-- Copyright © Telecom Paris
-- Copyright © Renaud Pacalet (renaud.pacalet@telecom-paris.fr)
-- 
-- This file must be used under the terms of the CeCILL. This source
-- file is licensed as described in the file COPYING, which you should
-- have received as part of this distribution. The terms are also
-- available at:
-- https://cecill.info/licences/Licence_CeCILL_V2.1-en.html

-- Input DMA engine. Automatically read len 32 bits words from memory starting
-- at addr (which 2 LSB are ignored). Read data transferred to stream AXI
-- slave. End of transfer (eot) asserted high for 1 clock period after last
-- word accepted by stream AXI slave. Final resp okay iff all AXI read
-- transactions were okay, else last non okay received response.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

library common;
use common.axi_pkg.all;

entity dma_in is
    port(
        aclk:           in  std_ulogic;
        aresetn:        in  std_ulogic;
        start:          in  std_ulogic;
        addr:           in  std_ulogic_vector(31 downto 0);
        len:            in  std_ulogic_vector(29 downto 0);
        eot:            out std_ulogic;
        resp:           out std_ulogic_vector(1 downto 0);
        m0_axi_araddr:  out std_ulogic_vector(31 downto 0);
        m0_axi_arvalid: out std_ulogic;
        m0_axi_arready: in  std_ulogic;
        m0_axi_rdata:   in  std_ulogic_vector(31 downto 0);
        m0_axi_rresp:   in  std_ulogic_vector(1 downto 0);
        m0_axi_rvalid:  in  std_ulogic;
        m0_axi_rready:  out std_ulogic;
        m1_axi_tvalid:  out std_ulogic;
        m1_axi_tready:  in  std_ulogic;
        m1_axi_tdata:   out std_ulogic_vector(31 downto 0);
        m1_axi_tlast:   out std_ulogic
    );
end entity dma_in;

architecture rtl of dma_in is

    -- FIFO interface
    signal write: std_ulogic;
    signal wdata: std_ulogic_vector(32 downto 0);
    signal read:  std_ulogic;
    signal rdata: std_ulogic_vector(32 downto 0);
    signal empty: std_ulogic;
    signal full:  std_ulogic;

    signal arcnt: std_ulogic_vector(29 downto 0); -- remaining read requests
    signal rcnt:  std_ulogic_vector(29 downto 0); -- remaining read requests

begin

    m0_axi_arvalid     <= '1' when arcnt > 0 else '0';
    m0_axi_rready      <= not full;
    wdata(31 downto 0) <= m0_axi_rdata;
    wdata(32)          <= '1' when rcnt = 1 else '0';
    write              <= m0_axi_rvalid and m0_axi_rready;

    m1_axi_tdata       <= rdata(31 downto 0);
    m1_axi_tlast       <= rdata(32);
    m1_axi_tvalid      <= not empty;
    read               <= m1_axi_tvalid and m1_axi_tready;

    eot                <= m1_axi_tvalid and m1_axi_tready and m1_axi_tlast;

    -- FIFO. MSB = last flag
    u0: entity common.fifo(rtl)
    generic map(
        w => 33,
        d => 8
    )
    port map( 
        aclk    => aclk,
        aresetn => aresetn,
        write   => write,
        wdata   => wdata,
        read    => read,
        rdata   => rdata,
        empty   => empty,
        full    => full
    );

    process(aclk)
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                m0_axi_araddr <= (others => '0');
                resp          <= axi_resp_okay;
                arcnt         <= (others => '0');
                rcnt          <= (others => '0');
            else
                if start = '1' then
                    m0_axi_araddr <= addr(31 downto 2) & "00";
                    resp          <= axi_resp_okay;
                    arcnt         <= len;
                    rcnt          <= len;
                end if;
                if m0_axi_arvalid = '1' and m0_axi_arready = '1' then
                    m0_axi_araddr <= m0_axi_araddr + 4;
                    arcnt         <= arcnt - 1;
                end if;
                if m0_axi_rvalid = '1' and m0_axi_rready = '1' then
                    if m0_axi_rresp /= axi_resp_okay then
                        resp <= m0_axi_rresp;
                    end if;
                    rcnt <= rcnt - 1;
                end if;
            end if;
        end if;
    end process;

end architecture rtl;

-- vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab textwidth=0:

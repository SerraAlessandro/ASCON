-- Copyright © Telecom Paris
-- Copyright © Renaud Pacalet (renaud.pacalet@telecom-paris.fr)
-- 
-- This file must be used under the terms of the CeCILL. This source
-- file is licensed as described in the file COPYING, which you should
-- have received as part of this distribution. The terms are also
-- available at:
-- https://cecill.info/licences/Licence_CeCILL_V2.1-en.html

-- Output DMA engine. Receives 32 bits data words from stream AXI master and
-- automatically writes them to memory starting at addr (which 2 LSB are
-- ignored). End of transfer (eot) asserted high for 1 clock period after last
-- word accepted by memory slave. Final resp okay iff all AXI write
-- transactions were okay, else last non okay received response.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

library common;
use common.axi_pkg.all;

entity dma_out is
    port(
        aclk:           in  std_ulogic;
        aresetn:        in  std_ulogic;
        start:          in  std_ulogic;
        addr:           in  std_ulogic_vector(31 downto 0);
        eot:            out std_ulogic;
        resp:           out std_ulogic_vector(1 downto 0);
        m0_axi_awaddr:  out std_ulogic_vector(31 downto 0);
        m0_axi_awvalid: out std_ulogic;
        m0_axi_awready: in  std_ulogic;
        m0_axi_wdata:   out std_ulogic_vector(31 downto 0);
        m0_axi_wstrb:   out std_ulogic_vector(3 downto 0);
        m0_axi_wvalid:  out std_ulogic;
        m0_axi_wready:  in  std_ulogic;
        m0_axi_bresp:   in  std_ulogic_vector(1 downto 0);
        m0_axi_bvalid:  in  std_ulogic;
        m0_axi_bready:  out std_ulogic;
        s0_axi_tvalid:  in  std_ulogic;
        s0_axi_tready:  out std_ulogic;
        s0_axi_tdata:   in  std_ulogic_vector(31 downto 0);
        s0_axi_tlast:   in  std_ulogic
    );

end entity dma_out;

architecture rtl of dma_out is

    -- FIFO interface
    signal write: std_ulogic;
    signal wdata: std_ulogic_vector(32 downto 0);
    signal read:  std_ulogic;
    signal rdata: std_ulogic_vector(32 downto 0);
    signal empty: std_ulogic;
    signal full:  std_ulogic;

    -- valid/ready mergers
    type merger_state_t is (idle, waiting_for_awready, waiting_for_wready, waiting_for_both);
    signal merger_state: merger_state_t;
    signal valid: std_ulogic;
    signal ready: std_ulogic;

begin

    -- valid/ready mergers
    process(aclk)
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                merger_state <= idle;
            else
                case merger_state is
                    when idle =>
                        if m0_axi_awvalid = '1' then
                            if m0_axi_awready = '0' and m0_axi_wready = '0' then
                                merger_state <= waiting_for_both;
                            elsif m0_axi_wready = '0' then
                                merger_state <= waiting_for_wready;
                            elsif m0_axi_awready = '0' then
                                merger_state <= waiting_for_awready;
                            end if;
                        end if;
                    when waiting_for_awready =>
                        if m0_axi_awready = '1' then
                            merger_state <= idle;
                        end if;
                    when waiting_for_wready =>
                        if m0_axi_wready = '1' then
                            merger_state <= idle;
                        end if;
                    when waiting_for_both =>
                        if m0_axi_awready = '1' and m0_axi_wready = '1' then
                            merger_state <= idle;
                        elsif m0_axi_awready = '1' then
                            merger_state <= waiting_for_wready;
                        elsif m0_axi_wready = '1' then
                            merger_state <= waiting_for_awready;
                        end if;
                end case;
            end if;
        end if;
    end process;

    valid          <= not empty;
    ready          <= '1' when m0_axi_awready = '1' and m0_axi_wready = '1' else
                      '1' when m0_axi_awready = '1' and merger_state = waiting_for_awready else
                      '1' when m0_axi_wready = '1' and merger_state = waiting_for_wready else
                      '0';
    m0_axi_awvalid <= '1' when valid = '1' and merger_state /= waiting_for_wready else '0';
    m0_axi_wvalid  <= '1' when valid = '1' and merger_state /= waiting_for_awready else '0';

    m0_axi_bready  <= '1';
    m0_axi_wdata   <= rdata(31 downto 0);
    m0_axi_wstrb   <= (others => '1');
    read           <= valid and ready;

    wdata          <= s0_axi_tlast & s0_axi_tdata;
    s0_axi_tready  <= not full;
    write          <= s0_axi_tvalid and s0_axi_tready;

    eot            <= valid and ready and rdata(32);

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
                m0_axi_awaddr <= (others => '0');
                resp          <= axi_resp_okay;
            else
                if start = '1' then
                    m0_axi_awaddr <= addr(31 downto 2) & "00";
                    resp          <= axi_resp_okay;
                end if;
                if valid = '1' and ready = '1' then
                    m0_axi_awaddr <= m0_axi_awaddr + 4;
                end if;
                if m0_axi_bvalid = '1' then
                    if m0_axi_bresp /= axi_resp_okay then
                        resp <= m0_axi_bresp;
                    end if;
                end if;
            end if;
        end if;
    end process;

end architecture rtl;

-- vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab textwidth=0:

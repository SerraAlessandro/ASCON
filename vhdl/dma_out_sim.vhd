-- Copyright © Telecom Paris
-- Copyright © Renaud Pacalet (renaud.pacalet@telecom-paris.fr)
-- 
-- This file must be used under the terms of the CeCILL. This source
-- file is licensed as described in the file COPYING, which you should
-- have received as part of this distribution. The terms are also
-- available at:
-- https://cecill.info/licences/Licence_CeCILL_V2.1-en.html

use std.textio.all;
use std.env.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

library common;
use common.axi_pkg.all;
use common.rnd_pkg.all;
use common.utils_pkg.all;


entity dma_out_sim is
    generic(
        n:       positive := 100; -- test vectors
        max_len: positive := 100  -- maximum length of transfer
    );
end entity dma_out_sim;

architecture sim of dma_out_sim is

    signal aclk:           std_ulogic;
    signal aresetn:        std_ulogic;
    signal start:          std_ulogic;
    signal addr:           std_ulogic_vector(31 downto 0);
    signal eot:            std_ulogic;
    signal resp:           std_ulogic_vector(1 downto 0);
    signal m0_axi_awaddr:  std_ulogic_vector(31 downto 0);
    signal m0_axi_awvalid: std_ulogic;
    signal m0_axi_awready: std_ulogic;
    signal m0_axi_wdata:   std_ulogic_vector(31 downto 0);
    signal m0_axi_wstrb:   std_ulogic_vector(3 downto 0);
    signal m0_axi_wvalid:  std_ulogic;
    signal m0_axi_wready:  std_ulogic;
    signal m0_axi_bresp:   std_ulogic_vector(1 downto 0);
    signal m0_axi_bvalid:  std_ulogic;
    signal m0_axi_bready:  std_ulogic;
    signal s0_axi_tvalid:  std_ulogic;
    signal s0_axi_tready:  std_ulogic;
    signal s0_axi_tdata:   std_ulogic_vector(31 downto 0);
    signal s0_axi_tlast:   std_ulogic;

    signal resp_okay:      boolean;

    subtype w32 is std_ulogic_vector(31 downto 0);
    package fifo_pkg is new common.soft_fifo_pkg generic map(t => w32);
    shared variable addr_axi_fifo: fifo_pkg.soft_fifo;
    shared variable data_axi_fifo: fifo_pkg.soft_fifo;

begin

    u0: entity work.dma_out(rtl)
    port map(
        aclk           => aclk,
        aresetn        => aresetn,
        start          => start,
        addr           => addr,
        eot            => eot,
        resp           => resp,
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
        s0_axi_tvalid  => s0_axi_tvalid,
        s0_axi_tready  => s0_axi_tready,
        s0_axi_tdata   => s0_axi_tdata,
        s0_axi_tlast   => s0_axi_tlast
    );

    process
    begin
        aclk <= '0';
        wait for 1 ns;
        aclk <= '1';
        wait for 1 ns;
    end process;

    -- memory emulator, address, strobe and data checker
    process(aclk)
        variable r:        rnd_generator;
        variable areq:     natural;
        variable dreq:     natural;
        variable addr_ref: w32;
        variable data_ref: w32;
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                m0_axi_awready <= '0';
                m0_axi_wready  <= '0';
                m0_axi_bvalid  <= '0';
                m0_axi_bresp   <= axi_resp_okay;
                areq           := 0;
                dreq           := 0;
            else
                m0_axi_awready <= r.get_std_ulogic;
                m0_axi_wready  <= r.get_std_ulogic;
                if m0_axi_awvalid = '1' and m0_axi_awready = '1' then
                    areq     := areq + 1;
                    addr_ref := addr_axi_fifo.pop;
                    check_ref(m0_axi_awaddr, addr_ref, "m0_axi_awaddr");
                end if;
                if m0_axi_wvalid = '1' and m0_axi_wready = '1' then
                    dreq     := dreq + 1;
                    data_ref := data_axi_fifo.pop;
                    check_ref(m0_axi_wdata, data_ref, "m0_axi_wdata");
                end if;
                if m0_axi_bvalid = '1' and m0_axi_bready = '1' then
                    areq          := areq - 1;
                    dreq          := dreq - 1;
                    m0_axi_bvalid <= '0';
                end if;
                if areq > 0 and dreq > 0 and (m0_axi_bvalid = '0' or m0_axi_bready = '1') and r.get_boolean then
                    m0_axi_bvalid <= '1';
                    m0_axi_bresp  <= axi_resp_okay when resp_okay else r.get_std_ulogic_vector(2);
                end if;
            end if;
        end if;
    end process;

    -- axi lite address stability checker
    process(aclk)
        type state_t is (idle, check);
        variable state:    state_t;
        variable addr_ref: std_ulogic_vector(31 downto 0);
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                state    := idle;
                addr_ref := (others => '0');
            else
                if m0_axi_awvalid = '1' then
                    check_ref(m0_axi_awaddr(1 downto 0), "00", "m0_axi_awaddr");
                end if;
                case state is
                    when idle =>
                        if m0_axi_awvalid = '1' and m0_axi_awready = '0' then
                            addr_ref := m0_axi_awaddr;
                            state    := check;
                        end if;
                    when check =>
                        check_ref(m0_axi_awvalid, '1', "m0_axi_awvalid");
                        check_ref(m0_axi_awaddr, addr_ref, "m0_axi_awaddr");
                        if m0_axi_awready = '1' then
                            state := idle;
                        end if;
                end case;
            end if;
        end if;
    end process;

    -- axi lite data and strobe stability checker
    process(aclk)
        type state_t is (idle, check);
        variable state:    state_t;
        variable data_ref: std_ulogic_vector(31 downto 0);
        variable strb_ref: std_ulogic_vector(3 downto 0);
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                state    := idle;
                data_ref := (others => '0');
                strb_ref := (others => '0');
            else
                if m0_axi_wvalid = '1' then
                    check_ref(m0_axi_wstrb, "1111", "m0_axi_wstrb");
                end if;
                case state is
                    when idle =>
                        if m0_axi_wvalid = '1' and m0_axi_wready = '0' then
                            data_ref := m0_axi_wdata;
                            state    := check;
                        end if;
                    when check =>
                        check_ref(m0_axi_wvalid, '1', "m0_axi_wvalid");
                        check_ref(m0_axi_wdata, data_ref, "m0_axi_wdata");
                        if m0_axi_wready = '1' then
                            state := idle;
                        end if;
                end case;
            end if;
        end if;
    end process;

    -- cpu emulator, resp checker
    process
        variable r:        rnd_generator;
        variable resp_ref: std_ulogic_vector(1 downto 0);
    begin
        aresetn <= '0';
        start   <= '0';
        addr    <= (others => '0');
        for i in 1 to 10 loop
            wait until rising_edge(aclk);
        end loop;
        aresetn <= '1';
        for i in 1 to n loop
            resp_okay <= i mod 2 = 0;
            resp_ref  := axi_resp_okay;
            for j in 0 to r.get_integer(0, 5) loop
                wait until rising_edge(aclk);
            end loop;
            addr  <= '0' & r.get_std_ulogic_vector(31);
            start <= '1';
            wait until rising_edge(aclk);
            start <= '0';
            loop
                if m0_axi_bvalid = '1' and m0_axi_bready = '1' and m0_axi_bresp /= axi_resp_okay then
                    resp_ref := m0_axi_bresp;
                end if;
                wait until rising_edge(aclk);
                exit when eot = '1';
            end loop;
            check_ref(resp, resp_ref, "resp");
        end loop;
        pass;
    end process;

    -- axi stream master
    process(aclk)
        variable r: rnd_generator;
        variable data_ref: w32;
        variable addr_ref: w32;
        variable cnt:      natural range 0 to max_len;
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                s0_axi_tvalid <= '0';
                s0_axi_tdata  <= (others => '0');
                s0_axi_tlast  <= '0';
                data_ref      := (others => '0');
            else
                if start = '1' and cnt = 0 then
                    addr_ref := addr(31 downto 2) & "00";
                    cnt      := r.get_integer(1, max_len);
                end if;
                if s0_axi_tvalid = '1' and s0_axi_tready = '1' then
                    s0_axi_tvalid <= '0';
                end if;
                if cnt > 0 and (s0_axi_tvalid = '0' or s0_axi_tready = '1') and r.get_boolean then
                    s0_axi_tvalid <= '1';
                    data_ref      := r.get_std_ulogic_vector(32);
                    data_axi_fifo.push(data_ref);
                    addr_axi_fifo.push(addr_ref);
                    s0_axi_tdata  <= data_ref;
                    s0_axi_tlast  <= '1' when cnt = 1 else '0';
                    addr_ref      := addr_ref + 4;
                    cnt           := cnt - 1;
                end if;
            end if;
        end if;
    end process;

end architecture sim;

-- vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab textwidth=0:

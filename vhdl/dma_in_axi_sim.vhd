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


entity dma_in_sim is
    generic(
        n:       positive := 100; -- test vectors
        max_len: positive := 100  -- maximum length of transfer
    );
end entity dma_in_sim;

architecture sim of dma_in_sim is

    signal aclk:           std_ulogic;
    signal aresetn:        std_ulogic;
    signal start:          std_ulogic;
    signal addr:           std_ulogic_vector(31 downto 0);
    signal len:            std_ulogic_vector(29 downto 0);
    signal eot:            std_ulogic;
    signal resp:           std_ulogic_vector(1 downto 0);
    signal m0_axi_araddr:  std_ulogic_vector(31 downto 0);
    signal m0_axi_arvalid: std_ulogic;
    signal m0_axi_arready: std_ulogic;
    signal m0_axi_rdata:   std_ulogic_vector(31 downto 0);
    signal m0_axi_rresp:   std_ulogic_vector(1 downto 0);
    signal m0_axi_rvalid:  std_ulogic;
    signal m0_axi_rready:  std_ulogic;
    signal m1_axi_tvalid:  std_ulogic;
    signal m1_axi_tready:  std_ulogic;
    signal m1_axi_tdata:   std_ulogic_vector(31 downto 0);
    signal m1_axi_tlast:   std_ulogic;

    signal resp_okay:      boolean;

    subtype w32 is std_ulogic_vector(31 downto 0);
    package w32_fifo_pkg is new common.soft_fifo_pkg generic map(t => w32);
    shared variable axi_fifo: w32_fifo_pkg.soft_fifo;

begin

    u0: entity work.dma_in(rtl)
    port map(
        aclk           => aclk,
        aresetn        => aresetn,
        start          => start,
        addr           => addr,
        len            => len,
        eot            => eot,
        resp           => resp,
        m0_axi_araddr  => m0_axi_araddr,
        m0_axi_arvalid => m0_axi_arvalid,
        m0_axi_arready => m0_axi_arready,
        m0_axi_rdata   => m0_axi_rdata,
        m0_axi_rresp   => m0_axi_rresp,
        m0_axi_rvalid  => m0_axi_rvalid,
        m0_axi_rready  => m0_axi_rready,
        m1_axi_tvalid  => m1_axi_tvalid,
        m1_axi_tready  => m1_axi_tready,
        m1_axi_tdata   => m1_axi_tdata,
        m1_axi_tlast   => m1_axi_tlast
    );

    process
    begin
        aclk <= '0';
        wait for 1 ns;
        aclk <= '1';
        wait for 1 ns;
    end process;

    -- memory emulator
    process(aclk)
        variable r:   rnd_generator;
        variable req: natural;
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                m0_axi_arready <= '0';
                m0_axi_rvalid  <= '0';
                m0_axi_rdata   <= (others => '0');
                m0_axi_rresp   <= axi_resp_okay;
                req            := 0;
            else
                m0_axi_arready <= r.get_std_ulogic;
                if m0_axi_arvalid = '1' and m0_axi_arready = '1' then
                    req := req + 1;
                end if;
                if m0_axi_rvalid = '1' and m0_axi_rready = '1' then
                    req := req - 1;
                    m0_axi_rvalid <= '0';
                    axi_fifo.push(m0_axi_rdata);
                end if;
                if req > 0 and (m0_axi_rvalid = '0' or m0_axi_rready = '1') and r.get_boolean then
                    m0_axi_rvalid <= '1';
                    m0_axi_rdata  <= r.get_std_ulogic_vector(32);
                    m0_axi_rresp  <= axi_resp_okay when resp_okay else r.get_std_ulogic_vector(2);
                end if;
            end if;
        end if;
    end process;

    -- axi lite stability checker
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
                if m0_axi_arvalid = '1' then
                    check_ref(m0_axi_araddr(1 downto 0), "00", "m0_axi_araddr");
                end if;
                case state is
                    when idle =>
                        if m0_axi_arvalid = '1' and m0_axi_arready = '0' then
                            addr_ref := m0_axi_araddr;
                            state    := check;
                        end if;
                    when check =>
                        check_ref(m0_axi_arvalid, '1', "m0_axi_arvalid");
                        check_ref(m0_axi_araddr, addr_ref, "m0_axi_araddr");
                        if m0_axi_arready = '1' then
                            state := idle;
                        end if;
                end case;
            end if;
        end if;
    end process;

    -- axi stream stability checker
    process(aclk)
        type state_t is (idle, check);
        variable state:    state_t;
        variable data_ref: std_ulogic_vector(31 downto 0);
        variable last_ref: std_ulogic;
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                state    := idle;
                data_ref := (others => '0');
                last_ref := '0';
            else
                case state is
                    when idle =>
                        if m1_axi_tvalid = '1' and m1_axi_tready = '0' then
                            data_ref := m1_axi_tdata;
                            last_ref := m1_axi_tlast;
                            state    := check;
                        end if;
                    when check =>
                        check_ref(m1_axi_tvalid, '1', "m1_axi_tvalid");
                        check_ref(m1_axi_tdata, data_ref, "m1_axi_tdata");
                        check_ref(m1_axi_tlast, last_ref, "m1_axi_tlast");
                        if m1_axi_tvalid = '1' then
                            state := idle;
                        end if;
                end case;
            end if;
        end if;
    end process;

    -- cpu emulator, resp and m1_axi_tlast checker
    process
        variable r:        rnd_generator;
        variable resp_ref: std_ulogic_vector(1 downto 0);
    begin
        aresetn <= '0';
        start   <= '0';
        addr    <= (others => '0');
        len     <= (others => '0');
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
            len   <= to_stdulogicvector(r.get_integer(1, max_len), 30);
            start <= '1';
            wait until rising_edge(aclk);
            start <= '0';
            loop
                if m0_axi_rvalid = '1' and m0_axi_rready = '1' and m0_axi_rresp /= axi_resp_okay then
                    resp_ref := m0_axi_rresp;
                end if;
                wait until rising_edge(aclk);
                exit when eot = '1';
            end loop;
            check_ref(resp, resp_ref, "resp");
            check_ref(m1_axi_tlast, '1', "m1_axi_tlast");
        end loop;
        pass;
    end process;

    -- axi stream slave data checker
    process(aclk)
        variable r: rnd_generator;
        variable data_ref: w32;
    begin
        if rising_edge(aclk) then
            if aresetn = '0' then
                m1_axi_tready <= '0';
                data_ref      := (others => '0');
            else
                m1_axi_tready <= r.get_std_ulogic;
                if m1_axi_tvalid = '1' and m1_axi_tready = '1' then
                    data_ref := axi_fifo.pop;
                    check_ref(m1_axi_tdata, data_ref, "m1_axi_tdata");
                end if;
            end if;
        end if;
    end process;

end architecture sim;

-- vim: set tabstop=4 softtabstop=4 shiftwidth=4 expandtab textwidth=0:

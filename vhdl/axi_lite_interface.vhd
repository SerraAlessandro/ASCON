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

--library common;
--use common.axi_pkg.all;

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
constant axi_resp_okay:   std_ulogic_vector(1 downto 0) := "00";
constant axi_resp_exokay: std_ulogic_vector(1 downto 0) := "01";
constant axi_resp_slverr: std_ulogic_vector(1 downto 0) := "10";
constant axi_resp_decerr: std_ulogic_vector(1 downto 0) := "11";
signal status: std_ulogic_vector(31 downto 0);
signal ctrl: std_ulogic_vector(31 downto 0);
signal add: integer range 0 to 1023;
signal dma_in_busy, dma_out_busy: std_ulogic;
signal tag_reg: std_ulogic_vector(127 downto 0);

type state is (idle,resp1,resp2);
signal state_r,state_w: state;

type statet is (idle, resp);
signal state_t: statet;

begin




-- CPU reads from registers
	process(aclk)
	variable add: integer range 0 to 1023;
	begin
		if rising_edge(aclk) then
			if aresetn = '0' then
				state_r <= idle;
				s0_axi_arready <= '0';
				s0_axi_rvalid <= '0';
			
			else
				case state_r is

					when idle =>
						if s0_axi_arvalid = '1' then
							state_r <= resp1;
						else
							state_r <= idle;
						end if;

						s0_axi_arready <= '0';
						s0_axi_rvalid <= '0';

					when resp1 =>
						if s0_axi_rready = '1' then
							state_r <= idle;
						else
							state_r <= resp2;
						end if;

						s0_axi_arready <= '1';
						s0_axi_rvalid <= '1';
						add := to_integer(s0_axi_araddr(11 downto 2));
						if s0_axi_araddr(1 downto 0) /= "00" then
							s0_axi_rresp <= axi_resp_slverr;
						elsif add >= 17 then 
							s0_axi_rresp <= axi_resp_decerr;
						else
							s0_axi_rresp <= axi_resp_okay;
							if (add >= 0 and add <= 3) then
								s0_axi_rdata <= key((32*(add + 1)-1) downto 32*(add));
							elsif (add >= 4 and add <= 7) then
								s0_axi_rdata <= nonce((32*(add -3)-1) downto 32*(add-4));
							elsif (add >= 8 and add <= 11) then
								s0_axi_rdata <= tag_reg((32*(add -7)-1) downto 32*(add-8));
							elsif add = 12 then
								s0_axi_rdata <= addr_in(31 downto 2) & "00";
							elsif add = 13 then
								s0_axi_rdata <= "00" & len_in;
							elsif add = 14 then
								s0_axi_rdata <= addr_out(31 downto 2) & "00";
							elsif add = 15 then
								s0_axi_rdata <= ctrl;
							else
								s0_axi_rdata <= status;
							end if;
						end if;

					when resp2 =>
						if s0_axi_rready = '1' then
							state_r <= idle;
						else
							state_r <= resp2;
						end if;

						s0_axi_arready <= '0';
						s0_axi_rvalid <= '1';

				end case;
			end if;
		end if;
	end process;


	-- CPU writes inside registers
	process(aclk)
	variable add: integer range 0 to 1023;
	begin
		if rising_edge(aclk) then
			if aresetn = '0' then
				state_w <= idle;
				ctrl <= (others => '0');
				status <= (others => '0');
				key <= (others => '0');
				nonce <= (others => '0');
				s0_axi_awready <= '0';
				s0_axi_wready <= '0';
				s0_Axi_bvalid <= '0';
				addr_in <= (others => '0');
				len_in <= (others => '0');
				addr_out <= (others => '0');
				start_in <= '0';
				start_out <= '0';
				
			else
				
				case state_w is

					when idle =>
						if s0_axi_awvalid = '1' and s0_axi_wvalid = '1' then 
							state_w <= resp1;
						else
							state_w <= idle;
						end if;

						s0_axi_awready <= '0';
						s0_axi_wready <= '0';
						s0_Axi_bvalid <= '0';

					when resp1 =>
						if s0_axi_bready = '1' then 
							state_w <= idle;
						else
							state_w <= resp2;
						end if;

						s0_axi_awready <= '1';
						s0_axi_wready <= '1';
						s0_axi_bvalid <= '1';
						add := to_integer(s0_axi_awaddr(11 downto 2));
						if s0_axi_awaddr(1 downto 0) /= "00" or (add >= 8 and add <= 11) then
							s0_axi_bresp <= axi_resp_slverr;
						elsif add >= 17 then
							s0_axi_bresp <= axi_resp_decerr;
						else
							s0_axi_bresp <= axi_resp_okay;
							if (add >= 0 and add <= 3) then
								key((32*(add + 1)-1) downto 32*(add)) <= s0_axi_wdata;
							elsif (add >= 4 and add <= 7) then
								nonce((32*(add -3)-1) downto 32*(add-4)) <= s0_axi_wdata;
							elsif add = 12 then
								addr_in <= s0_axi_wdata(31 downto 2) & "00";
							elsif add = 13 then
								len_in(29 downto 0) <= s0_axi_wdata(29 downto 0);
							elsif add = 14 then
								addr_out <= s0_axi_wdata(31 downto 2) & "00";
							elsif add = 15 then
								ctrl <= "000000000000000000000000000000" & s0_axi_wdata(1 downto 0);
							else
								status(4 downto 1) <= status(4 downto 1) and (not(s0_axi_wdata(4 downto 1)));
								
							end if;
						end if;

					when resp2 =>
						if s0_axi_bready = '1' then
							state_w <= idle;
						else
							state_w <= resp2;
						end if;
						
						

						s0_axi_awready <= '0';
						s0_axi_wready <= '0';
						s0_axi_bvalid <= '1';						
							

				end case;

				if ctrl(0) = '1' then
					if dma_in_busy = '0' then
						start_in <= '1';
						status(0) <= '1';
					end if;
					ctrl(0) <= '0';
				else
					start_in <= '0';
					if eot_out = '1' then
						status(0) <= '0';
					end if;
				end if;
					if ctrl(1) = '1' then
					if dma_out_busy = '0' then
						start_out <= '1';
					end if;
					
					ctrl(1) <= '0';
				else
					start_out <= '0';
				end if;

				if eot_in = '1' then
					status(2 downto 1) <= resp_in;
				end if;

				if eot_out = '1' then
					status(4 downto 3) <= resp_out;
				end if;
			end if;
		end if;
	end process;

	process(aclk)
	begin
		if rising_edge(aclk) then
			if aresetn = '0' then
				dma_in_busy <= '0';
				dma_out_busy <= '0';
			else
				if dma_in_busy = '0' then
					if start_in = '1' then
						dma_in_busy <= '1';
					else
						dma_in_busy <= '0';
					end if;
				else
					if eot_in = '1' then
						dma_in_busy <= '0';
					else
						dma_in_busy <= '1';
					end if;
				end if;
				
				
				if dma_out_busy = '0' then
					if start_out = '1' then
						dma_out_busy <= '1';
					else
						dma_out_busy <= '0';
					end if;
				else
					if eot_out = '1' then
						dma_out_busy <= '0';
					else
						dma_out_busy <= '1';
					end if;
				end if;
			end if;
		end if;
	end process;

	process(aclk)
	begin
		if rising_edge(aclk) then
			if aresetn = '0' then
				tag_reg <= (others => '0');
				state_t <= idle;
				tag_ready <= '0';
			else
				case state_t is
					when idle =>
						if tag_valid = '1' then
							state_t <= resp;
						else
							state_t <= idle;
						end if;
						tag_ready <= '0';

					when resp =>
						state_t <= idle;

						tag_ready <= '1';
						tag_reg <= tag;
				end case;
			end if;


		end if;
	end process;
			


end architecture rtl;
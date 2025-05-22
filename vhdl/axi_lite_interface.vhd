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
signal status: std_ulogic_vector(31 downto 0);
signal ctrl: std_ulogic_vector(31 downto 0);

type state is (idle,resp1);
signal state_r,state_w : state;

begin

-- CPU reads from registers
	process(aclk)
	variable add: integer range 0 to 1023;
	begin
		if rising_edge(aclk) then
			if aresetn = '0' then
				state_r <= idle;
			else
				case state_r is
					when idle =>
						s0_axi_arready <= '0';
						s0_axi_rvalid <= '0';
						if s0_axi_arvalid = '1' then
							s0_axi_arready <= '1';
							s0_axi_rvalid <= '1';
							add := to_integer(s0_axi_araddr(11 downto 2));
							if s0_axi_araddr(1 downto 0) /= "00" then
								s0_axi_rresp <= axi_resp_slverr;
							--elsif add >= 17 then
								--s0_axi_rresp <= axi_resp_decerr;
							else
								s0_axi_rresp <= axi_resp_okay;
								if (add >= 0 and add <= 3) then
									s0_axi_rdata <= key((32*(add + 1)-1) downto 32*(add));
								elsif (add >= 4 and add <= 7) then
									s0_axi_rdata <= nonce((32*(add -3)-1) downto 32*(add-4));
								elsif (add >= 8 and add <= 11) then
									s0_axi_rdata <= tag((32*(add -7)-1) downto 32*(add-8));
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
							state_r <= resp1;
						end if;
	
					when resp1 =>
						if s0_axi_rready = '1' then
							s0_axi_arready <= '0';
							s0_axi_rvalid <= '0';
	                           			state_r <= idle;
						else
							s0_axi_arready <= '0';
							s0_axi_rvalid <= '1';
							
	                       			end if;

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
			else
				ctrl(1 downto 0) <= "00"; -- reset START_IN and START_OUT
				status(2 downto 1) <= resp_in;
				status(4 downto 3) <= resp_out;
				case state_w is
					when idle =>
						s0_axi_awready <= '0';
						s0_axi_wready <= '0';
						s0_Axi_bvalid <= '0';
						
						if s0_axi_awvalid = '1' and s0_axi_wvalid = '1' then 
							
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
									len_in <= s0_axi_wdata(29 downto 0);
								elsif add = 14 then
									addr_out <= s0_axi_wdata(31 downto 2) & "00";
								elsif add = 15 then
									ctrl(1 downto 0) <= s0_axi_wdata(1 downto 0);
								else
									status(4 downto 1) <= "0000";
								end if;

							end if;

							state_w <= resp1;
						end if;
			
					when resp1 =>
						s0_axi_awready <= '0';
						s0_axi_wready <= '0';
						if s0_axi_bready = '1' then
							s0_axi_bvalid <= '0';
	                           			state_w <= idle;
						else
							s0_axi_bvalid <= '1';
	                       			end if;
				end case;
			end if;
		end if;
	end process;

	process(aclk)
	begin
		if ctrl(0) = '1' then
			status(0) <= '1';
		end if;
		
		if eot_out = '1' then
			status(0) <= '0';
		end if;
	end process;
			


end architecture rtl;

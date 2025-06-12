library IEEE;
use IEEE.std_logic_1164.all;


entity tb_axi_lite_interface is
end tb_axi_lite_interface;

ARCHITECTURE Behavior OF tb_axi_lite_interface IS

component axi_lite_interface is
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

end component;

signal aclk: std_ulogic := '1';
signal aresetn: std_ulogic;
signal s0_axi_araddr: std_ulogic_vector(11 downto 0);
signal s0_axi_arvalid: std_ulogic;
signal s0_axi_arready: std_ulogic;
signal s0_axi_awaddr: std_ulogic_vector(11 downto 0);
signal s0_axi_awvalid: std_ulogic;
signal s0_axi_awready: std_ulogic;
signal s0_axi_wdata: std_ulogic_vector(31 downto 0);
signal s0_axi_wstrb: std_ulogic_vector(3 downto 0);
signal s0_axi_wvalid: std_ulogic;
signal s0_axi_wready: std_ulogic;
signal s0_axi_rdata: std_ulogic_vector(31 downto 0);
signal s0_axi_rresp: std_ulogic_vector(1 downto 0);
signal s0_axi_rvalid: std_ulogic;
signal s0_axi_rready: std_ulogic;
signal s0_axi_bresp: std_ulogic_vector(1 downto 0);
signal s0_axi_bvalid: std_ulogic;
signal s0_axi_bready: std_ulogic;
signal start_in: std_ulogic;
signal addr_in: std_ulogic_vector(31 downto 0);
signal len_in: std_ulogic_vector(29 downto 0);
signal eot_in: std_ulogic;
signal resp_in: std_ulogic_vector(1 downto 0);
signal start_out: std_ulogic;
signal addr_out: std_ulogic_vector(31 downto 0);
signal eot_out: std_ulogic;
signal resp_out: std_ulogic_vector(1 downto 0);
signal key: std_ulogic_vector(127 downto 0);
signal nonce: std_ulogic_vector(127 downto 0);
signal tag_valid: std_ulogic;
signal tag_ready: std_ulogic;
signal tag: std_ulogic_vector(127 downto 0);


begin




ck_process: PROCESS
 BEGIN
 wait for 10 ns;
 aclk <= NOT aclk;
 END PROCESS;

aresetn <= '0', '1' after 100 ns;

s0_axi_wdata <= x"10101010", x"32323232" after 299 ns, x"54545454" after 399 ns, x"76767676" after 499 ns, x"98989898" after 599 ns, x"babababa" after 699 ns, x"dcdcdcdc" after 799 ns, x"efefefef" after 899 ns, x"00000001" after 1500 ns, x"00000002" after 2099 ns, x"00000008" after 2999 ns;
s0_axi_awvalid <= '0','1' after 199 ns, '0' after 241 ns, '1' after 299 ns, '0' after 310 ns, '1' after 399 ns, '0' after 410 ns, '1' after 499 ns, '0' after 510 ns, '1' after 599 ns, '0' after 610 ns, '1' after 699 ns, '0' after 710 ns, '1' after 799 ns, '0' after 810 ns, '1' after 899 ns, '0' after 910 ns, '1' after 1499 ns, '0' after 1510 ns, '1' after 2099 ns, '0' after 2110 ns, '1' after 2999 ns, '0' after 3010 ns;
s0_axi_awaddr <= "000000000000", "000000000100" after 299 ns, "000000001000" after 399 ns, "000000001100" after 499 ns, "000000010000" after 599 ns, "000000010100" after 699 ns, "000000011000" after 799 ns, "000000011100" after 899 ns, "000000100000" after 999 ns, "000000111100" after 1499 ns, "000001000000" after 2999 ns;
s0_axi_wvalid <= '0','1' after 199 ns, '0' after 240 ns, '1' after 299 ns, '0' after 310 ns, '1' after 399 ns, '0' after 410 ns, '1' after 499 ns, '0' after 510 ns, '1' after 599 ns, '0' after 610 ns, '1' after 699 ns, '0' after 710 ns, '1' after 799 ns, '0' after 810 ns, '1' after 899 ns, '0' after 910 ns, '1' after 1499 ns, '0' after 1510 ns, '1' after 2099 ns, '0' after 2110 ns, '1' after 2999 ns, '0' after 3010 ns;
s0_axi_bready <= '0','1' after 199 ns, '0' after 240 ns, '1' after 299 ns, '0' after 330 ns, '1' after 399 ns, '0' after 430 ns, '1' after 499 ns, '0' after 530 ns, '1' after 599 ns, '0' after 630 ns, '1' after 699 ns, '0' after 730 ns, '1' after 799 ns, '0' after 830 ns, '1' after 899 ns, '0' after 930 ns, '1' after 1599 ns, '0' after 1610 ns, '1' after 2099 ns, '0' after 2130 ns, '1' after 2999 ns, '0' after 3030 ns;
eot_in <= '0', '1' after 1999 ns, '0' after 2010 ns;
eot_out <= '0', '1' after 2499 ns, '0' after 2510 ns;
resp_in <= "00";
resp_out <= "01";
tag <= x"12345678123456781234567812345678";
tag_valid <= '0', '1' after 3999 ns, '0' after 4010 ns;


--s0_axi_arvalid <= '0', '1' after 699 ns, '0' after 1860 ns, '1' after 2100 ns, '0' after 2300 ns, '1' after 3200 ns, '0' after 3500 ns;
--s0_axi_rready <= '0', '1' after 699 ns, '0' after 1860 ns, '1' after 2100 ns, '0' after 2300 ns, '1' after 3200 ns, '0' after 3500 ns;
s0_axi_arvalid <= '0', '1' after 699 ns, '0' after 1860 ns, '1' after 2100 ns, '0' after 3000 ns, '1' after 3020 ns, '0' after 3040 ns, '1' after 3100 ns, '0' after 3120 ns, '1' after 3200 ns, '0' after 3240 ns, '1' after 3300 ns, '0' after 3310 ns, '1' after 3360 ns, '0' after 3410 ns, '1' after 3430 ns, '0' after 3560 ns;
s0_axi_rready <= '0', '1' after 699 ns, '0' after 1860 ns, '1' after 2100 ns, '0' after 3000 ns, '1' after 3020 ns, '0' after 3040 ns, '1' after 3100 ns, '0' after 3120 ns, '1' after 3200 ns, '0' after 3240 ns, '1' after 3300 ns, '0' after 3310 ns, '1' after 3360 ns, '0' after 3410 ns, '1' after 3430 ns, '0' after 3560 ns;
s0_axi_araddr <= "000000001100";
s0_axi_wstrb <= "1111";



interface: axi_lite_interface port map (	aclk => aclk,
					        aresetn => aresetn,
					        s0_axi_araddr => s0_axi_araddr,
					        s0_axi_arvalid => s0_axi_arvalid,
					        s0_axi_arready => s0_axi_arready,
					        s0_axi_awaddr => s0_axi_awaddr,
					        s0_axi_awvalid => s0_axi_awvalid,
					        s0_axi_awready => s0_axi_awready,
					        s0_axi_wdata => s0_axi_wdata,
					        s0_axi_wstrb => s0_axi_wstrb,
					        s0_axi_wvalid => s0_axi_wvalid,
					        s0_axi_wready => s0_axi_wready,
					        s0_axi_rdata => s0_axi_rdata,
					        s0_axi_rresp => s0_axi_rresp,
					        s0_axi_rvalid => s0_axi_rvalid,
					        s0_axi_rready => s0_axi_rready,
					        s0_axi_bresp => s0_axi_bresp,
					        s0_axi_bvalid => s0_axi_bvalid,
					        s0_axi_bready => s0_axi_bready,
						start_in => start_in,
						addr_in => addr_in,
					        len_in => len_in,
					        eot_in => eot_in,
						resp_in => resp_in,
						start_out => start_out,
						addr_out => addr_out,
					 	eot_out => eot_out,
						resp_out => resp_out,
						key => key,
						nonce => nonce,
						tag_valid => tag_valid,
						tag_ready => tag_ready,
						tag => tag
		);
			
end behavior;



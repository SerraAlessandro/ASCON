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

entity crypto_core is
  port(
    aclk:       in  std_ulogic;
    aresetn:    in  std_ulogic;
    tvalid_in:  in  std_ulogic;
    tready_in:  out std_ulogic;
    tdata_in:   in  std_ulogic_vector(31 downto 0);
    tlast_in:   in  std_ulogic;
    tvalid_out: out std_ulogic;
    tready_out: in  std_ulogic;
    tdata_out:  out std_ulogic_vector(31 downto 0);
    tlast_out:  out std_ulogic;
    key:        in  std_ulogic_vector(127 downto 0);
    nonce:      in  std_ulogic_vector(127 downto 0);
    tag_valid:  out std_ulogic;
    tag_ready:  in  std_ulogic;
    tag:        out std_ulogic_vector(127 downto 0)
  );
end entity crypto_core;

architecture rtl of crypto_core is
signal slave_out: std_ulogic_vector(127 downto 0);
signal master_in: std_ulogic_vector(127 downto 0);
signal s0_data_ack: std_ulogic;		
signal s0_data_req: std_ulogic;		
signal s0_new_data: std_ulogic;		
signal s0_last_data: std_ulogic;		
signal s0_no_data: std_ulogic;		
signal m0_data_ready: std_ulogic;		
signal m0_new_data: std_ulogic;		
signal m0_last_data: std_ulogic;

begin

ascon: entity work.ASCON_FSM(rtl)
	generic map 	( n_perm => 1
	)
	port map(	key			=> key,
			nonce			=> nonce,
			axi_stream_input	=> slave_out,
			clk			=> aclk,
			rstn			=> aresetn,
			s0_data_ack		=> s0_data_ack,
			s0_data_req		=> s0_data_req,
			s0_new_data		=> s0_new_data,
			s0_last_data		=> s0_last_data,
			s0_no_data		=> s0_no_data,
			m0_data_ready		=> m0_data_ready,
			m0_new_data		=> m0_new_data, 
			m0_last_data		=> m0_last_data,
			tag_valid		=> tag_valid,
			tag_ready		=> tag_ready,
			tag			=> tag,
			axi_stream_output	=> master_in
	);


axi_slave: entity work.axi_stream_slave(rtl)
	port map(	information		=> tdata_in,
			clk			=> aclk,
			tvalid			=> tvalid_in,
			tlast			=> tlast_in,
			data_ack		=> s0_data_ack,
			aresetn			=> aresetn,
			data_req		=> s0_data_req,
			info_128		=> slave_out,
			new_data		=> s0_new_data,
			last_data		=> s0_last_data,
			tready			=> tready_in,
			no_data			=> s0_no_data
	);

axi_master: entity work.axi_stream_master(rtl)
	port map(	info_128		=> master_in,
			new_data		=> m0_new_data,
			last_data		=> m0_last_data,
			tready			=> tready_out,
			clk			=> aclk,
			aresetn			=> aresetn,
			information		=> tdata_out,
			tvalid			=> tvalid_out,
			tlast			=> tlast_out,
			data_ready		=> m0_data_ready
	);


end architecture rtl;

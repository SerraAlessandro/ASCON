library IEEE;
use IEEE.std_logic_1164.all;

ENTITY tb_ASCON_fsm IS
	generic( n_perm : natural := 4);
	port(		key: out std_ulogic_vector(127 downto 0);
			nonce: out std_ulogic_vector(127 downto 0);
			axi_stream_input: out std_ulogic_vector(127 downto 0);
			clk: out std_ulogic;
			rstn: out std_ulogic;
			s0_data_ack: out std_ulogic;
			s0_data_req: out std_ulogic;
			s0_new_data: out std_ulogic;
			s0_last_data: out std_ulogic;
			s0_no_data: out std_ulogic;
			m0_data_ready: out std_ulogic;
			m0_new_data : out std_ulogic;
			m0_last_data: out std_ulogic;
			tag_valid: out std_ulogic;
			tag_ready: out std_ulogic;
			tag: out std_ulogic_vector(127 downto 0);
			axi_stream_output: out std_ulogic_vector(127 downto 0)
			);
END entity tb_ASCON_fsm;

ARCHITECTURE sim OF tb_ASCON_fsm IS

	
begin

ascon: entity work.ASCON_fsm(rtl)
	generic map( n_perm => n_perm)
	port map(	key => key,
			nonce => nonce,
			axi_stream_input => axi_stream_input,
			clk => clk,
			rstn => rstn,
			s0_data_ack => s0_data_ack,
			s0_data_req => s0_data_req,
			s0_new_data => s0_new_data,
			s0_last_data => s0_last_data,
			s0_no_data => s0_no_data,
			m0_data_ready => m0_data_ready,
			m0_new_data => m0_new_data,
			m0_last_data => m0_last_data,
			tag_valid => tag_valid,
			tag_ready => tag_ready,
			tag => tag,
			axi_stream_output => axi_stream_output
			);


key <= x"abc5472b56742bca3675cbef47956338";
nonce <= x"2c66b325ae354f7804658cdfe43645af";

--------------------------------------------------------------------------------
-- to test:
-- ad: 45bc627ad055be54fa4393fed679041245bc627ad055beb5fa4397fed9790a
-- pt: feb45ab41265432cde653dfeda543f4547658136513ad436778fedc9875430

axi_stream_input <= 	x"45bc627ad055be54fa4393fed6790412" after 510 ns,
			x"45bc627ad055beb5fa4397fed9790a01" after 2000 ns, 
			x"feb45ab41265432cde653dfeda543f45" after 2500 ns,
			x"47658136513ad436778fedc987543001" after 3000 ns;

s0_new_data <= '0', '1' after 730 ns, '0' after 800 ns, '1' after 2050 ns, '0' after 2100 ns, '1' after 2550 ns, '0' after 2600 ns, '1' after 3050 ns, '0' after 3100 ns, '1' after 3550 ns;
s0_last_data <= '0', '1' after 2000 ns, '0' after 2400 ns, '1' after 3000 ns;
s0_no_data <= '0';
m0_data_ready <= '0', '1' after 2100 ns;
tag_ready <= '0', '1' after 4700 ns;


-----------------------------------------------------------------------------------
---- to test:
---- ad: no ad
---- pt: feb45ab41265432cde653dfeda543f4547658136513ad436778fedc9875430

--axi_stream_input <= 	 x"feb45ab41265432cde653dfeda543f45" after 2500 ns,
--			x"47658136513ad436778fedc987543001" after 3000 ns;

--s0_new_data <= '0', '1' after 2550 ns, '0' after 2600 ns, '1' after 3050 ns, '0' after 3100 ns, '1' after 3550 ns;
--s0_last_data <= '0', '1' after 2000 ns, '0' after 2250 ns, '1' after 3000 ns;
--s0_no_data <= '1', '0' after 240 ns;
--m0_data_ready <= '0', '1' after 2100 ns;
--tag_ready <= '0', '1' after 4700 ns;

------------------------------------------------------------------------------------

rstn <= '1';

ck_process: PROCESS
 BEGIN
 clk <= '0';
 wait for 20 ns;
 clk <= '1';
 wait for 20 ns;
 END PROCESS;
 
end architecture sim;

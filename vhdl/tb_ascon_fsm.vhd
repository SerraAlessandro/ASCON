library IEEE;
use IEEE.std_logic_1164.all;

ENTITY tb_ASCON_fsm IS
	generic( n_perm : natural := 4);
	port(		key: in std_ulogic_vector(127 downto 0);
			nonce: in std_ulogic_vector(127 downto 0);
			axi_stream_input: in std_ulogic_vector(127 downto 0);
			clk: in std_ulogic;
			rstn: in std_ulogic;
			s0_data_ack: out std_ulogic;
			s0_data_req: out std_ulogic;
			s0_new_data: in std_ulogic;
			s0_last_data: in std_ulogic;
			s0_no_data: in std_ulogic;
			m0_data_ready: in std_ulogic;
			m0_new_data : out std_ulogic;
			m0_last_data: out std_ulogic;
			tag_valid: out std_ulogic;
			tag_ready: in std_ulogic;
			tag: out std_ulogic_vector(127 downto 0);
			axi_stream_output: out std_ulogic_vector(127 downto 0)
			);
END entity tb_ASCON_fsm;

ARCHITECTURE sim OF tb_ASCON_fsm IS

	

signal key: std_ulogic_vector(127 downto 0);
signal nonce: std_ulogic_vector(127 downto 0);
signal axi_stream_input: std_ulogic_vector(127 downto 0);
signal rstn,start: std_ulogic;
signal s0_data_ack: std_ulogic;
signal s0_data_req: std_ulogic;
signal s0_new_data: std_ulogic;
signal s0_last_data: std_ulogic;
signal s0_no_data: std_ulogic;
signal m0_data_ready: std_ulogic;
signal m0_new_data: std_ulogic;
signal m0_last_data: std_ulogic;
--axi_lite_output: out std_ulogic_vector(31 downto 0);
signal axi_stream_output: std_ulogic_vector(127 downto 0);
signal p128_out : std_ulogic_vector(127 downto 0);
signal p192_out : std_ulogic_vector(191 downto 0);
signal clk : std_ulogic := '0';
signal axi4_read: std_ulogic_vector(127 downto 0);
signal axi4_data_ready: std_ulogic;
signal axi4_read_data: std_ulogic;
signal axi4_data_write: std_ulogic;
signal axi4_data_ack: std_ulogic;
signal axi4_write: std_ulogic_vector(127 downto 0);
signal tag: std_ulogic_vector(127 downto 0);
signal tag_valid: std_ulogic;
signal tag_ready: std_ulogic;

 
begin

ascon: entity work.ASCON_fsm(rtl)
	generic map( n_perm => n_perm);
	port(		key => key,
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
			axi_stream_output => axi_stream_output);
			);


key <= x"abc5472b56742bca3675cbef47956338";
nonce <= x"2c66b325ae354f7804658cdfe43645af";

--------------------------------------------------------------------------------
---- to test:
---- ad: 45bc627ad055be54fa4393fed679041245bc627ad055beb5fa4397fed9790a
---- pt: feb45ab41265432cde653dfeda543f4547658136513ad436778fedc9875430
--
--axi_stream_input <= 	x"45bc627ad055be54fa4393fed6790412" after 510 ns,
--			x"45bc627ad055beb5fa4397fed9790a01" after 2000 ns, 
--			x"feb45ab41265432cde653dfeda543f45" after 2500 ns,
--			x"47658136513ad436778fedc987543001" after 3000 ns;
--
--s0_new_data <= '0', '1' after 730 ns, '0' after 800 ns, '1' after 2050 ns, '0' after 2100 ns, '1' after 2550 ns, '0' after 2600 ns, '1' after 3050 ns, '0' after 3100 ns, '1' after 3550 ns;
--s0_last_data <= '0', '1' after 2000 ns, '0' after 2250 ns, '1' after 3000 ns;
--s0_no_data <= '0';
--m0_data_ready <= '0', '1' after 2100 ns;
--tag_ready <= '0', '1' after 4700 ns;
--
--
--rstn <= '1';
--start <= '0', '1' after 30 ns, '0' after 5000 ns;

-----------------------------------------------------------------------------------
-- to test:
-- ad: no ad
-- pt: feb45ab41265432cde653dfeda543f4547658136513ad436778fedc9875430

axi_stream_input <= 	 x"feb45ab41265432cde653dfeda543f45" after 2500 ns,
			x"47658136513ad436778fedc987543001" after 3000 ns;

s0_new_data <= '0', '1' after 2550 ns, '0' after 2600 ns, '1' after 3050 ns, '0' after 3100 ns, '1' after 3550 ns;
s0_last_data <= '0', '1' after 2000 ns, '0' after 2250 ns, '1' after 3000 ns;
s0_no_data <= '1', '0' after 240 ns;
m0_data_ready <= '0', '1' after 2100 ns;
tag_ready <= '0', '1' after 4700 ns;

------------------------------------------------------------------------------------

rstn <= '1';
start <= '0', '1' after 30 ns, '0' after 5000 ns;


ck_process: PROCESS
 BEGIN
 wait for 20 ns;
 clk <= NOT clk;
 END PROCESS;
 
ascon : ASCON_fsm port map (	
				key => key,
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
				axi_stream_output => axi_stream_output);
end architecture sim;

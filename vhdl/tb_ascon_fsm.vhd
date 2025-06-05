library IEEE;
use IEEE.std_logic_1164.all;

ENTITY tb_ASCON_fsm IS
END tb_ASCON_fsm;

ARCHITECTURE behavior OF tb_ASCON_fsm IS
component ASCON_fsm is
	generic( n_perm : natural := 4);
	port(		axi4_read: in std_ulogic_vector(127 downto 0);
			axi_stream_input: in std_ulogic_vector(127 downto 0);
			clk,rst,start: in std_ulogic;
			axi4_data_ready: in std_ulogic;
			axi4_read_data: out std_ulogic;
			s0_data_ack: out std_ulogic;
			s0_data_req: out std_ulogic;
			s0_new_data: in std_ulogic;
			s0_last_data: in std_ulogic;
			s0_no_data: in std_ulogic;
			m0_data_ready: in std_ulogic;
			m0_new_data : out std_ulogic;
			m0_last_data: out std_ulogic;
			axi4_write: out std_ulogic_vector(127 downto 0);
			axi4_data_write: out std_ulogic;
			axi4_data_ack: in std_ulogic;
			p128_out: out std_ulogic_vector(127 downto 0);
			p192_out: out std_ulogic_vector(191 downto 0);
			axi_stream_output: out std_ulogic_vector(127 downto 0)
			);
end component;
signal key: std_ulogic_vector(127 downto 0);
signal nonce: std_ulogic_vector(127 downto 0);
signal axi_stream_input: std_ulogic_vector(127 downto 0);
signal rst,start: std_ulogic;
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

 
begin

axi4_read <= x"38639547EFCB7536CA2B74562B47C5AB" after 10 ns, x"AF4536E4DF8C6504784F35AE25B3662C" after 250 ns; 
axi4_data_ready <= '0', '1' after 70 ns, '0' after 110 ns, '1' after 280 ns;

--axi_stream_input <= 	x"120479D6FE9343FA54BE55D07A62BC45" after 510 ns,
--			x"120479D6FE9343FA54BE55D07A62BC45" after 1400 ns,
--			x"010A79D9FE9743FAB5BE55D07A62BC45" after 2350 ns, 
--			x"120479D6FE9343FA54BE55D07A62BC45" after 2800 ns,
--			x"120479D6FE9343FA54BE55D07A62BC45" after 3000 ns, 
--			x"010A79D9FE9743FAB5BE55D07A62BC45" after 3800 ns;

			          
--s0_new_data <= '0', '1' after 730 ns, '0' after 800 ns, '1' after 1450 ns, '0' after 1500 ns, '1' after 2050 ns, '0' after 2100 ns, '1' after 2550 ns, '0' after 2600 ns, '1' after 3050 ns, '0' after 3100 ns, '1' after 3550 ns;
--s0_last_data <= '0', '1' after 2850 ns, '0' after 2950 ns, '1' after 3900 ns;
--s0_no_data <= '0';
--m0_data_ready <= '0', '1' after 2100 ns;
--axi4_data_ack <= '0', '1' after 4700 ns;

--axi_stream_input <= 	x"120479D6FE9343FA54BE55D07A62BC45" after 510 ns,
--			x"010A79D9FE9743FAB5BE55D07A62BC45" after 2000 ns, 
--			x"120479D6FE9343FA54BE55D07A62BC45" after 2500 ns,
-- 
--			x"010A79D9FE9743FAB5BE55D07A62BC45" after 3280 ns;
--
--s0_new_data <= '0', '1' after 730 ns, '0' after 800 ns, '1' after 1450 ns, '0' after 1500 ns, '1' after 2050 ns, '0' after 2100 ns, '1' after 2550 ns, '0' after 2600 ns, '1' after 3050 ns, '0' after 3100 ns, '1' after 3550 ns;
--s0_last_data <= '0', '1' after 2000 ns, '0' after 2250 ns, '1' after 3280 ns;
--s0_no_data <= '0';
--m0_data_ready <= '0', '1' after 2100 ns;
--axi4_data_ack <= '0', '1' after 4700 ns;

axi_stream_input <= 	x"120479D6FE9343FA54BE55D07A62BC45" after 510 ns,
			x"010A79D9FE9743FAB5BE55D07A62BC45" after 2000 ns, 
			x"120479D6FE9343FA54BE55D07A62BC45" after 2500 ns,
 
			x"010A79D9FE9743FAB5BE55D07A62BC45" after 3280 ns;

s0_new_data <= '0', '1' after 730 ns, '0' after 800 ns, '1' after 1450 ns, '0' after 1500 ns, '1' after 2050 ns, '0' after 2100 ns, '1' after 2550 ns, '0' after 2600 ns, '1' after 3050 ns, '0' after 3100 ns, '1' after 3550 ns;
s0_last_data <= '0', '1' after 2000 ns, '0' after 2250 ns, '1' after 3280 ns;
s0_no_data <= '0';
m0_data_ready <= '0', '1' after 2100 ns;
axi4_data_ack <= '0', '1' after 4700 ns;


rst <= '0';
start <= '0', '1' after 30 ns, '0' after 5000 ns;




ck_process: PROCESS
 BEGIN
 wait for 20 ns;
 clk <= NOT clk;
 END PROCESS;
 
ascon : ASCON_fsm port map (	
				axi4_write => axi4_write,
				axi4_data_write => axi4_data_write,
				axi4_data_Ack => axi4_data_ack,
				axi4_read => axi4_read,
				axi4_data_ready => axi4_data_ready,
				axi4_read_data => axi4_read_data,
				axi_stream_input => axi_stream_input,
				clk => clk,
				rst => rst,
				start => start,
				s0_data_ack => s0_data_ack,
				s0_data_req => s0_data_req,
				s0_new_data => s0_new_data,
				s0_last_data => s0_last_data,
				s0_no_data => s0_no_data,
				m0_data_ready => m0_data_ready,
				m0_new_data => m0_new_data,
				m0_last_data => m0_last_data,
				p128_out => p128_out,
				p192_out => p192_out,
				axi_stream_output => axi_stream_output);
end behavior;

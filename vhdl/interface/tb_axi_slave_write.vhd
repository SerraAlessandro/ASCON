
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library work;


entity tb_axi_slave_write is
end tb_axi_slave_write;

ARCHITECTURE Behavior OF tb_axi_slave_write IS
component axi_slave_write is 
	port(	information: in std_ulogic_vector(31 downto 0);
				clk,tvalid,tlast,data_ack: in std_ulogic;
				info_128: out std_ulogic_vector(127 downto 0);
				new_data,last_data,tready: out std_ulogic
				);
end component;

signal information: std_ulogic_vector(31 downto 0);
signal tvalid,tlast,data_ack: std_ulogic;
signal clk: std_logic:= '0';
signal info_128: std_ulogic_vector(127 downto 0);
signal new_data,last_Data,tready: std_ulogic;

begin

	ck_process: PROCESS
	BEGIN
		wait for 20 ns;
		clk <= NOT clk;
	END PROCESS;

	--tvalid <= '0', '1' after 100 ns, '0' after 130 ns, '1' after 300 ns, '0' after 330 ns, '1' after 360 ns, '0' after 390 ns, '1' after 500 ns, '0' after 530 ns;
	tvalid <= '0', '1' after 100 ns, '0' after 170 ns, '1' after 300 ns, '0' after 330 ns ;
	information <= x"47956338", x"3675cbef" after 150 ns, x"56742bca" after 350 ns, x"abc5472b" after 460 ns;
	tlast <= '0', '1' after 300 ns, '0' after 330 ns;
	data_ack <= '0';
	
	axi: axi_slave_write port map ( information	=>	information,
												clk => clk,
												tvalid => tvalid,
												tlast => tlast,
												data_ack => data_ack,
												info_128 => info_128,
												new_data => new_data,
												last_data => last_data,
												tready => tready);
 end behavior;
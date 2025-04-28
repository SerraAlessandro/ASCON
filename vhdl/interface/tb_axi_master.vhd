library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library work;


entity tb_axi_master is
end tb_axi_master;

ARCHITECTURE Behavior OF tb_axi_master IS
component axi_master is 
	port(	info_128: in std_ulogic_vector(127 downto 0);
			new_data,last_data,tready,clk: in std_ulogic;
			information: out std_ulogic_vector(31 downto 0);
			tvalid,tlast,data_ready: out std_ulogic
			);
end component;

signal information: std_ulogic_vector(31 downto 0);
signal tvalid,tlast,data_ready: std_ulogic;
signal clk: std_logic:= '0';
signal info_128: std_ulogic_vector(127 downto 0);
signal new_data,last_Data,tready: std_ulogic;

begin

	ck_process: PROCESS
	BEGIN
		wait for 20 ns;
		clk <= NOT clk;
	END PROCESS;

	info_128 <= x"54659801765815477890abc545defe38", x"12cd456e781093abfedc34517e5b090a" after 500 ns;
	last_data <= '0', '1' after 500 ns;
	new_data <= '1', '0' after 100 ns, '1' after 500 ns;
	tready <= '0', '1' after 100 ns, '0' after 130 ns, '1' after 180 ns, '0' after 240 ns, '1' after 300 ns, '0' after 330 ns, '1' after 360 ns;
	
	axi: axi_master port map ( information	=>	information,
												clk => clk,
												tlast => tlast,
												data_ready => data_ready,
												info_128 => info_128,
												new_data => new_data,
												last_data => last_data,
												tready => tready);
 end behavior;
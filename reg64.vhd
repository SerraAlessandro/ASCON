library IEEE;
use IEEE.std_logic_1164.all;

entity reg64 is
		port(	reg_in : in std_logic_vector(63 downto 0);
				clk,rst,reg_en: in std_logic;
				reg_out : out std_logic_vector (63 downto 0);
				reg_end : out std_logic
				);
end reg64;

ARCHITECTURE Behavior OF reg64 IS
begin
	process(clk)
	begin
		if(clk'event and clk = '1') then
			if(rst = '1') then
			reg_out <= x"0000000000000000";
			reg_end <= '0';
			elsif (reg_en='1') then
				reg_out <= reg_in;
			end if;
			reg_end <= reg_en;
		end if;
	end process;
end behavior;
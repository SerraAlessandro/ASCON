library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library work;


entity axi_stream_master is
	port(	info_128: in std_ulogic_vector(127 downto 0);
		new_data: in std_ulogic;
		last_data: in std_ulogic;
		tready: in std_ulogic;
		clk: in std_ulogic;
		aresetn: in std_ulogic;
		information: out std_ulogic_vector(31 downto 0);
		tvalid: out std_ulogic;
		tlast: out std_ulogic;
		data_ready: out std_ulogic
			);
end axi_stream_master;

ARCHITECTURE rtl OF axi_stream_master IS


signal count_e,count_r: std_ulogic;
signal reg_e,reg_r,reg_shift: std_ulogic;
signal ff_e,ff_r,last_flag: std_ulogic;
signal cnt: natural range 0 to 3;



type state_type is (idle,ready,data_rx,data_rx_last,data_valid,shift,valid_last,valid_nolast);
signal state : state_type;

begin

	shift_reg:  process (clk) is
	variable temp : std_ulogic_vector(127 downto 0);
	begin
		if (clk'event and clk='1') then
			if (reg_e ='1') then
				temp := info_128;
			elsif (reg_shift ='1') then
				temp := x"00000000" & temp(127 downto 32) ;
			end if;
			information <= temp(31 downto 0);
		end if;
	end process;
	
	counter: process(clk)
   begin
       if rising_edge(clk) then
           if (count_r = '1') then
               cnt <= 0;
           elsif (count_e = '1') then
					if (cnt < 3) then
						cnt <= cnt + 1;
					end if;
           end if;
       end if;
   end process;
	
	flipflop: process(clk)
	begin
		if(clk'event and clk = '1') then
			if ff_r= '1' then
				 last_flag <= '0';
			elsif ff_e = '1'  then
				 last_flag <= '1';
			end if;
		end if;
	end process;
	
	state_trans: process (clk)
	begin
		if (Clk'event and Clk = '1') then
			if (aresetn = '0') then
				state <= idle;
			else
				case state is
					when idle =>
						state <= ready;
						
					when ready =>
						if (new_data = '1') then
							if (last_data = '1') then
								state <= data_rx_last;
							else
								state <= data_rx;
							end if;
						else
							state <= ready;
						end if;
					
					when data_rx_last =>
						state <= data_valid;
					
					when data_rx =>
						state <= data_valid;
						
					when data_valid =>
						if (tready = '1') then
							state <= shift;
						else
							state <= data_valid;
						end if;
						
					when shift =>
						if (cnt = 2) then
							if (last_flag = '1') then
								state <= valid_last;
							else
								state <= valid_nolast;
							end if;
						else
							if (tready = '1') then
								state <= shift;
							else 
								state <= data_valid;
							end if;
						end if;
						
					when valid_last =>
						state <= idle;
	
					when valid_nolast =>
						state <= idle;
						
					when others =>
						state <= idle;
				end case;
			end if;
		end if;
	end process;


	output_p: process(state)
	begin
		reg_r <= '0';
		reg_e <= '0';
		reg_shift <= '0';
		ff_r <= '0';
		ff_e <= '1';
		count_e <= '0';
		count_r <= '0';
		tvalid <= '0';
		tlast <= '0';
		data_ready <= '0';

		case state is 
			when idle =>
				reg_r <= '1';
				count_r <= '1';
				ff_r <= '1';
			when ready =>
				data_ready <= '1';
			when data_rx_last =>
				ff_e <= '1';
				reg_e <= '1';
			when data_rx =>
				reg_e <= '1';
			when data_valid =>
				tvalid <= '1';
			when shift =>
				reg_shift <= '1';
				count_e <= '1';
				tvalid <= '1';
			when valid_last =>
				tlast <= '1';
				tvalid <= '1';
			when valid_nolast =>
				tvalid <= '1';
				
		end case;
	end process;

end rtl;


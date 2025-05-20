library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library work;


entity axi_stream_slave is
	port(	information: in std_ulogic_vector(31 downto 0);
		clk: in std_ulogic; 
		tvalid: in std_ulogic;
		tlast: in std_ulogic;
		data_ack: in std_ulogic;
		aresetn: in std_ulogic;
		data_req: in std_ulogic;
		info_128: out std_ulogic_vector(127 downto 0);
		new_data: out std_ulogic;
		last_data: out std_ulogic;
		tready: out std_ulogic;
		no_data: out std_ulogic
			);
end axi_stream_slave;

ARCHITECTURE rtl OF axi_stream_slave IS


signal count_e,count_r: std_ulogic;
signal shift_e,shift_r: std_ulogic;
signal contin: std_ulogic;
signal cnt: natural range 0 to 4;
signal info_delay: std_ulogic_vector(31 downto 0);
signal s_out: std_ulogic_vector(127 downto 0);


type state_type is (idle,ready,shift,shift_last,send,send_last,no_tx);
signal state : state_type;

begin

	input_reg: process(clk)
	begin
		if(clk'event and clk = '1') then
			info_delay <= information;
		end if;
	end process;

	shift_Reg: process(clk)
	begin
	  if(clk'event and clk = '1') then
			if shift_r = '1' then
				 s_out <= (others => '0');
			elsif shift_e = '1'  then
				 s_out <= info_delay & s_out(127 downto 32);
			end if;
	  end if;
	end process;

	
	
	counter: process(clk)
   begin
       if rising_edge(clk) then
           if (count_r = '1') then
               cnt <= 0;
           elsif (count_e = '1') then
					if (cnt < 4) then
						cnt <= cnt + 1;
					end if;
           end if;
       end if;
   end process;
	
	info_128 <= s_out;


	

	
	state_trans: process (clk)
	begin
		if (Clk'event and Clk = '1') then
			if (aresetn = '0') then
				state <= idle;
			else
				case state is
					when idle =>
						if (data_req = '1') then
							state <= ready;
						else
							state <= idle;
						end if;
						
					when ready =>
						if (tvalid = '1') then
							if (tlast = '1') then
								if ((cnt = 2 and contin = '1') or (cnt = 3 and contin = '0')) then
									state <= shift_last;
								else
									state <= no_tx;
								end if;
							else
								state <= shift;
							end if;
						else
							state <= ready;
						end if;
						
					when shift =>
						if (cnt = 3) then
							state <= send;
						else
							if (tvalid = '1') then
								if (tlast = '1') then
									if ((cnt = 2 and contin = '1') or (cnt = 3 and contin = '0')) then
										state <= shift_last;
									else
										state <= no_tx;
									end if;
								else
									state <= shift;
								end if;
							else
								state <= ready;
							end if;
						end if;
						
					when send =>
						if (data_ack = '1') then
							state <= idle;
						else
							state <= send;
						end if;
									
					when send_last =>
						if (data_ack = '1') then
							state <= idle;
						else
							state <= send_last;
						end if;
						
					when no_tx =>
						if (data_ack = '1') then
							state <= idle;
						else
							state <= no_tx;
						end if;
						
					when shift_last =>
						state <= send_last;
						
					when others =>
						state <= idle;
				end case;
			end if;
		end if;
	end process;


	output_p: process(state)
	begin
		new_data <= '0';
		last_data <= '0';
		count_e <= '0';
		count_r <= '0';
		shift_e <= '0';
		shift_r <= '0';
		tready <= '0';
		no_data <= '0';
		contin <= '0';

		case state is 
			when idle =>
				shift_r <= '1';
				count_r <= '1';
			when ready =>
				tready <= '1';
			when shift =>
				count_e <= '1';
				shift_e <= '1';
				tready <= '1';
				contin <= '1';
			when shift_last =>
				count_e <= '1';
				shift_e <= '1';
				tready <= '1';
			when send =>
				new_data <= '1';
			when send_last =>
				new_data <= '1';
				last_data <= '1';
			when no_tx =>
				no_data <= '1';
			
		end case;
	end process;

end rtl;


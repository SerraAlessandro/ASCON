library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library work;


entity axi_slave_write is
	port(	information: in std_ulogic_vector(31 downto 0);
			clk,tvalid,tlast,data_ack: in std_ulogic;
			info_128: out std_ulogic_vector(127 downto 0);
			new_data,last_data,tready: out std_ulogic
			);
end axi_slave_write;

ARCHITECTURE Behavior OF axi_slave_write IS


signal count_e,count_r: std_ulogic;
signal shift_e,shift_r: std_ulogic;
signal shift_sel: std_ulogic;
signal cnt: natural range 0 to 4;
signal s_in,info_delay: std_ulogic_vector(31 downto 0);
signal s_out: std_ulogic_vector(127 downto 0);


type state_type is (idle,ready,shift,shift_z,zero_fill,send,send_last,busy);
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
				 s_out <= s_in & s_out(127 downto 32);
			end if;
	  end if;
	end process;

	s_in <= info_delay when shift_sel = '1' else x"00000000";
	
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
			case state is
				when idle =>
					state <= ready;
					
				when ready =>
					if (tvalid = '1') then
						if (tlast = '1') then
							state <= shift_z;
						else
							state <= shift;
						end if;
					else
						state <= ready;
					end if;
					
				when shift_z =>
					if (cnt = 3) then
						state <= send_last;
					else
						state <= zero_fill;
					end if;
					
				when zero_fill =>
					if (cnt = 3) then
						state <= send_last;
					else
						state <= zero_fill;
					end if;
								
				when send_last =>
					state <= busy;
					
				when busy =>
					if (data_ack = '1') then
						state <= idle;
					else
						state <= busy;
					end if;
					
				when shift =>
					if (cnt = 3) then
						state <= send;
					else
						if (tvalid = '1') then
							if (tlast = '1') then
								state <= shift_z;
							else
								state <= shift;
							end if;
						else
							state <= ready;
						end if;
					end if;
					
				when send =>
					state <= busy;
					
				when others =>
					state <= ready;
			end case;
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
		shift_sel <= '1';
		tready <= '1';

		case state is 
			when idle =>
				shift_r <= '1';
				count_r <= '1';
				tready <= '0';
			when ready =>
			when shift =>
				count_e <= '1';
				shift_e <= '1';
			when shift_z =>
				count_e <= '1';
				shift_e <= '1';
			when send =>
				new_data <= '1';
				tready <= '0';
			when send_last =>
				new_data <= '1';
				tready <= '0';
				last_data <= '1';
			when busy =>
				tready <= '0';
			when zero_fill =>
				count_e <= '1';
				shift_e <= '1';
				shift_sel <= '0';
				tready <= '0';
		end case;
	end process;

end behavior;


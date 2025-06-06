library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.ascon_pkg.all;

entity ASCON_fsm is
	generic( n_perm : natural := 1);
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
end ASCON_fsm;

ARCHITECTURE rtl OF ASCON_fsm IS

constant rnd_c : natural := 12;

signal reg_en: std_ulogic;
signal state_in, state_out: ascon_state_t;
signal reg128_in,reg128_out: std_ulogic_vector(127 downto 0);
signal reg192_in,reg192_out: std_ulogic_vector(191 downto 0);
signal mux_p128: std_ulogic_vector(127 downto 0);
signal mux_p192: std_ulogic_vector(191 downto 0);
signal cnt: natural range 0 to (12/n_perm)-1;
signal rnd: natural range 0 to 12 := 12;

signal sel_128 : std_ulogic_vector(1 downto 0);
signal sel_192 : std_ulogic_vector(1 downto 0);
signal e_128 : std_ulogic;
signal e_192 : std_ulogic;
signal r_128 : std_ulogic;
signal r_192 : std_ulogic;
signal cnt_e : std_ulogic;
signal cnt_r : std_ulogic;
signal ff_ad_r : std_ulogic;
signal ff_ad_e : std_ulogic;
signal new_data_m : std_ulogic;
signal last_data_m : std_ulogic;
signal first_ad: std_ulogic;
signal sel_out_128: std_ulogic;
signal sel_out_192: std_ulogic;
signal ad_end: std_ulogic;
signal ad_last: std_ulogic;
signal key_rev: std_ulogic_vector(127 downto 0);
signal nonce_rev: std_ulogic_vector(127 downto 0);
signal axi_input_rev: std_ulogic_vector(127 downto 0);
signal axi_output_rev: std_ulogic_vector(127 downto 0);
signal tag_rev: std_ulogic_vector(127 downto 0);
signal p192_out: std_ulogic_vector(191 downto 0);
signal p128_out: std_ulogic_vector(127 downto 0);

type state_type is (	idle, 
			init_first, 
			init, 
			last_init, 
			ad_request, 
			ad_1_first, 
			ad_first,
			ad,
			last_ad,
			pl_request,
			end_init_noad,
			wait1,
			data_send,
			data_send_last,
			pl_first,
			pl,
			fin_first,
			fin,
			write_t,
			ad_ack,
			wait_pl
			);
							
signal state : state_type;



begin

	key_rev <= reverse_byte(key);
	nonce_rev <= reverse_byte(nonce);
	axi_input_rev <= reverse_byte(axi_stream_input);
	tag <= reverse_byte(tag_rev);
	axi_stream_output <= reverse_byte(axi_output_rev);
	
	
	
	reg_128: process(clk)
	begin
		if(clk'event and clk = '1') then
			if(r_128 = '1') then
				reg128_out <= (others => '0');
			elsif (e_128='1') then
				reg128_out <= reg128_in;
			else
				reg128_out <= reg128_out;
			end if;
		end if;
	end process reg_128;
	
	reg_192: process(clk)
	begin
		if(clk'event and clk = '1') then
			if(r_192 = '1') then
				reg192_out <= (others => '0');
			elsif (e_192 ='1') then
				reg192_out <= reg192_in;
			else
				reg192_out <= reg192_out;
			end if;
		end if;
	end process reg_192;
	
	ff_ad: process(clk)
	begin
		if(clk'event and clk = '1') then
			if(ff_ad_r = '1') then
				first_ad <= '0';
			elsif (ff_ad_e ='1') then
				first_ad <= '1';
			end if;
		end if;
	end process ff_ad;
	
	counter: process(clk)
   	begin
       	if rising_edge(clk) then
           	if (cnt_r = '1') then
               		cnt <= 0;
           	elsif (cnt_e = '1') then
			if (cnt < (12/n_perm)-1) then
				cnt <= cnt + 1;
			else
				cnt <= 0;
			end if;
           end if;
       end if;
   end process counter;
	
	reg128_in <= 	key_rev(63 downto 0) & x"00001000808c0001" when sel_128 = "11" else 
						mux_p128 when sel_128 = "00" else
						axi_input_rev xor mux_p128 when sel_128 = "01" else
						axi_input_rev xor mux_p128 when sel_128 = "10";
	
	reg192_in <= 	nonce_rev & key_rev(127 downto 64) when sel_192 = "11" else 
						(mux_p192(191 downto 191) xor ad_last) & mux_p192(190 downto 0) when sel_192 = "00" else
						(x"0000000000000000" & key_rev) xor mux_p192 when sel_192  = "10" else
						((key_rev(127 downto 127) xor ad_last) & key_rev(126 downto 0) & x"0000000000000000") xor mux_p192 when sel_192 = "01";
	
	axi_output_rev <= axi_input_rev xor mux_p128;

	tag_rev <= p192_out(191 downto 64) xor key_rev;
	
	state_in(0) <= reg128_out(63 downto 0);
	state_in(1) <= reg128_out(127 downto 64);
	state_in(2) <= reg192_out(63 downto 0);
	state_in(3) <= reg192_out(127 downto 64);
	state_in(4) <= reg192_out(191 downto 128);
	
	p128_out(63 downto 0) <= state_out(0);
	p128_out(127 downto 64) <= state_out(1);
	p192_out(63 downto 0) <= state_out(2);
	p192_out(127 downto 64) <= state_out(3);
	p192_out(191 downto 128) <= state_out(4);

	mux_p128 <= 	p128_out when sel_out_128 = '0' else
			reg128_out;

	mux_p192 <=	p192_out when sel_out_192 = '0' else
			reg192_out;
	
	
	
	permutations: process(state_in,rnd,cnt)
	begin
		state_out <= ascon_p_f_multiple(state_in,rnd,cnt,n_perm);
	end process;
	
	state_trans: process (clk)
	begin
		if (rstn = '0') then
			state <= idle;
		elsif (clk'event and clk = '1') then
			case state is 
				when idle =>
					state <= init_first;
					
				when init_first =>
					state <= init;
					
				when init =>
					if (cnt = (12/n_perm) -2) then
						state <= last_init;
					else
						state <= init;
					end if;
					
				when last_init =>
					state <= ad_request;
					
				when ad_request =>
					if (s0_no_data = '0') then
						if (s0_new_data = '1') then
							if (first_ad = '1') then
								state <= ad_1_first;
							else
								state <= ad_first;
							end if;
						else
							state <= ad_request;
						end if;
					else
						state <= end_init_noad;
					end if;

				when end_init_noad =>
					state <= pl_request;
					
				when ad_1_first =>
					state <= ad;
				
				when ad_first =>
					state <= ad;
				
				when ad =>
					if (cnt = (8/n_perm) - 2) then
						if (s0_last_data = '1') then
							state <= last_ad;
						else
							state <= ad_ack;
						end if;
					else
						state <= ad;
					end if;
				
				when ad_ack =>
					state <= ad_request;
				
				when last_ad =>
					state <= pl_request;
				
				when pl_request =>
					if (s0_new_data = '1') then
						if (m0_data_ready = '1') then
							if (s0_last_data = '1') then
								state <= data_send_last;
							else
								state <= data_send;
							end if;
						else
							state <= wait1;
						end if;
					else
						state <= pl_request;
					end if;
				
				when wait1 =>
					if (m0_data_ready = '1') then
						if (s0_last_data = '1') then
							state <= data_send_last;
						else
							state <= data_send;
						end if;
					else
						state <= wait1;
					end if;
				
				when data_send =>
					state <= pl_first;
				
				when pl_first =>
					state <= pl;
				
				when pl =>
					if (cnt = (8/n_perm) - 2) then
						state <= wait_pl;
					else
						state <= pl;
					end if;
				
				when wait_pl =>
					state <= pl_request;
				
				when data_send_last =>
					state <= fin_first;
				
				when fin_first =>
					state <= fin;
				
				when fin =>
					if (cnt = (12/n_perm) - 2) then
						state <= write_t;
					else
						state <= fin;
					end if;
				
				when write_t =>
					if (tag_ready = '1') then
						state <= idle;
					else
						state <= write_t;
					end if;
				
				when others =>
					state <= idle;
				
			end case;	
		end if;
	end process;
	

	
	output_p: process(state)
	begin
		sel_128 <= "00";
		sel_192 <= "00";
		e_128 <= '0';
		e_192 <= '0';
		r_128 <= '0';
		r_192 <= '0';
		cnt_e <= '0';
		cnt_r <= '0';
		s0_data_req <= '0';
		s0_data_ack <= '0';
		ff_ad_r <= '0';
		ff_ad_e <= '0';
		new_data_m <= '0';
		last_data_m <= '0';
		sel_out_128 <= '0';
		sel_out_192 <= '0';
		ad_last <= '0';
		rnd <= 12;
		tag_valid <= '0';	
		m0_new_data <= '0';
		m0_last_data <= '0';

		case state is
			when idle =>
				cnt_r <= '1';
				ff_ad_r <= '1';
				r_128 <= '1';
				r_192 <= '1';
				
			when init_first =>
				sel_128 <= "11";
				sel_192 <= "11";
				e_128 <= '1';
				e_192 <= '1';
				
			when init =>
				sel_128 <= "00";
				sel_192 <= "00";
				e_128 <= '1';
				e_192 <= '1';
				cnt_e <= '1';
				
			when last_init =>
				ff_ad_e <= '1';
				cnt_r <= '1';
				e_128 <= '1';
				e_192 <= '1';
				
			when ad_request =>
				s0_data_req <= '1';
				rnd <= 8;
				
			when ad_1_first =>
				rnd <= 8;
				sel_128 <= "10";
				sel_192 <= "01";
				e_128 <= '1';
				e_192 <= '1';
				ff_ad_r <= '1';
				sel_out_128 <= '1';
				sel_out_192 <= '1';
				
			when ad_first =>
				rnd <= 8;
				sel_128 <= "10";
				sel_192 <= "00";
				e_128 <= '1';
				e_192 <= '1';
				sel_out_128 <= '1';
				sel_out_192 <= '1';
				
			when ad =>
				rnd <= 8;
				sel_128 <= "00";
				sel_192 <= "00";
				e_128 <= '1';
				e_192 <= '1';
				cnt_e <= '1';
				
			when ad_ack =>
				rnd <= 8;
				cnt_r <= '1';
				s0_data_ack <= '1';
				e_128 <= '1';
				e_192 <= '1';
				
			when last_ad =>
				rnd <= 8;
				cnt_r <= '1';
				e_128 <= '1';
				e_192 <= '1';
				s0_data_ack <= '1';
				ad_last <= '1';
				
			when pl_request =>
				rnd <= 8;
				s0_data_req <= '1';
				cnt_r <= '1';

			when end_init_noad =>
				rnd <= 8;
				sel_128 <= "00";
				sel_192 <= "01";
				e_128 <= '1';
				e_192 <= '1';
				sel_out_128 <= '1';
				sel_out_192 <= '1';
				ad_last <= '1';			
				
			when wait1 =>
				rnd <= 8;

			when data_send =>
				rnd <= 8;
				m0_new_data <= '1';
				sel_out_128 <= '1';
				sel_out_192 <= '1';
				
				
			when pl_first =>
				rnd <= 8;
				sel_128 <= "01";
				sel_192 <= "00";
				e_128 <= '1';
				e_192 <= '1';
				sel_out_128 <= '1';
				sel_out_192 <= '1';
				
			when pl =>
				rnd <= 8;
				sel_128 <= "00";
				sel_192 <= "00";
				e_128 <= '1';
				e_192 <= '1';
				cnt_e <= '1';
		
			when wait_pl =>
				rnd <= 8;
				e_128 <= '1';
				e_192 <= '1';
				
			when data_send_last =>
				rnd <= 8;
				m0_new_data <= '1';
				m0_last_data <= '1';
				cnt_r <= '1';
				sel_out_128 <= '1';
				sel_out_192 <= '1';
				
			when fin_first =>
				sel_128 <= "01";
				sel_192 <= "10";
				e_128 <= '1';
				e_192 <= '1';
				sel_out_128 <= '1';
				sel_out_192 <= '1';
				
			when fin =>
				sel_128 <= "00";
				sel_192 <= "00";
				e_128 <= '1';
				e_192 <= '1';
				cnt_e <= '1';
				
			when write_t =>
				tag_valid <= '1';
				
		end case;
	end process;

end rtl;

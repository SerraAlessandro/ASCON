library IEEE;
use IEEE.std_logic_1164.all;

entity permutation_12 is
	generic(ppc : integer := 4);

	port(	S0_i,S1_i,S2_i,S3_i,S4_i : in std_logic_vector(63 downto 0);
			p_start: in std_logic;
			clock: in std_logic;
			S0_o,S1_o,S2_o,S3_o,S4_o : out std_logic_vector(63 downto 0);
			p_end: out std_logic
			);
end permutation_12;

ARCHITECTURE Behavior OF permutation_12 IS

component ASCON_P is
	port(	S0,S1,S2,S3,S4 : in std_logic_vector(63 downto 0);
			const : in std_logic_vector(7 downto 0);
			S0_out,S1_out,S2_out,S3_out,S4_out : out std_logic_vector(63 downto 0)
			);
end component;

component reg64 is
	port(	reg_in : in std_logic_vector(63 downto 0);
			clk,rst,reg_en: in std_logic;
			reg_out : out std_logic_vector (63 downto 0);
			reg_end : out std_logic
			);
end component;



--signal S0_tmp,S1_tmp,S2_tmp,S3_tmp,S4_tmp: std_logic_vector(63 downto 0);
type s_array is array (0 to 24) of std_logic_vector(63 downto 0);
type cont_array is array (0 to 11) of std_logic_vector(7 downto 0);
signal S0_tmp,S1_tmp,S2_tmp,S3_tmp,S4_tmp : s_array;
signal cons : cont_array;
signal r0_en,r1_en,r2_en,r3_en,r4_en: std_logic_vector(12 downto 0);

begin
	
	r0_en(0) <= p_start;
	r1_en(0) <= p_start;
	r2_en(0) <= p_start;
	r3_en(0) <= p_start;
	r4_en(0) <= p_start;
	S0_tmp(0) <= S0_i;
	S1_tmp(0) <= S1_i;
	S2_tmp(0) <= S2_i;
	S3_tmp(0) <= S3_i;
	S4_tmp(0) <= S4_i;
	cons(0) <= x"f0";
	cons(1) <= x"e1";
	cons(2) <= x"d2";
	cons(3) <= x"c3";
	cons(4) <= x"b4";
	cons(5) <= x"a5";
	cons(6) <= x"96";
	cons(7) <= x"87";
	cons(8) <= x"78";
	cons(9) <= x"69";
	cons(10) <= x"5a";
	cons(11) <= x"4b";
	
	gen_first:
		if ppc < 5 generate
			gen_perm:
				for i in 0 to ((12/ppc)-1) generate
					reg0: reg64 port map (reg_end => r0_en(i+1), reg_in => S0_tmp(i*(1+ppc)), clk => clock, reg_en => r0_en(i), rst => '0', reg_out => S0_tmp(i*(1+ppc)+1));
					reg1: reg64 port map (reg_end => r1_en(i+1), reg_in => S1_tmp(i*(1+ppc)), clk => clock, reg_en => r1_en(i), rst => '0', reg_out => S1_tmp(i*(1+ppc)+1));
					reg2: reg64 port map (reg_end => r2_en(i+1), reg_in => S2_tmp(i*(1+ppc)), clk => clock, reg_en => r2_en(i), rst => '0', reg_out => S2_tmp(i*(1+ppc)+1));
					reg3: reg64 port map (reg_end => r3_en(i+1), reg_in => S3_tmp(i*(1+ppc)), clk => clock, reg_en => r3_en(i), rst => '0', reg_out => S3_tmp(i*(1+ppc)+1));
					reg4: reg64 port map (reg_end => r4_en(i+1), reg_in => S4_tmp(i*(1+ppc)), clk => clock, reg_en => r4_en(i), rst => '0', reg_out => S4_tmp(i*(1+ppc)+1));
			
					gen_inside:
						for j in 0 to (ppc-1) generate
							perm: ASCON_P port map (S0 => S0_tmp(i*(1+ppc)+1+j), S1 => S1_tmp(i*(1+ppc)+1+j), S2 => S2_tmp(i*(1+ppc)+1+j), S3 => S3_tmp(i*(1+ppc)+1+j), S4 => S4_tmp(i*(1+ppc)+1+j), const => cons((ppc)*i+j), S0_out => S0_tmp(i*(1+ppc)+1+j+1), S1_out => S1_tmp(i*(1+ppc)+1+j+1), S2_out => S2_tmp(i*(1+ppc)+1+j+1), S3_out => S3_tmp(i*(1+ppc)+1+j+1), S4_out => S4_tmp(i*(1+ppc)+1+j+1));
					end generate gen_inside;
				
			end generate gen_perm;
		
			S0_o <= S0_tmp(12+(12/ppc));
			S1_o <= S1_tmp(12+(12/ppc));
			S2_o <= S2_tmp(12+(12/ppc));
			S3_o <= S3_tmp(12+(12/ppc));
			S4_o <= S4_tmp(12+(12/ppc));
			p_end <= r0_en(12/ppc) and r1_en(12/ppc) and r2_en(12/ppc) and r3_en(12/ppc) and r4_en(12/ppc);
	
	end generate gen_first;
	
	gen_second:
		if ppc = 8 generate
				reg5: reg64 port map (reg_end => r0_en(1), reg_en => r0_en(0), reg_in => S0_tmp(0), clk => clock, rst => '0', reg_out => S0_tmp(1));
				reg6: reg64 port map (reg_end => r1_en(1), reg_en => r1_en(0), reg_in => S1_tmp(0), clk => clock, rst => '0', reg_out => S1_tmp(1));
				reg7: reg64 port map (reg_end => r2_en(1), reg_en => r2_en(0), reg_in => S2_tmp(0), clk => clock, rst => '0', reg_out => S2_tmp(1));
				reg8: reg64 port map (reg_end => r3_en(1), reg_en => r3_en(0), reg_in => S3_tmp(0), clk => clock, rst => '0', reg_out => S3_tmp(1));
				reg9: reg64 port map (reg_end => r4_en(1), reg_en => r4_en(0), reg_in => S4_tmp(0), clk => clock, rst => '0', reg_out => S4_tmp(1));
			
			gen_inside_eight:
				for j in 0 to 7 generate
					perm: ASCON_P port map (S0 => S0_tmp(1+j), S1 => S1_tmp(1+j), S2 => S2_tmp(1+j), S3 => S3_tmp(1+j), S4 => S4_tmp(1+j), const => cons(j), S0_out => S0_tmp(j+2), S1_out => S1_tmp(j+2), S2_out => S2_tmp(j+2), S3_out => S3_tmp(j+2), S4_out => S4_tmp(j+2));
			end generate gen_inside_eight;
			
				reg10: reg64 port map (reg_end => r0_en(2), reg_en => r0_en(1), reg_in => S0_tmp(9), clk => clock, rst => '0', reg_out => S0_tmp(10));
				reg11: reg64 port map (reg_end => r1_en(2), reg_en => r1_en(1), reg_in => S1_tmp(9), clk => clock, rst => '0', reg_out => S1_tmp(10));
				reg12: reg64 port map (reg_end => r2_en(2), reg_en => r2_en(1), reg_in => S2_tmp(9), clk => clock, rst => '0', reg_out => S2_tmp(10));
				reg13: reg64 port map (reg_end => r3_en(2), reg_en => r3_en(1), reg_in => S3_tmp(9), clk => clock, rst => '0', reg_out => S3_tmp(10));
				reg14: reg64 port map (reg_end => r4_en(2), reg_en => r4_en(1), reg_in => S4_tmp(9), clk => clock, rst => '0', reg_out => S4_tmp(10));
			
			gen_inside_for:
				for j in 0 to 3 generate
					perm: ASCON_P port map (S0 => S0_tmp(10+j), S1 => S1_tmp(10+j), S2 => S2_tmp(10+j), S3 => S3_tmp(10+j), S4 => S4_tmp(10+j), const => cons(8+j), S0_out => S0_tmp(j+11), S1_out => S1_tmp(j+11), S2_out => S2_tmp(j+11), S3_out => S3_tmp(j+11), S4_out => S4_tmp(j+11));
			end generate gen_inside_for;
				
			S0_o <= S0_tmp(14);
			S1_o <= S1_tmp(14);
			S2_o <= S2_tmp(14);
			S3_o <= S3_tmp(14);
			S4_o <= S4_tmp(14);
			p_end <= r0_en(2) and r1_en(2) and r2_en(2) and r3_en(2) and r4_en(2);
			
	end generate gen_second;
	
end behavior;
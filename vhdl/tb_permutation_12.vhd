library IEEE;
use IEEE.std_logic_1164.all;

ENTITY tb_permutation_12 IS
END tb_permutation_12;

ARCHITECTURE behavior OF tb_permutation_12 IS
component permutation_12 is

generic(ppc : integer := 1);
port(	S0_i,S1_i,S2_i,S3_i,S4_i : in std_logic_vector(63 downto 0);
			p_start: in std_logic;
			clock: in std_logic;
			S0_o,S1_o,S2_o,S3_o,S4_o : out std_logic_vector(63 downto 0);
			p_end: out std_logic
			);

end component;
 
signal s0_in,s1_in,s2_in,s3_in,s4_in: std_logic_vector(63 downto 0);
signal perm_start, perm_end: std_logic;
signal c: std_logic_vector(7 downto 0);
signal clk: std_logic:= '0';
signal s0_out,s1_out,s2_out,s3_out,s4_out: std_logic_vector(63 downto 0);
 
begin
s0_in <= x"00001000808c0001" after 10 ns;
s1_in <= x"0706050403020100" after 10 ns;
s2_in <= x"0f0e0d0c0b0a0908" after 10 ns;
s3_in <= x"08090a0b0c0d0e0f" after 10 ns;
s4_in <= x"0001020304050607" after 10 ns;

perm_start <= '0', '1' after 30 ns, '0' after 70 ns;



ck_process: PROCESS
 BEGIN
 wait for 20 ns;
 clk <= NOT clk;
 END PROCESS;
 
ASCON_PERMUTATION : permutation_12 port map (p_start => perm_start, p_end => perm_end, S0_i => S0_in,S1_i => S1_in,S2_i => S2_in,S3_i => S3_in,S4_i => S4_in, clock => clk, S0_o => S0_out,S1_o => S1_out,S2_o => S2_out,S3_o => S3_out,S4_o => S4_out);
end behavior;
library IEEE;
 use IEEE.std_logic_1164.all;
 
 entity ASCON_P is
	port(	S0,S1,S2,S3,S4 : in std_logic_vector(63 downto 0);
			const : in std_logic_vector(7 downto 0);
			S0_out,S1_out,S2_out,S3_out,S4_out : out std_logic_vector(63 downto 0)
			);
 end ASCON_P;
 
 ARCHITECTURE Behavior OF ASCON_P IS
 
 signal S2_C: std_logic_vector(63 downto 0);
 signal S0_S,S1_S,S2_S,S3_S,S4_S : std_logic_vector(63 downto 0);
 signal S0_XA,S1_XA,S2_XA,S3_XA,S4_XA: std_logic_vector(63 downto 0);
 
 begin
 
 S2_C <= S2(63 downto 8) & (S2(7 downto 0) XOR const);
 
 S0_XA <= ((S0 XOR S4) XOR (63 downto 0 => '1')) AND S1;
 S1_XA <= (S1 XOR (63 downto 0 => '1')) AND (S2_C XOR S1);
 S2_XA <= ((S2_C XOR S1) XOR (63 downto 0 => '1')) AND S3;
 S3_XA <= (S3 XOR (63 downto 0 => '1')) AND (S4 XOR S3);
 S4_XA <= ((S4 XOR S3) XOR (63 downto 0 => '1')) AND (S0 XOR S4);

 S0_S <= ((S0 XOR S4) XOR S1_XA) XOR S4_S;
 S1_S <= (S1 XOR S2_XA) XOR ((S0 XOR S4) XOR S1_XA);
 S2_S <= ((S2_C XOR S1) XOR S3_XA) XOR (63 downto 0 => '1');
 S3_S <= (S3 XOR S4_XA) XOR ((S2_C XOR S1) XOR S3_XA);
 S4_S <= (S3 XOR S4) XOR S0_XA;
 
 S0_out <= S0_S XOR (S0_S(18 downto 0) & S0_S(63 downto 19)) XOR (S0_S(27 downto 0) & S0_S(63 downto 28));
 S1_out <= S1_S XOR (S1_S(60 downto 0) & S1_S(63 downto 61)) XOR (S1_S(38 downto 0) & S1_S(63 downto 39));
 S2_out <= S2_S XOR (S2_S(0 downto 0) & S2_S(63 downto 1)) XOR (S2_S(5 downto 0) & S2_S(63 downto 6));
 S3_out <= S3_S XOR (S3_S(9 downto 0) & S3_S(63 downto 10)) XOR (S3_S(16 downto 0) & S3_S(63 downto 17));
 S4_out <= S4_S XOR (S4_S(6 downto 0) & S4_S(63 downto 7)) XOR (S4_S(40 downto 0) & S4_S(63 downto 41));
 
 end behavior;	
 
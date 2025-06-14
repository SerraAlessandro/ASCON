Side-channel attacks on ASCON hardware accelerator

---

[TOC]

---

# ASCON

## Building the C reference model

```bash
git pull
git submodule init
git submodule update
mkdir build
cd build
cmake -S C -B build -DALG_LIST="asconaead128" -DIMPL_LIST="ref" -DTEST_LIST="genkat"
cmake --build build
ctest --test-dir build
```

Known Answer Tests results should be in `build/build/LWC_AEAD_KAT_128_128.txt`

The C reference results will be used to test the encryption and decryption functions inside the Ascon package

## Ascon package
The file ascon_pkg.vhd contains the following functions (and procedures): 
- **single permutation functions**
  
  A single iteration of the Ascon algorithm is composed in 3 steps: Pc (constant addiction layer), Ps (substitution layer) and Pl (linear diffusion layer), each step is processed inside a function:
  - `ascon_pc_f`
  - `ascon_ps_f`
  - `ascon_pl_f`
  
  The 3 functions are jointed together inside the `ascon_p_f` function.

- **multiple permutations function**
  
  The `ascon_p_f_multiple` function is used to process multiple Ascon permutations, this will be used for the `ascon_enc_p` and `ascon_dec_p` procedures, aswell as the **crypto_core**.
  
  The ascon_p_f_multiple function is the hyerarchically highest function that will be used inside the synthesizable implementation of the Ascon algorithm, since it is still fully combinatorial.

- **byte reverse**
  
  The `reverse_byte` function is used to switch from big endian to small endian and vice versa. This function is needed to provide the proper input and output of the `ascon_enc_p` and `ascon_dec_p` procedure, aswell as the **crypto_core**.

- **encryption**
  
  The `ascon_enc_p` procedure processes the full Ascon encryption, considering all possible lenghts of Associated data and Plaintext

- **decryption**

  The `ascon_dec_p` procedure processes the full Ascon decryption, consdiering all possible lenghts of Associated data and Cyphertext

## In depth explanation of the `ascon_enc_p` procedure
```bash
procedure ascon_enc_p (key: in std_ulogic_vector; nonce: in std_ulogic_vector; ad: in std_ulogic_vector; pt: in std_ulogic_vector; ct: out std_ulogic_vector; tag: out w128_t) is

		constant a_len: natural := ad'length;
		constant a_local: std_ulogic_vector(a_len - 1 downto 0) := reverse_byte(ad);
		constant p_len: natural := pt'length;
		constant p_local: std_ulogic_vector(p_len - 1 downto 0) := reverse_byte(pt);
		constant k_len: natural := key'length;
		constant k_local: std_ulogic_vector(k_len - 1 downto 0) := reverse_byte(key);
		constant n_len: natural := nonce'length;
		constant n_local: std_ulogic_vector(n_len - 1 downto 0) := reverse_byte(nonce);
		constant iv: std_ulogic_vector(63 downto 0) := x"00001000808c0001";

		variable state: ascon_state_t;
		variable tmp1: ascon_state_t;
		variable k,n: w128_t;
		variable tmp12: w128_t;
		variable ad_tmp, pt_tmp: w128_t;
		variable ad_words,pt_words: natural := 0;
		variable T: w128_t;
```

The inputs are the key, nonce, associated data and plaintext. The outputs are the cyphertext and the tag.

In order to make the procedure as general as possible, a local version of each input is used, and declared as (n downto 0). In this way, the procedure will work even if the original inputs are defined as (0 to n). In addition, the reverse_byte version of the inputs gets used, in order to be consistent with the algorithm. 

The expected length of key and nonce is 128 bits, while ad and pt can have any bit length as long as they are an integer number of bytes (0 bits, 8 bits, 16 bits, 24 bits, ...).

```bash
begin
			
			state(0) := iv;
			state(1) := k_local(63 downto 0);
			state(2) := k_local(127 downto 64);
			state(3) := n_local(63 downto 0);
			state(4) := n_local(127 downto 64);
			tmp1 := state;
```

This is the initialization of the 320 bits state.

The state is defined as (0 to 4), but the key and the nonce inside must be defined as (n downto 0), in order to be consistent with the algorithm.

```
-- ******************** INITIALIZATION ********************
			
			init: for j in 0 to 11 loop
				tmp1 := ascon_p_f(tmp1,12,j);
			end loop init;

			tmp1(3) := tmp1(3) xor state(1);
			tmp1(4) := tmp1(4) xor state(2);
```

This is the initialization part of the Ascon algorithm, in which 12 rounds of permutations are always performed.

```
-- ******************** ASSOCIATED DATA ********************	
			if a_len /= 0 then
				while (a_len - 128*ad_words > 128) loop
					ad_tmp := a_local((128*(ad_words+1))-1 downto 128*ad_words);
					tmp1(0) := tmp1(0) xor ad_tmp(63 downto 0);
					tmp1(1) := tmp1(1) xor ad_tmp(127 downto 64);
					ad_processing: for j in 0 to 7 loop
						tmp1 := ascon_p_f(tmp1,8,j);
					end loop ad_processing;
					ad_words := ad_words + 1;
				end loop;
```
This is the first part of the code that handles the associated data. 

Having associated data is not mandatory, and this is handled by the outher if statement.

The associated data is proessed in blocks of 128 bits, the while loop is used in case the total length of AD exceeeds 128 bits, meaning multiple associated data processes are needed.

After the first 128bits have been processed, if the remaining part of AD is longer than 128 bits, the loop is repeated, until the remaining part of AD is shorted or equal to 128 bits. To make it more clear:

| bit length of AD    | how many full 128 blocks       | how many times the loop is repeated |
|---------------------|--------------------------------|-------------------------------------|
| 0  		      | 0 			       | 0                                   |
| 16  		      | 0 			       | 0                                   |
| 128  		      | 1 			       | 0                                   |
| 136  		      | 1 			       | 1                                   |
| 192  		      | 1 			       | 1                                   |
| 448  		      | 3 			       | 3                                   |



The last remaining part of the associated data is handled differently, because the algorithm includes the padding, which means adding a certain number of '0' followed by a '1' to the upper part of the still unprocessed slice of the associated data, to make it so that the padded version of the remaining AD is 128 bits long. For example:

| remaining part of AD to process   | word to be added               | final word (127 downto 0)	     |
|---------------------------------- |--------------------------------|---------------------------------------|
| x"58127865297adc3544187654326787" | x"01" 		             | x"0158127865297adc3544187654326787"   |
| x"58127865297adc35441876543267"   | x"0001"		             | x"000158127865297adc35441876543267"   |
| x"58127865"  		            | x"000000000000000000000001"    | x"00000000000000000000000158127865"   |

```
				if (a_len -(128*(ad_words+1)) = 0) then
					ad_tmp := a_local((128*(ad_words+1))-1 downto 128*ad_words);
					tmp1(0) := tmp1(0) xor ad_tmp(63 downto 0);
					tmp1(1) := tmp1(1) xor ad_tmp(127 downto 64);
					ad_processing_last_full: for j in 0 to 7 loop
						tmp1 := ascon_p_f(tmp1,8,j);
					end loop ad_processing_last_full;
					ad_tmp := x"00000000000000000000000000000001";
				else
					ad_tmp := x"00000000000000000000000000000000";
					ad_tmp(8 + a_len - 1 - 128*ad_words downto 0) := x"01" & a_local(a_len - 1 downto 128*ad_words);
				end if;
				tmp1(0) := tmp1(0) xor ad_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor ad_tmp(127 downto 64);

				ad_processing_last: for j in 0 to 7 loop
					tmp1 := ascon_p_f(tmp1,8,j);
				end loop ad_processing_last;
			end if;
		
			tmp1(4)(63) := tmp1(4)(63) xor '1';
```
If the unprocessed part of the associated data is exactly 128 bit long, then it's needed to process the full 128 bit block as usual, and then re-run the xor plus 8-permutations for a 128 bit block that is all '0' except for the least significant bit.

This happens because, if the length of the entire associated data is a multiple of 128 bits, the padding will end up in a new 128bit block rather than being simply appended inside last block of the associated data.

If the unprocessed part of the associated data is less than 128 bit long, then the padding gets appended to it and the block gets processed as usual.

```
-- ******************** PLAINTEXT ********************

			while (p_len - 128*pt_words > 128) loop
				pt_tmp := p_local((128*(pt_words+1))-1 downto 128*pt_words);
				tmp1(0) := tmp1(0) xor pt_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor pt_tmp(127 downto 64);
				ct((128*(pt_words+1))-1 downto 128*pt_words) := tmp1(1) & tmp1(0);
				pt_processing: for j in 0 to 7 loop
					tmp1 := ascon_p_f(tmp1,8,j);
				end loop pt_processing;
				pt_words := pt_words + 1;
			end loop;
```
Just like the associated data, also the plaintext is processed in blocks of 128 bits, that get handled in a similar way as AD.

This code handles the full 128 bit words of the plaintext when the remaining unprocessed part is longer than 128 bits, and it outputs the respective cyphertext 128 bits words.

```
			if (p_len -(128*(pt_words+1)) = 0) then
				pt_tmp := p_local((128*(pt_words+1))-1 downto 128*pt_words);
				tmp1(0) := tmp1(0) xor pt_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor pt_tmp(127 downto 64);
				ct((128*(pt_words+1))-1 downto 128*pt_words) := tmp1(1) & tmp1(0);
				pt_processing_last_full: for j in 0 to 7 loop
					tmp1 := ascon_p_f(tmp1,8,j);
				end loop pt_processing_last_full;
				pt_tmp := x"00000000000000000000000000000001";
				tmp1(0) := tmp1(0) xor pt_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor pt_tmp(127 downto 64);
			else
				pt_tmp := x"00000000000000000000000000000000";
				pt_tmp(8 + p_len - 1 - 128*pt_words downto 0) := x"01" & p_local(p_len - 1 downto 128*pt_words);
				tmp1(0) := tmp1(0) xor pt_tmp(63 downto 0);
				tmp1(1) := tmp1(1) xor pt_tmp(127 downto 64);
				tmp12 := tmp1(1) & tmp1(0);
				ct(p_len-1 downto 128*pt_words) := tmp12(p_len-1-128*pt_words downto 0);
			end if;

			ct := reverse_byte(ct);
```
When the unprocessed part of the plaintext is exactly 128 bits long, the 128 block gets processed in the standard way, and the 128 least significant bits of the state that enter the finalization part of the algorithm are a vector of 127 '0' and a '1'.

If instead the length of the remaining part of the plaintext is different than 128 bits, there is no more permutation round, the remaining part gets padded and the last part of the cyphertext gets added.

```
-- ******************** FINALIZATION ********************

			tmp1(2) := tmp1(2) xor state(1);
			tmp1(3) := tmp1(3) xor state(2);

			fin: for j in 0 to 11 loop
				tmp1 := ascon_p_f(tmp1,12,j);
			end loop fin;
			
			T(63 downto 0) := tmp1(3) xor state(1);
			T(127 downto 64) := tmp1(4) xor state(2);

			tag := reverse_byte(T);
			
  end procedure ascon_enc_p;
```
This is the code for the finalization part of the algorithm.
The procedure will return the reverse_byte of ct and T.

The procedure for the decryption (`ascon_dec_p`), is handled in a similar way as the encryption.

## Testing of the ascon_pkg functions 

To test the functions and procedures inside the package:
```bash
cd ASCON
make ascon_pkg_sim.sim
```





## Using `ascon_enc_f` and `ascon_dec_f`

In order to be consistent with the official implementation, the key, nonce, associated data and plaintext need to be byte reversed, so, if the official python implementation provides this result:  

```
key:        0xabc5472b56742bca3675cbef47956338 (16 bytes)  
nonce:      0x2c66b325ae354f7804658cdfe43645af (16 bytes)  
plaintext:  0xfeb45ab41265432cde653dfeda543f4567565a (19 bytes)  
ass.data:   0x45bc627ad055be54fa4393fed679041245bc627ad055beb5fa4397fed9790ac234be6f12a08c (38 bytes)  
ciphertext: 0x6ba44ddc907dd8c3f87290fa64e5f1b8501cdd (19 bytes)  
tag:        0xe11a76b1067c168fde2a1bdddcad3258 (16 bytes)  
received:   0xfeb45ab41265432cde653dfeda543f4567565a (19 bytes)  
```

then, the inputs of the `ascon_enc_f` function will be:  

```
key_rev:        38639547EFCB7536CA2B74562B47C5AB  
nonce_rev:      AF4536E4DF8C6504784F35AE25B3662C  
plaintext_rev:  5A5667453F54DAFE3D65DE2C436512B45AB4FE  
ass.data_rev:   8CA0126FBE34C20A79D9FE9743FAB5BE55D07A62BC45120479D6FE9343FA54BE55D07A62BC45  
```

`ascon_enc_f` will then return the cyphertext and the Tag:  

```
t:          5832ADDCDD1B2ADE8F167C06B1761AE1  
ciphertext: DD1C50B8F1E564FA9072F8C3D87D90DC4DA46B  
```

So, `t` and `c` must be byte reversed again in order to be consistent with the results:  

```
tag_rev:        E11A76B1067C168FDE2A1BDDDCAD3258  
ciphertext_rev: 6BA44DDC907DD8C3F87290FA64E5F1B8501CDD  
```

`ascon_dec_f` will take as inputs: key, nonce, associated data and ciphertext. It's again needed to provide the reversed version of the original inputs, with the exception of ciphertext.  
So the inputs of `ascon_dec_f` will be:  

```
key_rev:        38639547EFCB7536CA2B74562B47C5AB  
nonce_rev:      AF4536E4DF8C6504784F35AE25B3662C  
ciphertext:     DD1C50B8F1E564FA9072F8C3D87D90DC4DA46B  
ass.data_rev:   8CA0126FBE34C20A79D9FE9743FAB5BE55D07A62BC45120479D6FE9343FA54BE55D07A62BC45  
```

`ascon_dec_f` will then return the plaintext and the Tag:  

```
t:          5832ADDCDD1B2ADE8F167C06B1761AE1  
plaintext:  5A5667453F54DAFE3D65DE2C436512B45AB4FE  
```

So they both need to be byte reversed:  

```
tag_rev:        E11A76B1067C168FDE2A1BDDDCAD3258  
plaintext_rev:  FEB45AB41265432CDE653DFEDA543F4567565A
```

In VHDL:

```vhdl
ad <= x"45bc627ad055be54fa4393fed679041245bc627ad055beb5fa4397fed9790ac234be6f12a08c";
pl <= x"feb45ab41265432cde653dfeda543f4567565a";
key <= x"abc5472b56742bca3675cbef47956338";
nonce <= x"2c66b325ae354f7804658cdfe43645af";

k_Rev <= reverse_byte(key);
n_rev <= reverse_byte(nonce);
ad_rev <= reverse_byte(ad);
pl_rev <= reverse_byte(pl);
	
T_enc <= reverse_byte(ascon_enc_f(k_rev,n_rev,ad_rev,pl_rev).t);
c_int <= ascon_enc_f(k_rev,n_rev,ad_rev,pl_rev).c;

T_dec <= reverse_byte(ascon_dec_f(k_rev,n_rev,ad_rev,c_int).t);
received <= reverse_byte(ascon_dec_f(k_rev,n_rev,ad_rev,c_int).p);

C <= reverse_byte(c_int);
```

## Using 32bit little endian CPU

Starting from the previous example, by writing key: 0xabc5472b56742bca3675cbef47956338 in little endian: 
```
Address | Byte Written
0x00    | 0x38
0x01    | 0x63
0x02    | 0x95
0x03    | 0x47
0x04    | 0xEF
0x05    | 0xCB
0x06    | 0x75
0x07    | 0x36
0x08    | 0xCA
0x09    | 0x2B
0x0A    | 0x74
0x0B    | 0x56
0x0C    | 0x2B
0x0D    | 0x47
0x0E    | 0xC5
0x0F    | 0xAB
```
So, by reading key starting from the lowest address, we would get: 0x38639547EFCB7536CA2B74562B47C5AB, which is already the correct format to be processed by the encryption.
Same for the Nonce.

The encryption will provide tag: 0x5832ADDCDD1B2ADE8F167C06B1761AE1, which written in little endian will become:
```
Address | Byte Written
0x20    | 0xE1
0x21    | 0x1A
0x22    | 0x76
0x23    | 0xB1
0x24    | 0x06
0x25    | 0x7C
0x26    | 0x16
0x27    | 0x8F
0x28    | 0xDE
0x29    | 0x2A
0x2A    | 0x1B
0x2B    | 0xDD
0x2C    | 0xDC
0x2D    | 0xAD
0x2E    | 0x32
0x2F    | 0x58
```
By reading it from address 0x20, it is already in the correct format.

## Axi_slave_write schematics
![axi_slave_write schematics](axi_slave_write_schematics.jpg)
## Axi_slave_write state diagram
![axi_slave_write StateDiagram](axi_slave_write_StateDiagram.jpg)
## Encryption hardware schematics
![encryption schematics](encryption_schematics.jpg)

# ASCON on Zybo

The Zybo version of the ASCON accelerator comprises DMA engines for memory-to-crypto and crypto-to-memory transfers.
It communicates with the software stack through a AXI lite control interface used to provide a secret key and a nonce, to read out the authentication tag, to configure and control the DMA engines and to read status information.

## The AXI lite control interface

The address mapping of this AXI lite control interface is the following:

| Name       | Byte offset   | Byte length | Description                     |
| :----      | :----         | :----       | :----                           |
| `KEY`      | 0-15          | 16          | Secret key                      |
| `NONCE`    | 16-31         | 16          | Nonce                           |
| `TAG`      | 32-47         | 16          | Tag                             |
| `ADDR_IN`  | 48-51         | 4           | Input starting address          |
| `LEN_IN`   | 52-55         | 4           | Input length (in 32 bits words) |
| `ADDR_OUT` | 56-59         | 4           | Output starting address         |
| `CTRL`     | 60-63         | 4           | Control register                |
| `STATUS`   | 64-67         | 4           | Status register                 |
| `-`        | 68-4095       | 4028        | Unmapped                        |

Only 4-bytes aligned accesses are supported.
Read or write accesses at unaligned addresses return a `SLVERR` response and have no other effect.
Writing the `TAG` region returns a `SLVERR` response and has no other effect.
Writing in the unmapped region returns a `DECERR` response and has no other effect.

The two Least Significant Bits (LSB) of `ADDR_IN` and `ADDR_OUT` are hard-wired to 0; writing them has no effect.
This guarantees the memory alignment of the starting addresses on 4 bytes boundaries.

The two Most Significant Bits (MSB) of `LEN_IN` are hard-wired to 0; writing them has no effect.
This guarantees a maximum input length of 4 GB.

The layout of the 32-bits CTRL register is the following:

| Name        | Bit range     | Bit width   | Description              |
| :----       | :----         | :----       | :----                    |
| `START_IN`  | 0-0           | 1           | DMA input start command  |
| `START_OUT` | 1-1           | 1           | DMA output start command |
| `-`         | 31-2          | 30          | Reserved                 |

- Writing a 1 in `START_IN` launches the input DMA if the DMA engine is available, else this has no effect.
  The flag is automatically cleared on the following rising edge of the clock.
- Writing a 1 in `START_OUT` launches the output DMA if the DMA engine is available, else this has no effect.
  The flag is automatically cleared on the following rising edge of the clock.

Writing the other bits has no effect; they read as zero.

The layout of the 32-bits STATUS register is the following:

| Name        | Bit range     | Bit width   | Description                |
| :----       | :----         | :----       | :----                      |
| `BUSY`      | 0-0           | 1           | Busy flag                  |
| `ERR_IN`    | 2-1           | 2           | Input transfer error code  |
| `ERR_OUT`   | 4-3           | 2           | Output transfer error code |
| `-`         | 31-5          | 27          | Reserved                   |

- The `BUSY` flag is automatically set to 1 when a 1 is written to `START_IN`.
  It is automatically set to 0 when an output DMA transfer ends.
- The `ERR_IN` field contains the last non-OKAY AXI read response from the memory during an input DMA transfer, or OKAY if there was no error.
- The `ERR_OUT` field contains the last non-OKAY AXI write response from the memory during an output DMA transfer, or OKAY if there was no error.

`ERR_IN` and `ERR_OUT` are cleared-on-set: when writing to `STATUS`, bits of `ERR_IN` and `ERR_OUT` are set to 0 if they are written a 1.
The other written bits are ignored.
The reserved bits read as zero.

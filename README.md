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


## Using ascon_enc_f and ascon_dec_f
```
In order to be consistent with the official implementation, the key, nonce, associated data and plaintext need to be byte reversed, so, if the official python implementation provides this result:  
key:        0xabc5472b56742bca3675cbef47956338 (16 bytes)  
nonce:      0x2c66b325ae354f7804658cdfe43645af (16 bytes)  
plaintext:  0xfeb45ab41265432cde653dfeda543f4567565a (19 bytes)  
ass.data:   0x45bc627ad055be54fa4393fed679041245bc627ad055beb5fa4397fed9790ac234be6f12a08c (38 bytes)  
ciphertext: 0x6ba44ddc907dd8c3f87290fa64e5f1b8501cdd (19 bytes)  
tag:        0xe11a76b1067c168fde2a1bdddcad3258 (16 bytes)  
received:   0xfeb45ab41265432cde653dfeda543f4567565a (19 bytes)  

then, the inputs of the ascon_enc_f function will be:  
key_rev:        38639547EFCB7536CA2B74562B47C5AB  
nonce_rev:      AF4536E4DF8C6504784F35AE25B3662C  
plaintext_rev:  5A5667453F54DAFE3D65DE2C436512B45AB4FE  
ass.data_rev:   8CA0126FBE34C20A79D9FE9743FAB5BE55D07A62BC45120479D6FE9343FA54BE55D07A62BC45  

ascon_enc_f will then return the cyphertext and the Tag:  
t:          5832ADDCDD1B2ADE8F167C06B1761AE1  
ciphertext: DD1C50B8F1E564FA9072F8C3D87D90DC4DA46B  

So, t and c must be byte reversed again in order to be consistent with the results:  
tag_rev:        E11A76B1067C168FDE2A1BDDDCAD3258  
ciphertext_rev: 6BA44DDC907DD8C3F87290FA64E5F1B8501CDD  

ascon_dec_f will take as inputs: key, nonce, associated data and ciphertext. It's again needed to provide the reversed version of the original inputs, with the exception of ciphertext.  
So the inputs of ascon_dec_f will be:  
key_rev:        38639547EFCB7536CA2B74562B47C5AB  
nonce_rev:      AF4536E4DF8C6504784F35AE25B3662C  
ciphertext:     DD1C50B8F1E564FA9072F8C3D87D90DC4DA46B  
ass.data_rev:   8CA0126FBE34C20A79D9FE9743FAB5BE55D07A62BC45120479D6FE9343FA54BE55D07A62BC45  

ascon_dec_f will then return the plaintext and the Tag:  
t:          5832ADDCDD1B2ADE8F167C06B1761AE1  
plaintext:  5A5667453F54DAFE3D65DE2C436512B45AB4FE  

So they both need to be byte reversed:  
tag_rev:        E11A76B1067C168FDE2A1BDDDCAD3258  
plaintext_rev:  FEB45AB41265432CDE653DFEDA543F4567565A  
```




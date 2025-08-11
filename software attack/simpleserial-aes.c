/*
    This file is part of the ChipWhisperer Example Targets
    Copyright (C) 2012-2017 NewAE Technology Inc.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "aes-independant.h"
#include "hal.h"
#include "simpleserial.h"
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

uint8_t get_mask(uint8_t* m, uint8_t len)
{
  aes_indep_mask(m, len);
  return 0x00;
}

uint8_t get_key(uint8_t* k, uint8_t len)
{
	aes_indep_key(k);
	return 0x00;
}



uint8_t get_pt(uint8_t* pt, uint8_t len)
{
    // Definisci la chiave come due uint64_t (MSB e LSB)
    uint64_t key_low = 0x0000000000000000ULL;  // parte più a sx
    uint64_t key_high  = 0x0000000000012345ULL;  // parte più a dx

    // Combina in array di 16 byte
    uint8_t key_bytes[16];
    memcpy(&key_bytes[0], &key_high, 8);  // little-endian
    memcpy(&key_bytes[8], &key_low, 8);   // little-endian

    // Fai il byte reverse globale
    uint8_t key_bytes_rev[16];
    for (int i = 0; i < 16; i++) {
        key_bytes_rev[i] = key_bytes[15 - i];
    }

    // Dividi i 16 byte reversed in s[1] e s[2]
    uint64_t s[5];
    s[1] = *((uint64_t*)&key_bytes_rev[0]);   // prima metà
    s[2] = *((uint64_t*)&key_bytes_rev[8]);   // seconda metà

    const uint64_t RC[12] = {
        0xF0, 0xE1, 0xD2, 0xC3,
        0xB4, 0xA5, 0x96, 0x87,
        0x78, 0x69, 0x5A, 0x4B
    };

    #define ROR(x, n) (((x) >> (n)) | ((x) << (64 - (n))))

    // Inizializza stato: IV || K0 || K1 || N0 || N1
    s[0] = 0x00001000808c0001ULL;
    s[3] = *((uint64_t*)&pt[0]);
    s[4] = *((uint64_t*)&pt[8]);

    trigger_high();

    // Permutazione (1 round)
    s[2] ^= RC[0];

    s[0] ^= s[4];
    s[4] ^= s[3];
    s[2] ^= s[1];

    uint64_t t[5];
    t[0] = (~s[0]) & s[1];
    t[1] = (~s[1]) & s[2];
    t[2] = (~s[2]) & s[3];
    t[3] = (~s[3]) & s[4];
    t[4] = (~s[4]) & s[0];

    for (int i = 0; i < 5; i++) {
        s[i] ^= t[(i + 1) % 5];
    }
    
    s[1] ^= s[0];
    s[0] ^= s[4];
    s[3] ^= s[2];
    s[2] = ~s[2];
    /*
    s[0] ^= ROR(s[0], 19) ^ ROR(s[0], 28);
    s[1] ^= ROR(s[1], 61) ^ ROR(s[1], 39);
    s[2] ^= ROR(s[2], 1)  ^ ROR(s[2], 6);
    s[3] ^= ROR(s[3], 10) ^ ROR(s[3], 17);
    s[4] ^= ROR(s[4], 7)  ^ ROR(s[4], 41); */
 
    trigger_low();

    // Serializza s[0..4] in formato big-endian
    uint8_t out[40];
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 8; j++) {
            out[i * 8 + j] = ((uint8_t*)&s[i])[7 - j];  // big-endian
        }
    }

    simpleserial_put('r', 40, out);
    return 0x00;
}




uint8_t reset(uint8_t* x, uint8_t len)
{
    // Reset key here if needed
	return 0x00;
}

static uint16_t num_encryption_rounds = 10;

uint8_t enc_multi_getpt(uint8_t* pt, uint8_t len)
{
    aes_indep_enc_pretrigger(pt);

    for(unsigned int i = 0; i < num_encryption_rounds; i++){
        trigger_high();
        aes_indep_enc(pt);
        trigger_low();
    }

    aes_indep_enc_posttrigger(pt);
	simpleserial_put('r', 16, pt);
    return 0;
}

uint8_t enc_multi_setnum(uint8_t* t, uint8_t len)
{
    //Assumes user entered a number like [0, 200] to mean "200"
    //which is most sane looking for humans I think
    num_encryption_rounds = t[1];
    num_encryption_rounds |= t[0] << 8;
    return 0;
}

#if SS_VER == SS_VER_2_1
uint8_t aes(uint8_t cmd, uint8_t scmd, uint8_t len, uint8_t *buf)
{
    uint8_t req_len = 0;
    uint8_t err = 0;
    uint8_t mask_len = 0;
    if (scmd & 0x04) {
        // Mask has variable length. First byte encodes the length
        mask_len = buf[req_len];
        req_len += 1 + mask_len;
        if (req_len > len) {
            return SS_ERR_LEN;
        }
        err = get_mask(buf + req_len - mask_len, mask_len);
        if (err)
            return err;
    }

    if (scmd & 0x02) {
        req_len += 16;
        if (req_len > len) {
            return SS_ERR_LEN;
        }
        err = get_key(buf + req_len - 16, 16);
        if (err)
            return err;
    }
    if (scmd & 0x01) {
        req_len += 16;
        if (req_len > len) {
            return SS_ERR_LEN;
        }
        err = get_pt(buf + req_len - 16, 16);
        if (err)
            return err;
    }

    if (len != req_len) {
        return SS_ERR_LEN;
    }

    return 0x00;

}
#endif

int main(void)
{
	uint8_t tmp[KEY_LENGTH] = {DEFAULT_KEY};

    platform_init();
    init_uart();
    trigger_setup();

	aes_indep_init();
	aes_indep_key(tmp);

    /* Uncomment this to get a HELLO message for debug */

    // putch('h');
    // putch('e');
    // putch('l');
    // putch('l');
    // putch('o');
    // putch('\n');

	simpleserial_init();
    #if SS_VER == SS_VER_2_1
    simpleserial_addcmd(0x01, 16, aes);
    #else
    simpleserial_addcmd('k', 16, get_key);
    simpleserial_addcmd('p', 16,  get_pt);
    simpleserial_addcmd('x',  0,   reset);
    simpleserial_addcmd_flags('m', 18, get_mask, CMD_FLAG_LEN);
    simpleserial_addcmd('s', 2, enc_multi_setnum);
    simpleserial_addcmd('f', 16, enc_multi_getpt);
    #endif
    while(1)
        simpleserial_get();
}

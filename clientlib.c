/*
 * =BEGIN MIT LICENSE
 * 
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Andras Csizmadia
 * http://www.vpmedia.hu
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * =END MIT LICENSE
 *
 */
 
/**
 *  ClientLib
 *  clientlib.c
 *  Purpose: Client library implementation
 *
 *  @author Andras Csizmadia
 *  @version 1.0
 */

//----------------------------------
//  Imports
//----------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include <openssl/conf.h>
#include <openssl/bio.h>
#include <openssl/buffer.h>
#include <openssl/err.h> // Error reporting
#include <openssl/evp.h>
#include <openssl/objects.h>

#include <openssl/aes.h>
#include <openssl/blowfish.h>
#include <openssl/des.h>
#include <openssl/hmac.h>
#include <openssl/md5.h>
#include <openssl/rand.h>
#include <openssl/rc4.h>
#include <openssl/rsa.h>
#include <openssl/sha.h>

#include "clientlib.h"

//----------------------------------
//  Private
//----------------------------------

//----------------------------------
//  API
//----------------------------------

/**
 * @see clientlib.h 
 */
void selfTest(){  
  ERR_load_crypto_strings();
  OpenSSL_add_all_algorithms();
  OPENSSL_config(NULL);
  // TODO: do some encryption
  unsigned char data[] = "HelloWorld";
  unsigned char hash[SHA512_DIGEST_LENGTH];
  SHA512(data, sizeof(data), hash);
  int i;
    for (i = 0; i < sizeof(data); i++) {
        printf("%02x ", data[i]);
    }
    printf("\n");
  //
  EVP_cleanup();
  CRYPTO_cleanup_all_ex_data();
  ERR_free_strings();
}

void connect() {
    // stub
}

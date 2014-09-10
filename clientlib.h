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
 *  clientlib.h
 *  Purpose: Client library header
 *
 *  @author Andras Csizmadia
 *  @version 1.0
 */
 
//----------------------------------
//  Include Once Start
//----------------------------------

#ifndef __CLIENTLIB_H
#define __CLIENTLIB_H

//----------------------------------
//  Includes
//----------------------------------


//----------------------------------
//  CPP Start
//----------------------------------

#ifdef __cplusplus
extern "C" {
#endif

//----------------------------------
//  Constants
//----------------------------------

#define VERSION "1.0.0"  

//----------------------------------
//  API
//----------------------------------

void testOpenSSL();
// stub method do prevent undefined _connect OpenSSL error
void connect();

/**
 * Returns the payload to the flash client.
 *
 * @param out Pointer to a Pointer of a Flash String
 * @param outsize Pointer to Flash Integer (String Length)
 *
 * @return void
 */
void getPayload(char** out, int* outsize);

//----------------------------------
//  CPP End
//----------------------------------

#ifdef __cplusplus
}
#endif

//----------------------------------
//  Include Once End
//----------------------------------

#endif/*__CLIENTLIB_H*/
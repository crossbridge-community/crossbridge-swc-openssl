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
 *  AS3API
 *  as3api.h
 *  Purpose: AS3 API Definition for SWIG wrapper generator
 *  Please check Adobe CrossBridge documentation about details.
 *
 *  @author Andras Csizmadia
 *  @version 1.0
 */
 
#ifdef SWIG
    %module ClientLibModule
    %{
        ///////////////////////////////////////
        // Includes
        ///////////////////////////////////////
        // CrossBridge
        #include "AS3/AS3.h"
        // Lib
        #include "clientlib.h"
        ///////////////////////////////////////
        // Main
        ///////////////////////////////////////

        // We still need a main function for the SWC. this function must be called
        // so that all the static init code is executed before any library functions
        // are used.
        //
        // The main function for a library must throw an exception so that it does
        // not return normally. Returning normally would cause the static
        // destructors to be executed leaving the library in an unuseable state.
        int main() {
            #ifdef __FLASHPLAYER__
            AS3_Trace("CryptoLib loaded.");
            #endif
            AS3_GoAsync();
            return 0;
        }
        
    %}
        
    // overwrite AS3 swig wrapper behaviour
    %apply int {unsigned char, signed char};

    // allow const reference typemaps
    %naturalvar;

    %include "clientlib.h"
#else
    #include "clientlib.h"
#endif





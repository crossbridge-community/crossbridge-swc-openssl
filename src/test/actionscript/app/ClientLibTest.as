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

package app {
import app.ClientLib.CModule;

import flash.display.Sprite;
import flash.utils.ByteArray;

import flexunit.framework.Assert;

public class ClientLibTest extends Sprite {
    
    [Before]
    public function setUp():void {
        if(!CModule.rootSprite) {
        CModule.throwWhenOutOfMemory = true;
            CModule.rootSprite = this;
            CModule.startAsync(this);
            CModule.serviceUIRequests();        
        }
        
    }

    [After]
    public function tearDown():void {
    }
    
    [Test]
    public function test_getPayload():void {
        // Program start
        var outputPtr:int = CModule.malloc(4);
        var outputLengthPtr:int = CModule.malloc(4);
        ClientLib.getPayload(outputPtr, outputLengthPtr);
        var outputLength:int = CModule.read32(outputLengthPtr);
        var outputString:String = CModule.readString(CModule.read32(outputPtr), outputLength);
        // printLine("Payload: " + outputString + " (length=" + outputLength + ")");
        CModule.free(outputPtr);
        CModule.free(outputLengthPtr);
        Assert.assertNotNull(outputString);
        Assert.assertEquals(outputString.length, outputLength);
        Assert.assertEquals(outputString, "HelloWorld");
    }
}
}

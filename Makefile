#
# =BEGIN MIT LICENSE
# 
# The MIT License (MIT)
#
# Copyright (c) 2014 The CrossBridge Team
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 
# =END MIT LICENSE
#

# Purpose: CrossBridge SWC Library Makefile
# Author: Andras Csizmadia
# Version: 1.0.0
# Platform: Windows
# Runtime: Cygwin with FlasCC

# @see: http://www.adobe.com/devnet-docs/flascc/README.html

# FlashCC SDK root
FLASCC:=$(FLASCC_ROOT)/sdk

# ASC2 Compiler arguments
$?AS3COMPILERARGS=java $(JVMARGS) -jar $(call nativepath,$(FLASCC)/usr/lib/asc2.jar) -merge -md

# C/C++ Compiler arguments
CCOMPARGS:=-Wall -Wextra -Wno-write-strings -Wno-trigraphs -O4 -jvmopt=-Xmx1G

# Path helper
$?UNAME=$(shell uname -s)
ifneq (,$(findstring CYGWIN,$(UNAME)))
	$?nativepath=$(shell cygpath -at mixed $(1))
	$?unixpath=$(shell cygpath -at unix $(1))
else
	$?nativepath=$(abspath $(1))
	$?unixpath=$(abspath $(1))
endif
  
# Default make target
all: clean swig abc obj swc swf

# Clean up build files
clean:
	@echo "-------------------------------------------- Clean --------------------------------------------"
	rm -rf build/
	rm -rf publish/
	rm -rf temp/
	mkdir -p build
	mkdir -p publish
	mkdir -p temp

# Generate SWIG AS3 Wrappers
swig:
	@echo "-------------------------------------------- SWIG --------------------------------------------"
	"$(FLASCC)/usr/bin/swig" -I./. -as3 -module ClientLib -outdir . -includeall -ignoremissing -o ClientLib_wrapper.c $(PWD)/as3api.h

# Generate ABC ByteCode
abc:
	@echo "-------------------------------------------- ABC --------------------------------------------"
	$(AS3COMPILERARGS) -abcfuture -AS3 \
				-import $(call nativepath,$(FLASCC)/usr/lib/builtin.abc) \
				-import $(call nativepath,$(FLASCC)/usr/lib/playerglobal.abc) \
				ClientLib.as
	mv ClientLib.as temp/ClientLib.as
	mv ClientLib.abc temp/ClientLib.abc
   
# Generate linker OBJ   
obj:
	@echo "-------------------------------------------- OBJ --------------------------------------------"
	"$(FLASCC)/usr/bin/gcc" $(CCOMPARGS) -c ClientLib_wrapper.c -o temp/ClientLib_wrapper.o
	cp -f exports.txt temp/ 
	"$(FLASCC)/usr/bin/nm" temp/ClientLib_wrapper.o | grep ' T ' | sed 's/.*__/_/' | sed 's/.* T //' >> temp/exports.txt
 
# Generate library SWC 
swc:
	@echo "-------------------------------------------- SWC --------------------------------------------"
	"$(FLASCC)/usr/bin/gcc" $(CCOMPARGS) temp/ClientLib.abc \
        ClientLib_wrapper.c \
        ClientLib.h \
        ClientLib.c \
        -flto-api=temp/exports.txt -swf-version=25 -emit-swc=app.ClientLib -o publish/ClientLib.swc -lcrypto
	mv ClientLib_wrapper.c temp/ClientLib_wrapper.c

# Generate test SWF
swf:
	@echo "-------------------------------------------- SWF --------------------------------------------"
	"$(FLASCC_AIR_ROOT)/bin/mxmlc" -swf-version=25 -library-path+=publish/ClientLib.swc src/main/actionscript/ClientLibExample.as -debug=false -optimize -remove-dead-code -o build/ClientLibExample.swf

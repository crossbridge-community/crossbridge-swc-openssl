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

# Author: Andras Csizmadia

# Detect host 
$?UNAME=$(shell uname -s)
#$(info $(UNAME))
ifneq (,$(findstring CYGWIN,$(UNAME)))
	$?nativepath=$(shell cygpath -at mixed $(1))
	$?unixpath=$(shell cygpath -at unix $(1))
else
	$?nativepath=$(abspath $(1))
	$?unixpath=$(abspath $(1))
endif

# CrossBridge SDK Home
ifneq "$(wildcard $(call unixpath,$(FLASCC_ROOT)/sdk))" ""
 $?FLASCC:=$(call unixpath,$(FLASCC_ROOT)/sdk)
else
 $?FLASCC:=/path/to/crossbridge-sdk/
endif
$?ASC2=java -jar $(call nativepath,$(FLASCC)/usr/lib/asc2.jar) -merge -md -parallel

# Auto Detect AIR/Flex SDKs
ifneq "$(wildcard $(AIR_HOME)/lib/compiler.jar)" ""
 $?FLEX=$(AIR_HOME)
else
 $?FLEX:=/path/to/adobe-air-sdk/
endif

# C/CPP Compiler
CCOMPARGS:=-Wall -Wextra -Wno-write-strings -Wno-trigraphs -O4
  
# Default make target
all: clean swig abc obj swc swf

# Clean up build files
clean:
	@echo "-------------------------------------------- Clean --------------------------------------------"
	rm -rf build/
	rm -rf release/
	rm -rf temp/
	mkdir -p build
	mkdir -p release
	mkdir -p temp

# Generate SWIG AS3 Wrappers
swig:
	@echo "-------------------------------------------- SWIG --------------------------------------------"
	"$(FLASCC)/usr/bin/swig" -I./. -as3 -module ClientLib -outdir . -includeall -ignoremissing -o ClientLib_wrapper.c $(PWD)/as3api.h

# Generate ABC ByteCode
abc:
	@echo "-------------------------------------------- ABC --------------------------------------------"
	$(ASC2) -abcfuture -AS3 \
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
        -flto-api=temp/exports.txt -swf-version=26 -emit-swc=crossbridge.OpenSSL -o release/crossbridge-openssl.swc -lcrypto
	mv ClientLib_wrapper.c temp/ClientLib_wrapper.c

# Generate test SWF
swf:
	@echo "-------------------------------------------- SWF --------------------------------------------"
	"$(FLEX)/bin/mxmlc" -advanced-telemetry -swf-version=26 -library-path+=release/crossbridge-openssl.swc src/main/actionscript/Main.as -debug=false -optimize -remove-dead-code -o build/Main.swf

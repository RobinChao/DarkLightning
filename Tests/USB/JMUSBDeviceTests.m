/**
 *	The MIT License (MIT)
 *
 *	Copyright (c) 2015 Jens Meder
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of
 *	this software and associated documentation files (the "Software"), to deal in
 *	the Software without restriction, including without limitation the rights to
 *	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *	the Software, and to permit persons to whom the Software is furnished to do so,
 *	subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in all
 *	copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Kiwi/Kiwi.h>
#import "JMUSBDevice.h"

SPEC_BEGIN(JMUSBMuxDeviceTests)

describe(@"JMUSBDevice",
^{
	context(@"when initializing",
	^{
		it(@"should return nil if no plist dictionary has been passed",
		^{
			JMUSBDevice* device = [[JMUSBDevice alloc]initWithPList:nil];
			
			[[device should] beNil];
		});
		
		it(@"should return nil if plist dictionary does not contain a device id",
		   ^{
			   JMUSBDevice* device = [[JMUSBDevice alloc]initWithPList:@{@"a":@1}];
			   
			   [[device should] beNil];
		   });
		
		it(@"should return a device if the plist dictionary is valid",
		   ^{
			   JMUSBDevice* device = [[JMUSBDevice alloc]initWithPList:@{@"Properties":@{@"DeviceID":@1}}];
			   
			   [[device shouldNot] beNil];
		   });
	});
});

SPEC_END

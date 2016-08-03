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

@import Kiwi;
#import "JMTaggedPacketProtocol.h"

SPEC_BEGIN(JMTaggedPacketProtocolTests)

describe(@"JMTaggedPacketProtocol", ^{
	
	context(@"when initializing", ^{
		
		it(@"should be possible to create an instance", ^{
			
			JMTaggedPacketProtocol* packetProtocol = [[JMTaggedPacketProtocol alloc]init];
			[packetProtocol shouldNotBeNil];
		});
		
	});
	
	context(@"when encoding data", ^{
		
		__block JMTaggedPacketProtocol* packetProtocol = nil;
		
		beforeEach(^{
			
			packetProtocol = [[JMTaggedPacketProtocol alloc]init];
		});
		
		it(@"should be impossible to encode nil", ^{
			
			NSData* encodedData = [packetProtocol encodePacket:nil];
			[[encodedData should] equal:[NSData data]];
		});
		
	});
	
	context(@"when processing data", ^{
		
		__block JMTaggedPacketProtocol* packetProtocol = nil;
		
		beforeEach(^{
			
			packetProtocol = [[JMTaggedPacketProtocol alloc]init];
		});
		
		it(@"should be impossible to process nil", ^{
			
			NSArray<JMTaggedPacket*>* data = [packetProtocol processData:nil];
			[[data should]equal:@[]];
		});
		
		it(@"should be impossible to process an empty data packet", ^{
			
			NSArray<JMTaggedPacket*>* data = [packetProtocol processData:[NSData data]];
			[[data should] equal:@[]];
		});
	});
});

SPEC_END

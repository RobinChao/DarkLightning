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
#import "JMNativeSocket.h"

SPEC_BEGIN(JMNativeSocketTests)

describe(@"JMNativeSocket",
		 ^{
			 context(@"when initializing",
					 ^{
						 it(@"should return nil if native socket is invalid",
							^{
								JMNativeSocket* socket = [[JMNativeSocket alloc]initWithNativeSocket:-1];
								
								[[socket should] beNil];
							});
						 
						 it(@"should return a new socket if native socket is valid",
							^{
								JMNativeSocket* socket = [[JMNativeSocket alloc]initWithNativeSocket:5];
								
								[[socket shouldNot] beNil];
							});
					 });
			 
			 context(@"when disconnected",
					 ^{
						 it(@"should have nil input and ouput streams", ^{
							 
							 JMNativeSocket* socket = [[JMNativeSocket alloc]initWithNativeSocket:5];
							 
							 [[theValue([socket disconnect]) should] beTrue];
							 [[socket.inputStream should] beNil];
							 [[socket.outputStream should] beNil];
						 });
					 });
			 
			 context(@"when connecting",
					 ^{
						 it(@"should return true on connect", ^{
							
							 JMNativeSocket* socket = [[JMNativeSocket alloc]initWithNativeSocket:5];
							 
							 [[theValue([socket connect]) should] beTrue];
						 });
						 
						 it(@"should return false if already connected", ^{
							 
							 JMNativeSocket* socket = [[JMNativeSocket alloc]initWithNativeSocket:5];
							 
							 [socket connect];
							 [[theValue([socket connect]) should] beFalse];
						 });
						 
						 it(@"should change state from disconnected to connected", ^{
							 
							 JMNativeSocket* socket = [[JMNativeSocket alloc]initWithNativeSocket:5];
							 
							 [socket connect];
							 [[theValue(socket.state) should]equal:theValue(JMSocketStateConnected)];
						 });
					 });
			 
			 context(@"when connected",
					 ^{
						 it(@"should have non nil input and ouput streams", ^{
							 
							 JMNativeSocket* socket = [[JMNativeSocket alloc]initWithNativeSocket:5];
							 
							 [[theValue([socket connect]) should] beTrue];
							 [[socket.inputStream should] beNonNil];
							 [[socket.outputStream should] beNonNil];
						 });
					 });
			 
			 context(@"when disconnecting",
					 ^{
						 it(@"should return true on disconnect if connected", ^{
							 
							 JMNativeSocket* socket = [[JMNativeSocket alloc]initWithNativeSocket:5];
							 
							 [socket connect];
							 [[theValue([socket disconnect]) should] beTrue];
						 });
						 
						 it(@"should return true on disconnect if already disconnected", ^{
							 
							 JMNativeSocket* socket = [[JMNativeSocket alloc]initWithNativeSocket:5];
							 
							 [[theValue([socket disconnect]) should] beTrue];
						 });
						 
						 it(@"should change state from connected to disconnected", ^{
							 
							 JMNativeSocket* socket = [[JMNativeSocket alloc]initWithNativeSocket:5];
							 
							 [socket connect];
							 [[theValue(socket.state) should]equal:theValue(JMSocketStateConnected)];
							 [socket disconnect];
							 [[theValue(socket.state) should]equal:theValue(JMSocketStateDisconnected)];
						 });
				 
			 });
		 });

SPEC_END
//
//  JMSocketConnection.m
//  DarkLightning
//
//  Created by Jens Meder on 17/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMSocketConnection.h"

static NSUInteger JMSocketConnectionBufferSize	= 1 << 16;

@interface JMSocketConnection () <NSStreamDelegate>

@end

@implementation JMSocketConnection
{
	@private
	
	NSRunLoop* _backgroundRunLoop;
}

-(instancetype)initWithSocket:(id<JMSocket>)socket
{
	if (!socket)
	{
		return nil;
	}
	
	self = [super init];
	
	if (self)
	{
		_socket = socket;
		_connectionState = JMSocketConnectionStateDisconnected;
	}
	
	return self;
}

-(BOOL)connect
{
	if (self.connectionState == JMSocketStateConnected)
	{
		return NO;
	}
	
	if (![_socket connect])
	{
		return NO;
	}
	
	_socket.inputStream.delegate = self;
	_socket.outputStream.delegate = self;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
	^{
		_backgroundRunLoop = [NSRunLoop currentRunLoop];
		[_socket.inputStream scheduleInRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
		[_socket.outputStream scheduleInRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
					   
		[_socket.inputStream open];
		[_socket.outputStream open];
					   
		[_backgroundRunLoop run];
					   
	});
	
	return YES;
}

-(BOOL)disconnect
{
	if (self.connectionState == JMSocketConnectionStateDisconnected)
	{
		return NO;
	}
	
	_socket.inputStream.delegate = nil;
	_socket.outputStream.delegate = nil;
	
	[_socket.inputStream removeFromRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
	[_socket.outputStream removeFromRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
	
	[_socket.inputStream close];
	[_socket.outputStream close];
	
	_backgroundRunLoop = nil;
	
	self.connectionState = JMSocketConnectionStateDisconnected;
	
	return [_socket disconnect];
}


-(BOOL)writeData:(NSData *)data
{
	if (!data || data.length == 0 || _connectionState != JMSocketConnectionStateConnected)
	{
		return NO;
	}
	
	NSInteger bytesWritten = [_socket.outputStream write:data.bytes maxLength:data.length];
	
	if(bytesWritten > 0)
	{
		return YES;
	}
	
	return NO;
}

#pragma mark - Properties

-(void)setConnectionState:(JMSocketConnectionState)connectionState
{
	if (connectionState == _connectionState)
	{
		return;
	}
	
	_connectionState = connectionState;
	
	if ([_delegate respondsToSelector:@selector(connection:didChangeState:)])
	{
		[_delegate connection:self didChangeState:_connectionState];
	}
}

#pragma mark - Stream Delegate

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
	dispatch_async(dispatch_get_main_queue(),
	^{
		if (self.connectionState != JMSocketConnectionStateConnected &&
			eventCode == NSStreamEventHasSpaceAvailable &&
			_socket.inputStream.streamStatus == NSStreamStatusOpen &&
			_socket.outputStream.streamStatus == NSStreamStatusOpen)
		{
			self.connectionState = JMSocketConnectionStateConnected;
		}
		else if(eventCode == NSStreamEventHasBytesAvailable)
		{
			NSMutableData* data = [NSMutableData data];
			uint8_t buffer[JMSocketConnectionBufferSize];
						   
			while (_socket.inputStream.hasBytesAvailable)
			{
				NSInteger length = [_socket.inputStream read:buffer maxLength:JMSocketConnectionBufferSize];
				[data appendBytes:buffer length:length];
			}
						   
			if (!data.length)
			{
				return;
			}
						   
			if ([_delegate respondsToSelector:@selector(connection:didReceiveData:)])
			{
				[_delegate connection:self didReceiveData:data];
			}
		}
		else if (eventCode == NSStreamEventEndEncountered)
		{
			[self disconnect];
		}
		else if(eventCode == NSStreamEventErrorOccurred && self.connectionState == JMSocketConnectionStateConnecting)
		{
			[self disconnect];
		}
	});
}

@end
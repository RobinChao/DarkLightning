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

#import "JMUSBDevice.h"

static NSString* const JMUSBDeviceDictionaryKeyProperties 		= @"Properties";

static NSString* const JMUSBDeviceDictionaryKeyDeviceID 		= @"DeviceID";
static NSString* const JMUSBDeviceDictionaryKeySerialNumber 	= @"SerialNumber";
static NSString* const JMUSBDeviceDictionaryKeyConnectionSpeed 	= @"ConnectionSpeed";
static NSString* const JMUSBDeviceDictionaryKeyProductID 		= @"ProductID";
static NSString* const JMUSBDeviceDictionaryKeyLocationID 		= @"LocationID";

@implementation JMUSBDevice

+(instancetype)invalidUSBDevice
{
	static JMUSBDevice* device = nil;
	
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		
		device = [[self alloc]initWithPList:@{JMUSBDeviceDictionaryKeySerialNumber:@"Invalid device"}];
	});
	
	return device;
}

-(instancetype)init
{
	return [self initWithPList:@{}];
}

-(instancetype)initWithPList:(NSDictionary *)plist
{
	NSDictionary* properties = plist[JMUSBDeviceDictionaryKeyProperties];
	
	if (!properties || !properties[JMUSBDeviceDictionaryKeyDeviceID])
	{
		return nil;
	}
	
	self = [super init];
	
	if (self)
	{
		_deviceID			= properties[JMUSBDeviceDictionaryKeyDeviceID];
		_serialNumber		= properties[JMUSBDeviceDictionaryKeySerialNumber];
		_connectionSpeed	= properties[JMUSBDeviceDictionaryKeyConnectionSpeed];
		_productID			= properties[JMUSBDeviceDictionaryKeyProductID];
		_locationID			= properties[JMUSBDeviceDictionaryKeyLocationID];
	}
	
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"DeviceID: %@, SerialNumber: %@, ConnectionSpeed: %@, ProductID: %@, LocationID: %@", _deviceID, _serialNumber, _connectionSpeed, _productID, _locationID];
}

-(BOOL)isEqual:(id)object {
	
	BOOL isEqual = NO;
	
	if ([object isKindOfClass:[JMUSBDevice class]]) {
		
		JMUSBDevice* obj = object;
		isEqual = [_serialNumber isEqualToString:obj.serialNumber];
	}
	
	return isEqual;
}

-(NSUInteger) hash
{
	return _serialNumber.hash;
}

@end

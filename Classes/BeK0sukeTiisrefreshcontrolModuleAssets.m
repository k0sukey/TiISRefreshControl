/**
 * This is a generated file. Do not edit or your changes will be lost
 */
#import "BeK0sukeTiisrefreshcontrolModuleAssets.h"

extern NSData* filterDataInRange(NSData* thedata, NSRange range);

@implementation BeK0sukeTiisrefreshcontrolModuleAssets

- (NSData*) moduleAsset
{
	//##TI_AUTOGEN_BEGIN asset

	static UInt8 data[] = {
		0xb3,0xd1,0x2d,0x66,0x2f,0xb3,0xfa,0x03,0xbb,0xd3,0xc6,0x26,0xd9,0x8a,0x08,0x25,0x77,0xb2,0x18,0x8e
		,0x4a,0x63,0xce,0xbe,0xbf,0xe0,0xe8,0xde,0xa7,0x05,0xed,0x83,0xa7,0xac,0xd9,0x71,0x99,0xa9,0xdd,0x09
		,0x9f,0x3c,0x3e,0xc8,0x62,0xed,0x7d,0xfc,0x13,0xb2,0x30,0x5e,0x74,0x75,0xac,0x49,0x43,0x80,0xba,0x70
		,0x88,0xc1,0xa2,0x6c,0xaf,0x81,0xe6,0xff,0x21,0xdd,0xf7,0x9c,0x25,0xc5,0x74,0x2b,0x9a,0x40,0x83,0x7a
		,0x78,0x3a,0x03,0xdf,0x62,0x9a,0xbd,0xdb,0x84,0xa4,0xbe,0x52,0x6d,0xd9,0x6b,0x4c,0x10,0x90,0xfe,0xe7
		,0xdb,0x5e,0xad,0x1b,0x89,0xe4,0xec,0x17,0x65,0x4a,0xf7,0xb8,0xe1,0x27,0xb4,0xe1,0x6a,0x7e,0x02,0x98
		,0x8f,0x9e,0x3b,0x5b,0xe4,0x14,0x3f,0x20	};
	static NSRange ranges[] = {
		{0,96}
	};
	static NSDictionary *map = nil;
	if (map == nil) {
		map = [[NSDictionary alloc] initWithObjectsAndKeys:
		[NSNumber numberWithInteger:0], @"be_k0suke_tiisrefreshcontrol_js",
		nil];
	}


	return filterDataInRange([NSData dataWithBytesNoCopy:data length:sizeof(data) freeWhenDone:NO], ranges[0]);
//##TI_AUTOGEN_END asset
}

- (NSData*) resolveModuleAsset:(NSString*)path
{
	//##TI_AUTOGEN_BEGIN resolve_asset

	static UInt8 data[] = {
		0xc4,0x9a,0x10,0x31,0xe5,0x34,0x9d,0xa4,0xf6,0xc6,0x6c,0x13,0x99,0xa7,0x4f,0xf8,0xe7,0xd9,0x6f,0xdc
		,0x35,0x5d,0xe6,0x63,0xa0,0x5b,0xad,0x6e,0x47,0x6a,0x94,0x39,0x0c,0xdd,0x93,0x98,0x1b,0xba,0x97,0x3e
		,0x34,0x90,0x27,0x04,0xc1,0x18,0x5c,0x2a,0x60,0x8f,0x0e,0x98,0xe7,0x01,0xcd,0x97,0x82,0x31,0x06,0x82
		,0x51,0x24,0xfc,0x32,0xb6,0x52,0x93,0xd4,0x7c,0x7c,0x42,0x0a,0x4b,0x9e,0x86,0xcb,0x63,0x83,0xdc,0x81
		,0xbd,0x66,0xe7,0xff,0x39,0xc9,0x83,0x42,0x52,0x2c,0xc5,0x48,0x10,0x78,0x57,0xee,0x72,0x5a,0x90,0x22
		,0xee,0x74,0x94,0xc7,0xfb,0x28,0x12,0x16,0x27,0xc1,0x57,0x07,0xbd,0x40,0x5c,0x1b,0xe9,0xaf,0xdf,0xe4
		,0x38,0x64,0x0a,0xa8,0xd9,0x7e,0x61,0xcc	};
	static NSRange ranges[] = {
		{0,96}
	};
	static NSDictionary *map = nil;
	if (map == nil) {
		map = [[NSDictionary alloc] initWithObjectsAndKeys:
		[NSNumber numberWithInteger:0], @"be_k0suke_tiisrefreshcontrol_js",
		nil];
	}


	NSNumber *index = [map objectForKey:path];
	if (index == nil) {
		return nil;
	}
	return filterDataInRange([NSData dataWithBytesNoCopy:data length:sizeof(data) freeWhenDone:NO], ranges[index.integerValue]);
//##TI_AUTOGEN_END resolve_asset
}

@end

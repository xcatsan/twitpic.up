//
//  TwitpicData.h
//
//  Copyright 2010 Hiroshi Hashiguchi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TwitpicData : NSObject {

	NSString* imagePath;
	NSString* message;
	NSString* information;
}

@property (copy) NSString* imagePath;
@property (copy) NSString* message;
@property (copy) NSString* information;

@end

//
//  UploadWindowController.h
//  twitpic.up
//
//  Created by 湖 on 10/04/03.
//  Copyright 2010 Hiroshi Hashiguchi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppController;
@class TwitpicData;
@class TwitpicRequest;

@interface UploadWindowController : NSObject {

	AppController* appController_;

	IBOutlet NSWindow* window_;
	IBOutlet NSView* waitView_;
	IBOutlet NSImageView* imageView;

	NSString* statusMessage_;
	TwitpicData* twitpicData_;
	TwitpicRequest* twitpicRequest_;
	
}

@property (retain) TwitpicData* twitpicData;
@property (retain) TwitpicRequest* twitpicReuqest;
@property (copy) NSString* statusMessage;

+ (UploadWindowController*)controllerWithAppController:(AppController*)appController twitpicData:(TwitpicData*)twitpicData;

-(IBAction)send:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)cancelRequest:(id)sender;

@end

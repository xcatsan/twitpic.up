//
//  AppController.h
//
//  Copyright 2010 Hiroshi Hashiguchi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AuthenticationController;
@class UploadWindowController;
@class LoginAccount;

@interface AppController : NSObject <NSApplicationDelegate> {
	
	AuthenticationController* authenticationWindowController_;
	NSMutableArray* uploadWindowControllers_;
	
	LoginAccount* loginAccount_;
	
	IBOutlet NSTextView* logTextView_;
	
}

@property (retain) AuthenticationController* authenticationWindowController;
@property (retain) LoginAccount* loginAccount;

- (void)closeWithUploadWindowController:(UploadWindowController*)controller;

- (void)saveLoginId;

- (void)log:(NSString*)message;

@end

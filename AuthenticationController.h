//
//  AuthenticationController.h
//
//  Copyright 2010 Hiroshi Hashiguchi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LoginAccount;
@interface AuthenticationController : NSObject {

	IBOutlet NSWindow* window_;
	IBOutlet NSTextField* loginIdTextField_;
	IBOutlet NSSecureTextField* passwordTextField_;

	NSString* loginId_;
	NSString* password_;

	NSString* message_;
	
	int state_;

}

@property (copy) NSString* loginId;
@property (copy) NSString* password;

@property (retain) NSString* message;

-(BOOL)getLoginAccount:(LoginAccount*)loginAccount attachedWindow:(NSWindow*)window;

-(BOOL)deleteLoginAccount:(LoginAccount*)loginAccount;

-(IBAction)login:(id)sender;
-(IBAction)cancel:(id)cancel;
@end



//
//  AuthenticationController.m
//
//  Copyright 2010 Hiroshi Hashiguchi. All rights reserved.
//

#import "AuthenticationController.h"
#import "AccountManager.h"
#import "LoginAccount.h"

enum AC_STATE {
	AC_STATE_INITIALIZED,
	AC_STATE_START,
	AC_STATE_SUCCEEDED,
	AC_STATE_CANCELED,
};

@implementation AuthenticationController

@synthesize loginId = loginId_;
@synthesize password = password_;
@synthesize message = message_;

#pragma mark -
#pragma mark Initilizer and Deallocation
-(id)init
{
	self = [super init];
	if (self) {
		if (![NSBundle loadNibNamed:@"AuthenticationWindow"
							 owner:self]) {
			self = nil;
		}
		state_ = AC_STATE_INITIALIZED;
	}
	return self;

}

- (void) dealloc
{
	self.loginId = nil;
	self.password = nil;
	self.message = nil;

	[super dealloc];
}


#pragma mark -
#pragma mark Public accessors
-(BOOL)getLoginAccount:(LoginAccount*)loginAccount attachedWindow:(NSWindow*)attachedWindow
{
	state_ = AC_STATE_START;

	if (loginAccount.loginId) {
		self.loginId = loginAccount.loginId;
		if (!loginAccount.password) {
			if ([[AccountManager sharedManager]
				 setPasswordToLoginAccount:loginAccount]) {
				self.password = loginAccount.password;
			}
		}
	}
	
	[window_ makeFirstResponder:loginIdTextField_];
	
	if (loginAccount.isInvalidAccount) {
		self.message = @"Invalid twitter username or password";
	} else {
		self.message = @"";
	}

	[NSApp beginSheet:window_
	   modalForWindow:attachedWindow
		modalDelegate:nil
	   didEndSelector:nil
		  contextInfo:nil];
	[NSApp runModalForWindow:window_];
	
	// dialog is up here (wait for closing)

	[NSApp endSheet:window_];
	[window_ orderOut:nil];
	
	if (state_ == AC_STATE_SUCCEEDED) {
		loginAccount.loginId = self.loginId;
		loginAccount.password = self.password;
		
		[[AccountManager sharedManager] storeLoginAccount:loginAccount];
		return YES;

	} else {
		return NO;
	}
}


-(IBAction)login:(id)sender
{

	if (!self.loginId  || [self.loginId length] == 0) {
		self.message = @"Username is empty";
		[window_ makeFirstResponder:loginIdTextField_];
		return;
	}
	if (!self.password || [self.password length] == 0) {
		self.message = @"Password is empty";
		[window_ makeFirstResponder:passwordTextField_];
		return;
	}
	
	state_ = AC_STATE_SUCCEEDED;
	[NSApp stopModal];
}

-(IBAction)cancel:(id)cancel
{
	state_ = AC_STATE_CANCELED;
	[NSApp stopModal];
}

-(BOOL)deleteLoginAccount:(LoginAccount*)loginAccount
{
	return [[AccountManager sharedManager] deleteLoginAccount:loginAccount];
}


@end

//
//  AppController.m
//
//  Created by 湖 on 10/04/03.
//  Copyright 2010 Hiroshi Hashiguchi. All rights reserved.
//

#import "AppController.h"
#import "UploadWindowController.h"
#import "TwitpicData.h"
#import "AuthenticationController.h"
#import "LoginAccount.h"

#define DEFAULT_LOGINID	@"loginId"
#define SERVICE_NAME @"com.xcatsan.twitpic.up"

@implementation AppController

@synthesize authenticationWindowController = authenticationWindowController_;
@synthesize loginAccount = loginAccount_;

#pragma mark -
#pragma mark Initialization & Deallcation
- (id)init
{
	self = [super init];
	if (self) {
		uploadWindowControllers_ = [[NSMutableArray alloc] init];
		loginAccount_ = [[LoginAccount alloc] init];		
		loginAccount_.loginId =
		[[NSUserDefaults standardUserDefaults] valueForKey:DEFAULT_LOGINID];
		loginAccount_.serviceName = SERVICE_NAME;
		
	}
	return self;
}
- (void) dealloc
{
	self.loginAccount = nil;
	[uploadWindowControllers_ release];
	[super dealloc];
}

#pragma mark -
#pragma mark Utilities
- (void)log:(NSString*)message
{
	[logTextView_ insertText:[NSString stringWithFormat:@"%@ %@\n",
							   [NSDate date], message]];
}

#pragma mark -
#pragma mark Manage upload window
- (void)openUploadWindowWithData:(TwitpicData*)data
{
	if (!data) {
		data = [[[TwitpicData alloc] init] autorelease];
	}
	[uploadWindowControllers_ addObject:
	 [UploadWindowController controllerWithAppController:self
											 twitpicData:data]];
}

- (void)closeWithUploadWindowController:(UploadWindowController*)controller
{
	[uploadWindowControllers_ removeObject:controller];
}

- (void)saveLoginId
{
	[[NSUserDefaults standardUserDefaults]
		setValue:self.loginAccount.loginId
		  forKey:DEFAULT_LOGINID];
}


#pragma mark -
#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	authenticationWindowController_ = [[AuthenticationController alloc] init];
	
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
	TwitpicData* data = [[[TwitpicData alloc] init] autorelease];
	
	if ([filenames count] > 0) {
		for (int i=0; i < [filenames count]; i++) {
			NSString* arg = [filenames objectAtIndex:i];
			switch (i) {
				case 0:
					data.imagePath = arg;
					break;
				case 1:
					data.message = arg;
					break;
			}
		}
	}
	[self openUploadWindowWithData:data];
}

@end

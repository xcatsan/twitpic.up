//
//  UploadWindowController.m
//  twitpic.up
//
//  Created by 湖 on 10/04/03.
//  Copyright 2010 Hiroshi Hashiguchi. All rights reserved.
//

#import "UploadWindowController.h"
#import "AppController.h"
#import "TwitpicData.h"
#import "AuthenticationController.h"
#import "LoginAccount.h"
#import "TwitpicRequest.h"

static NSPoint nextTopLeft;

@implementation UploadWindowController
@synthesize twitpicData = twitpicData_;
@synthesize twitpicReuqest = twitpicRequest_;
@synthesize statusMessage = statusMessage_;

#pragma mark -
#pragma mark Initilizer and Deallocation
-(id)initWithAppController:(AppController*)appController twitpicData:(TwitpicData*)twitpicData
{
	self = [super init];
	if (self) {
		if ([NSBundle loadNibNamed:@"UploadWindow"
							  owner:self]) {
			appController_ = appController;
			self.twitpicData = twitpicData;
			
			nextTopLeft = [window_ cascadeTopLeftFromPoint:nextTopLeft]; 
			
			// TODO: refactoring
			NSError* error = nil;
			NSDictionary* attrs = [[NSFileManager defaultManager]
								   attributesOfItemAtPath:twitpicData.imagePath error:&error];
			float fileSize = [attrs fileSize] / 1024.0 / 1024.0;
			NSLog(@"%@", [imageView image]);
			NSSize imageSize = [[imageView image] size];
			self.twitpicData.information = [NSString stringWithFormat:@"%.0fx%.0f [%.1fMB]", imageSize.width, imageSize.height, fileSize];
			self.twitpicReuqest = [[TwitpicRequest alloc] init];
			[window_ setTitle:[twitpicData.imagePath lastPathComponent]];
			[window_ makeKeyAndOrderFront:nil];
		} else {
			self = nil;
		}
	}
	return self;
	
}

- (void) dealloc
{
	self.twitpicData = nil;
	self.twitpicReuqest = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Utilities

- (void)close
{
	[window_ orderOut:nil];
	[appController_ closeWithUploadWindowController:self];
}

- (void)setHideWaitView:(BOOL)flag
{
	[waitView_ setHidden:flag];
}

- (void)copyURL
{
	NSArray* urls = [NSArray arrayWithObject:
					 [NSURL URLWithString:[twitpicRequest_.response objectForKey:@"mediaurl"]]];
	NSPasteboard *pboard = [NSPasteboard generalPasteboard];
	NSArray *typeArray = [NSArray arrayWithObject:NSURLPboardType];
	[pboard declareTypes:typeArray owner:nil]; // 10.5
	[pboard writeObjects:urls]; // 10.6
}


#pragma mark -
#pragma mark Factory method
+ (UploadWindowController*)controllerWithAppController:(AppController*)appController twitpicData:(TwitpicData*)twitpicData;
{
	
	return [[[UploadWindowController alloc]
			 initWithAppController:appController twitpicData:twitpicData] autorelease];
}

#pragma mark -
#pragma mark Callback
-(BOOL)sendRequest
{
	LoginAccount* loginAccount = appController_.loginAccount;

	if (!loginAccount.isSucceeded) {
		if (![appController_.authenticationWindowController
			  getLoginAccount:loginAccount attachedWindow:window_]) {
			// cancel
			[waitView_ setHidden:YES];
			return NO;
			// TODO: CANCELED
		}
	}
	[twitpicRequest_ sendRequestWithData:twitpicData_
							loginAccount:loginAccount
								delegate:self];
	return YES;
}

-(void)requestFinished
{
	[appController_ log:[twitpicRequest_.response description]];
	
	LoginAccount* loginAccount = appController_.loginAccount;

	if (twitpicRequest_.result) {
		[loginAccount changeStateToSuccess];
		[appController_ saveLoginId];
		self.statusMessage = @"Success!";
		[self close];
		[self copyURL];
		return;
		
	} else {
		NSLog(@"error: %@", twitpicRequest_.response);
		if ([twitpicRequest_ isAuthenticationFailed]) {
			[loginAccount changeStateToInvalid];
			NSLog(@"%@", loginAccount);
			[self sendRequest];
			return;
			// * not reached

		} else {
			// TODO: Handling error
			self.statusMessage = [[twitpicRequest_ response] objectForKey:@"errorMsg"];
			[self setHideWaitView:YES];
		}
		
	}
}

#pragma mark -
#pragma mark Event handler
-(IBAction)send:(id)sender
{
	[self setHideWaitView:NO];
	[self sendRequest];
}

-(IBAction)cancel:(id)sender
{
	[self close];
}

-(IBAction)cancelRequest:(id)sender
{
	[twitpicRequest_ cancel];
	self.statusMessage = @"user canceled";
	[self setHideWaitView:YES];
}


@end

//
//  TwitpicRequest.m
//  twitpic.up
//
//  Created by 湖 on 10/04/04.
//  Copyright 2010 Hiroshi Hashiguchi. All rights reserved.
//

#import "TwitpicRequest.h"
#import "ASIFormDataRequest.h"
#import "TBXML.h"
#import "LoginAccount.h"
#import "TwitpicData.h"


// Private stuff
@interface TwitpicRequest ()
@property (retain) ASIFormDataRequest* request;
@end

@implementation TwitpicRequest

@synthesize response = response_;
@synthesize result = result_;
@synthesize request = request_;

#pragma mark -
#pragma mark Initializatin & Deallocation
- (id) init
{
	self = [super init];
	if (self != nil) {
		self.response = [NSMutableDictionary dictionary];
		self.result = NO;
	}
	return self;
}

- (void) dealloc
{
	self.response = nil;
	self.request = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Manage upload window
- (void)openUploadWindow
{
}

#pragma mark -
#pragma mark Utilities
- (BOOL)parseWithResponseString:(NSString*)responseString toDictionary:(NSMutableDictionary*)dictionary
{
	BOOL result = NO;
	
	TBXML* tbxml = [TBXML tbxmlWithXMLString:responseString];
	
	TBXMLElement *element = tbxml.rootXMLElement;
	
	if (element) {
		NSString* status = [TBXML valueOfAttributeNamed:@"status"
											 forElement:element];
		NSString* stat = [TBXML valueOfAttributeNamed:@"stat"
										   forElement:element];
		
		if ((status && [status isEqualToString:@"ok"]) ||
			(stat && [stat isEqualToString:@"ok"])) {
			element = element->firstChild;
			
			do {
				NSString* key = [TBXML elementName:element];
				NSString* object = [TBXML textForElement:element];
				[dictionary setObject:object forKey:key];
				
			} while (element = element->nextSibling);
			
			result = true;
			
		} else if (stat && [stat isEqualToString:@"fail"]) {
			// fail
			element = element->firstChild;
			if (element) {
				NSString* errorCode = [TBXML valueOfAttributeNamed:@"code"
														forElement:element];
				NSString* errorMsg = [TBXML valueOfAttributeNamed:@"msg"
													   forElement:element];
				[dictionary setObject:errorCode forKey:@"errorCode"];
				[dictionary setObject:errorMsg forKey:@"errorMsg"];
			}
		} else {
			// error
			[dictionary setObject:@"-1" forKey:@"errorCode"];
			[dictionary setObject:@"[internal]parse error" forKey:@"errorMsg"];
		}
	}
	return result;
}

- (void)requestFinished:(ASIFormDataRequest *)request
{
	self.result = [self parseWithResponseString:[request responseString]
								   toDictionary:self.response];

	/* DEBUG
	NSLog(@"requestHeaders : %@", request.requestHeaders);
	NSLog(@"requestCookies : %@", request.requestCookies);
	NSLog(@"responseHeaders: %@", request.responseHeaders);
	NSLog(@"responseCookies: %@", request.responseCookies);
    */
	
	
	[delegate_ performSelector:@selector(requestFinished)];
}
- (void)requestFailed:(ASIFormDataRequest *)request
{
	NSError *error = [request error];
	NSLog(@"error: %@", error);
	self.result = NO;
	
	[delegate_ performSelector:@selector(requestFinished)];
}

-(void)sendRequestWithData:(TwitpicData*)data loginAccount:(LoginAccount*)loginAccount delegate:(id)delegate;
{
	delegate_ = delegate;

	NSURL *url;
	
	if (data.message && [data.message length]>0) {
		url = [NSURL URLWithString:@"http://twitpic.com/api/uploadAndPost"];
	} else {
		url = [NSURL URLWithString:@"http://twitpic.com/api/upload"];
	}
	
	self.request = [ASIFormDataRequest requestWithURL:url];
	self.request.shouldAttemptPersistentConnection = NO;
	[self.request setPostValue:loginAccount.loginId forKey:@"username"];
	[self.request setPostValue:loginAccount.password forKey:@"password"];
	[self.request setFile:data.imagePath forKey:@"media"];
	
	[self.request setPostValue:data.message forKey:@"message"];
	[self.request setDelegate:self];
	
	[self.request startAsynchronous];
}

-(BOOL)isAuthenticationFailed
{
	NSString* errorCode = [self.response objectForKey:@"errorCode"];
	if ([errorCode isEqualToString:@"1001"]) {
		return YES;
	} else {
		return NO;
	}
}

- (void)cancel
{
	[self.request cancel];
}

@end

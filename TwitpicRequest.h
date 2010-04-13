//
//  TwitpicRequest.h
//  twitpic.up
//
//  Created by 湖 on 10/04/04.
//  Copyright 2010 Hiroshi Hashiguchi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TwitpicData;
@class LoginAccount;
@class ASIFormDataRequest;

@interface TwitpicRequest : NSObject {

	NSMutableDictionary* response_;
	BOOL result_;
	id delegate_;
	
	ASIFormDataRequest* request_;
}

@property (retain) NSMutableDictionary* response;
@property (assign) BOOL result;

- (void)sendRequestWithData:(TwitpicData*)data loginAccount:(LoginAccount*)loginAccount delegate:(id)delegate;
- (BOOL)isAuthenticationFailed;
- (void)cancel;

@end

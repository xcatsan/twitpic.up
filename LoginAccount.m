//
//  Account.m
//
//  Copyright 2010 Hiroshi Hashiguchi. All rights reserved.
//

#import "LoginAccount.h"

enum {
	ACCOUNT_STATE_INITIALIZED,
	ACCOUNT_STATE_SUCCEEDED,
	ACCOUNT_STATE_INVALID
};

@implementation LoginAccount

@synthesize serviceName,loginId, password;

- (id)init
{
	self = [super init];
	if (self) {
		state_ = ACCOUNT_STATE_INITIALIZED;
	}
	return self;
}

- (void) dealloc
{
	self.serviceName = nil;
	self.loginId = nil;
	self.password = nil;

	[super dealloc];
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"%@: %@/%@",
			self.serviceName, self.loginId, self.password];
}

#pragma mark -
#pragma mark Change state
-(void)changeStateToSuccess
{
	state_ = ACCOUNT_STATE_SUCCEEDED;
}
-(void)changeStateToInvalid
{
	state_ = ACCOUNT_STATE_INVALID;
}

#pragma mark -
#pragma mark Accessors
-(BOOL)isSucceeded
{
	return (state_ == ACCOUNT_STATE_SUCCEEDED);
}
-(BOOL)isInvalidAccount
{
	return (state_ == ACCOUNT_STATE_INVALID);
}

@end

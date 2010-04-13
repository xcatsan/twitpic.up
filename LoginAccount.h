//
//  Account.h
//
//  Copyright 2010 Hiroshi Hashiguchi. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LoginAccount : NSObject {

	NSString* serviceName;
	NSString* loginId;
	NSString* password;
	
	int state_;
}

@property (copy) NSString* serviceName;
@property (copy) NSString* loginId;
@property (copy) NSString* password;
@property (assign, readonly) BOOL isSucceeded;
@property (assign, readonly) BOOL isInvalidAccount;

-(void)changeStateToSuccess;
-(void)changeStateToInvalid;

@end

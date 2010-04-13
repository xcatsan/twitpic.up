//
//  WaitScreen.m
//  twitpic.up
//
//  Created by 湖 on 10/04/09.
//  Copyright 2010 Hiroshi Hashiguchi. All rights reserved.
//

#import "WaitScreen.h"


@implementation WaitScreen

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	
	[[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.75] set];
	NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
	
}

- (void)mouseDown:(NSEvent *)theEvent
{
}

- (void)keyDown:(NSEvent *)theEvent
{
}

@end

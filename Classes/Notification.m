//
//  Notification.m
//  CarPool
//
//  Created by Madhura on 7/19/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "Notification.h"


@implementation Notification

@synthesize sentby;
@synthesize receivedby;
@synthesize message;

-(id)init {
	[super init];
	NSLog(@"Notification Init Called");
	[self setSentby:@""];
	[self setReceivedby:@""];
	[self setMessage:@""];
	return self; 
}


@end

//
//  Community.m
//  CarPool
//
//  Created by Madhura on 7/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "Community.h"


@implementation Community

@synthesize name;
@synthesize type;
@synthesize city;
@synthesize	state;
@synthesize description;
@synthesize moderator;

-(id)init {
	[super init];
	NSLog(@"Community Init Called");
	[self setName:@""];
	[self setType:@""];
	[self setCity:@""];
	[self setState:@""];
	[self setDescription:@""];
	[self setModerator:@""];
    return self; 
}

+ (Community *) getSharedInstance
{
    // the instance of this class is stored here
    static Community *commObj = nil;
	
    // check to see if an instance already exists
    if (nil == commObj) {
        commObj  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return commObj;
}

@end

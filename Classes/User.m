//
//  User.m
//  CarPool
//
//  Created by Madhura on 7/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize email;
@synthesize password;
@synthesize dob;
@synthesize	sex;
@synthesize location;
@synthesize usertype;

-(id)init {
	[super init];
	NSLog(@"User Init Called");
	[self setEmail:@""];
	[self setPassword:@""];
	[self setDob:@""];
	[self setLocation:@""];
	[self setSex:'U'];
	[self setUsertype:@""];
    return self; 
}
 
+ (User *) getSharedInstance
{
    // the instance of this class is stored here
    static User *userObj = nil;
	
    // check to see if an instance already exists
    if (nil == userObj) {
        userObj  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return userObj;
}

@end

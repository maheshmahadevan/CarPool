//
//  Community.h
//  CarPool
//
//  Created by Madhura on 7/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Community : NSObject {

	NSString *name;
	NSString *type;
	NSString *city;
	NSString *state;
	NSString *description;
	NSString *moderator;
}

@property (retain) NSString *name;
@property (retain) NSString *type;
@property (retain) NSString	*city;
@property (retain) NSString *state;
@property (retain) NSString *description;
@property (retain) NSString *moderator;

+ (Community *) getSharedInstance;


@end

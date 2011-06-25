//
//  User.h
//  CarPool
//
//  Created by Madhura on 7/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
	NSString *email;
	NSString *password;
	NSString *dob;
	char sex;
	NSString *location;
	NSString *usertype;

}

@property char sex;
@property (retain) NSString *email;
@property (retain) NSString *password;
@property (retain) NSString	*dob;
@property (retain) NSString *location;
@property (retain) NSString *usertype;

+ (User *) getSharedInstance;


@end

//
//  Notification.h
//  CarPool
//
//  Created by Madhura on 7/19/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Notification : NSObject {
	
	NSString *sentby;
	NSString *receivedby;
	NSString *message;

}
@property (retain) NSString *sentby;
@property (retain) NSString *receivedby;
@property (retain) NSString	*message;

@end

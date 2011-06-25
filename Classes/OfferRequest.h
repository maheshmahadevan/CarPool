//
//  OfferRequest.h
//  CarPool
//
//  Created by Madhura on 7/16/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OfferRequest : NSObject {
	
	char requestType;
	NSString *startPoint;
	NSString *endPoint;
	NSString	*date;
	NSString *time;
	NSString *additionalText;
	NSString *searchType;
	NSString *madeby;

}

@property char requestType;
@property (retain) NSString *startPoint;
@property (retain) NSString *endPoint;
@property (retain) NSString	*date;
@property (retain) NSString *time;
@property (retain) NSString *additionalText;
@property (retain) NSString *searchType;
@property (retain) NSString *madeby;

+ (OfferRequest *) getSharedInstance;

@end

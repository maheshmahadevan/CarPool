//
//  OfferRequest.m
//  CarPool
//
//  Created by Madhura on 7/16/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "OfferRequest.h"


@implementation OfferRequest

@synthesize requestType;
@synthesize startPoint;
@synthesize endPoint;
@synthesize	date;
@synthesize time;
@synthesize additionalText;
@synthesize searchType;
@synthesize madeby;


-(id)init {
	[super init];
	NSLog(@"Offer Request Init Called");
	[self setRequestType:'O'];
	[self setStartPoint:@""];
	[self setEndPoint:@""];
	[self setDate:@""];
	[self setTime:@""];
	[self setAdditionalText:@""];
	[self setMadeby:@""];
    return self; 
}

+ (OfferRequest *) getSharedInstance
{
    // the instance of this class is stored here
    static OfferRequest *offReqObj = nil;
	
    // check to see if an instance already exists
    if (nil == offReqObj) {
        offReqObj  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return offReqObj;
}

@end

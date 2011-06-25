//
//  OfferRequestXMLParser.h
//  CarPool
//
//  Created by Madhura on 7/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"OfferRequest.h"


@interface OfferRequestXMLParser : NSObject {
	NSMutableArray *offReqArrayObjs;
	NSMutableString *currentStringValue;
	NSXMLParser *xmlParser;
	OfferRequest *offReqObj;
	
	SEL dataFoundSelector;
	id parentController;
	
	
}

@property(nonatomic, retain) NSMutableArray *offReqArrayObjs;
@property(nonatomic, retain) NSMutableString *currentStringValue;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, assign) SEL dataFoundSelector;

@property(nonatomic, assign) id parentController;

-(id) initWithData:(NSData*) rawWSData;

@end

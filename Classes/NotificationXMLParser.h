//
//  NotificationXMLParser.h
//  CarPool
//
//  Created by Madhura on 7/19/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notification.h"


@interface NotificationXMLParser : NSObject {
	NSMutableArray *notArrayObjs;
	NSMutableString *currentStringValue;
	NSXMLParser *xmlParser;
	Notification *notObj;
	
	SEL dataFoundSelector;
	id parentController;
	
	
}

@property(nonatomic, retain) NSMutableArray *notArrayObjs;
@property(nonatomic, retain) NSMutableString *currentStringValue;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, assign) SEL dataFoundSelector;

@property(nonatomic, assign) id parentController;

-(id) initWithData:(NSData*) rawWSData;



@end

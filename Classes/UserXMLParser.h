//
//  UserXMLParser.h
//  CarPool
//
//  Created by Madhura on 7/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserXMLParser : NSObject {
	NSMutableArray *userArrayObjs;
	NSMutableString *currentStringValue;
	NSXMLParser *xmlParser;
	User *usrObj;
	
	SEL dataFoundSelector;
	id parentController;
	
	
}

@property(nonatomic, retain) NSMutableArray *userArrayObjs;
@property(nonatomic, retain) NSMutableString *currentStringValue;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, assign) SEL dataFoundSelector;

@property(nonatomic, assign) id parentController;

-(id) initWithData:(NSData*) rawWSData;

@end

//
//  UserXMLParser.m
//  CarPool
//
//  Created by Madhura on 7/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "UserXMLParser.h"


@implementation UserXMLParser

@synthesize userArrayObjs;
@synthesize xmlParser;
@synthesize currentStringValue;

@synthesize dataFoundSelector;
@synthesize parentController;

-(id) initWithData:(NSData*) rawWSData
{
	if ( self = [super init] )
    {
        xmlParser = [[NSXMLParser alloc] initWithData: rawWSData];
		[xmlParser setDelegate: self];
		[xmlParser setShouldResolveExternalEntities: YES];
		[xmlParser parse];
		//userArrayObjs =[[NSMutableArray alloc ] init];
    }
    return self;
}

-(void) dealloc
{
	[xmlParser release];
	[userArrayObjs release];
	userArrayObjs = nil;
	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	
	if([elementName isEqualToString:@"users"])
	{
		userArrayObjs = [[NSMutableArray alloc] init ];
	}
    else if( [elementName isEqualToString:@"user"])
	{
		//Reserve space for the "name" tag foundCharacters that we will receive next
		usrObj = [[User alloc] init];
		
		//Signal to foundCharacters that we are interested in recording the 
		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    [currentStringValue appendString:string];
	//currentStringValue = [currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{   
	NSString *currentString = currentStringValue;
	//NSLog(currentStringValue);
	currentString = [currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	//NSLog(currentString);
    if ([elementName isEqualToString:@"dob"]) {
        [usrObj setDob:currentString];
    } else if ([elementName isEqualToString:@"email"]) {
        [usrObj setEmail:currentString];
    } else if ([elementName isEqualToString:@"location"]) {
        [usrObj setLocation:currentString];
    }
	else if ([elementName isEqualToString:@"password"]) {
        [usrObj setPassword:currentString];
    }
	else if ([elementName isEqualToString:@"sex"]) {
        [usrObj setSex:[currentString characterAtIndex:0]];
    }
	else if ([elementName isEqualToString:@"usertype"]) {
        [usrObj setUsertype:currentString];
    }
	else if ([elementName isEqualToString:@"user"]) {
		
			[userArrayObjs addObject:usrObj ];
			[usrObj release];
		return;
	}
	else if  ([elementName isEqualToString:@"users"]) 
	{	
		[parentController performSelector:dataFoundSelector withObject:userArrayObjs];
		return;
	}
	[currentStringValue release];
     currentStringValue = nil;
	
}


@end

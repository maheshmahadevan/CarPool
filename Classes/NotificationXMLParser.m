//
//  NotificationXMLParser.m
//  CarPool
//
//  Created by Madhura on 7/19/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "NotificationXMLParser.h"


@implementation NotificationXMLParser

@synthesize notArrayObjs;
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
	[notArrayObjs release];
	notArrayObjs = nil;
	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	
	if([elementName isEqualToString:@"notifications"])
	{
		notArrayObjs = [[NSMutableArray alloc] init ];
	}
    else if( [elementName isEqualToString:@"notification"])
	{
		//Reserve space for the "name" tag foundCharacters that we will receive next
		notObj = [[Notification alloc] init];
		
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
	NSLog(@"Parser Called");
	NSString *currentString = currentStringValue;
	//NSLog(currentStringValue);
	currentString = [currentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	//NSLog(currentString);
    if ([elementName isEqualToString:@"message"]) {
        [notObj setMessage:currentString];
    } else if ([elementName isEqualToString:@"recipient"]) {
        [notObj setReceivedby:currentString];
    } else if ([elementName isEqualToString:@"sender"]) {
        [notObj setSentby:currentString];
    }
	else if ([elementName isEqualToString:@"notification"]) {
		
		[notArrayObjs addObject:notObj];
		[notObj release];
		return;
	}
	else if  ([elementName isEqualToString:@"notifications"]) 
	{	
		[parentController performSelector:dataFoundSelector withObject:notArrayObjs];
		return;
	}
	[currentStringValue release];
	currentStringValue = nil;
	
}



@end

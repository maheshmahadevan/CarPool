//
//  OfferRequestXMLParser.m
//  CarPool
//
//  Created by Madhura on 7/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "OfferRequestXMLParser.h"


@implementation OfferRequestXMLParser

@synthesize offReqArrayObjs;
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
	[offReqArrayObjs release];
	offReqArrayObjs = nil;
	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	
	if([elementName isEqualToString:@"offer-requests"])
	{
		offReqArrayObjs = [[NSMutableArray alloc] init ];
	}
    else if( [elementName isEqualToString:@"offer-request"])
	{
		//Reserve space for the "name" tag foundCharacters that we will receive next
		offReqObj = [[OfferRequest alloc] init];
		
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
    if ([elementName isEqualToString:@"additionalText"]) {
        [offReqObj setAdditionalText:currentString];
    } else if ([elementName isEqualToString:@"date"]) {
        [offReqObj setDate:currentString];
    } else if ([elementName isEqualToString:@"endPoint"]) {
        [offReqObj setEndPoint:currentString];
    }
	else if ([elementName isEqualToString:@"requestType"]) {
        [offReqObj setRequestType:[currentString characterAtIndex:0]];
    }
	else if ([elementName isEqualToString:@"searchType"]) {
        [offReqObj setSearchType:currentString ];
    }
	else if ([elementName isEqualToString:@"startPoint"]) {
        [offReqObj setStartPoint:currentString];
    }
	else if ([elementName isEqualToString:@"time"]) {
        [offReqObj setTime:currentString];
    }
	else if ([elementName isEqualToString:@"madeby"]) {
        [offReqObj setMadeby:currentString];
    }
	else if ([elementName isEqualToString:@"offer-request"]) {
		
		[offReqArrayObjs addObject:offReqObj];
		[offReqObj release];
		return;
	}
	else if  ([elementName isEqualToString:@"offer-requests"]) 
	{	
		[parentController performSelector:dataFoundSelector withObject:offReqArrayObjs];
		return;
	}
	[currentStringValue release];
	currentStringValue = nil;
	
}



@end

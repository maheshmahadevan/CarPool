//
//  WebServiceProcessor.h
//  CarPool
//
//  Created by Madhura on 7/15/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebServiceProcessor : NSObject {
	
	NSMutableData *rawWSData;
	NSString *wsTextResponse;
	NSString *responseCode;
	
	//SEL errorSelector;
	SEL successSelector;
	
	id viewController;
}

@property(nonatomic, retain) NSMutableData *rawWSData;
@property(nonatomic, retain) NSString *wsTextResponse;
@property(nonatomic, assign) NSString *responseCode;

//@property(nonatomic, assign) SEL errorSelector;
@property(nonatomic, assign) SEL successSelector;


@property (assign) id viewController;



@end

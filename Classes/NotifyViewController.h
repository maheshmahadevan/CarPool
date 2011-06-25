//
//  NotifyViewController.h
//  CarPool
//
//  Created by Madhura on 7/10/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceProcessor.h"
#import "Notification.h"
#import "User.h"
#import "NotificationXMLParser.h"

@interface NotifyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate >{
	UITableView *mainTableView;
	
	NSMutableArray *contentsList;
	NSMutableArray *searchResults;
	
	
	
	WebServiceProcessor *webServiceProcessor;
	UIActivityIndicatorView *activityIndicator;
	
}

@property(nonatomic, assign) WebServiceProcessor *webServiceProcessor;

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, retain) NSMutableArray *searchResults;

- (void) loadDatabase;
- (void) getWebserviceData;
- (void) searchSuccess;
- (void) populateContentList:(NSMutableArray *)searchArray;
- (NSString *) getContentForCell:(Notification *) obj;

@end

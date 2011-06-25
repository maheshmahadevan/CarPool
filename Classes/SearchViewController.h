//
//  SearchViewController.h
//  CarPool
//
//  Created by Madhura on 7/6/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceProcessor.h"
#import "OfferRequestXMLParser.h"
#import "ReplyViewController.h"


@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {

	UITableView *mainTableView;
	
	NSMutableArray *contentsList;
	NSMutableArray *searchResults;
	NSString *savedSearchTerm;
	
	WebServiceProcessor *webServiceProcessor;
	UIActivityIndicatorView *activityIndicator;
	
}

@property(nonatomic, assign) WebServiceProcessor *webServiceProcessor;

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;

- (void)handleSearchForTerm:(NSString *)searchTerm;
- (void) getWebserviceData;
- (void) searchSuccess;
- (void) populateContentList:(NSMutableArray *)searchArray;
- (NSString *) getContentForCell:(OfferRequest *) obj;

@end

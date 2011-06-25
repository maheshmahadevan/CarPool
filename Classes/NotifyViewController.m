    //
//  NotifyViewController.m
//  CarPool
//
//  Created by Madhura on 7/10/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "NotifyViewController.h"


@implementation NotifyViewController

@synthesize mainTableView;
@synthesize contentsList;
@synthesize searchResults;

@synthesize webServiceProcessor;

static NSString * const GET_NOTIFICATION_WEBSERVICE = @"http://localhost:3000/notifications.xml";


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.title = @"Notifications";
    }
    return self;
}
/*
- (id)initWithStyle:(UITableViewStyle)style {
	
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		
    }
	
	[self loadDatabase];
	
    return self;
}*/


- (void) loadDatabase {
	
	
	NSLog(@"loading database");
	
	if ([self searchResults] == nil)
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[self setSearchResults:array];
		[array release], array = nil;
	}
	
	[[self searchResults] removeAllObjects];
	
	
	
	//contentsList = [[NSMutableArray alloc] initWithObjects:@"Todd", @"Andrew", @"Eric", @"Justin", @"Barb",nil];
	[self getWebserviceData];
	
	
	
}

- (void) getWebserviceData
{
	NSLog(@"Inside getWebService");
	webServiceProcessor.successSelector = @selector(searchSuccess);
	[activityIndicator startAnimating];
	
	NSString *urlString = [[NSString alloc] initWithString:GET_NOTIFICATION_WEBSERVICE];
	NSString *escapedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *url = [[NSURL alloc] initWithString:escapedUrlString];
	
	//****** DANGER *******
	//NOTE: initWithURL can only be called on an alloced request; requestWithURL allocs and sets up.
	//NOTE: initWithURL leaks memory, even if you release the request. requestWithURL does not leak at all.
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	[req setHTTPMethod:@"GET"];
	
	
	[[NSURLConnection alloc] initWithRequest:req delegate:webServiceProcessor];
	
	webServiceProcessor.rawWSData = [[NSMutableData data] retain];
}

- (void) searchSuccess
{
	NSLog(@"Inside Notification search success");
	
	[activityIndicator stopAnimating];
	
	if(webServiceProcessor.responseCode == @"Success")
	{
		NotificationXMLParser* parser = [NotificationXMLParser alloc];
		parser.dataFoundSelector = @selector(populateContentList:);
		parser.parentController = self;
		
		[parser initWithData:webServiceProcessor.rawWSData];
		
		//webServiceProcessor.wsTextResponse = parser.soapTagData;
		[parser release];
	}
	
}

- (void) populateContentList:(NSMutableArray *)searchArray
{
	NSLog(@"Inside populate content");
	[self setContentsList:searchArray];
	int count = [searchArray count];
	for(int i=0;i<count;i++)
	{
		Notification *obj = [searchArray objectAtIndex:i];
		NSLog(@"Print Nmaes - %@ -%@",[obj receivedby],[obj sentby]);
	}
	
	User *userObj = [User getSharedInstance];
	NSString *email = [userObj email];
	
	NSLog(@"Back To loading %@",email);
	
	int count1 = [contentsList count];
	for(int i=0;i<count1;i++)
	{
		Notification *obj = [contentsList objectAtIndex:i];
		
		
		if ([[obj receivedby] isEqualToString:email] )
		{
			[[self searchResults] addObject:obj];
		}
		
	}	
	[mainTableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; 
}


- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	NSString *contentForThisRow = nil;
	
	
	contentForThisRow = [self getContentForCell:[[self searchResults] objectAtIndex:row]];
	
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	[[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
	//[[cell textLabel] lineBreakMode:UILineBreakModeWordWrap ];
	[[cell textLabel] setText:contentForThisRow ];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows;
	
	
	rows = [[self searchResults] count];
	
	
	return rows;
}

- (NSString *) getContentForCell:(Notification *) obj
{
	
	NSString *returnContent = nil;
	returnContent = [NSString stringWithFormat:@"Received From:%@:Message %@",[obj sentby],[obj message]];
	
	return returnContent;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"You picked something....");
	
	NSString *received = [[[self searchResults] objectAtIndex:indexPath.row] sentby];
    NSString *title = [NSString stringWithFormat:@"Received From:%@", received];
	NSString *message = [[[self searchResults] objectAtIndex:indexPath.row] message];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
}



/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	webServiceProcessor = [[WebServiceProcessor alloc] init];
	webServiceProcessor.viewController = self;
	[self loadDatabase];
}


-(void)viewWillAppear:(BOOL)animated
{ [super viewWillAppear:NO];
	
	[self.navigationController setNavigationBarHidden:NO];		 
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	[webServiceProcessor release];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mainTableView release], mainTableView = nil;
	[contentsList release], contentsList = nil;
	[searchResults release], searchResults = nil;
	[webServiceProcessor release];
	
	[super dealloc];
    
}


@end

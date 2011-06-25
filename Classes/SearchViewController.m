    //
//  SearchViewController.m
//  CarPool
//
//  Created by Madhura on 7/6/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SearchViewController.h"





@implementation SearchViewController

@synthesize mainTableView;
@synthesize contentsList;
@synthesize searchResults;
@synthesize savedSearchTerm;
@synthesize webServiceProcessor;

static NSString * const GET_OFFER_REQUEST_LIST_WEBSERVICE = @"http://localhost:3000/offer_requests.xml";

- (void)dealloc
{
	[mainTableView release], mainTableView = nil;
	[contentsList release], contentsList = nil;
	[searchResults release], searchResults = nil;
	[savedSearchTerm release], savedSearchTerm = nil;
	[webServiceProcessor release];
	
	[super dealloc];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	// Save the state of the search UI so that it can be restored if the view is re-created.
	[self setSavedSearchTerm:[[[self searchDisplayController] searchBar] text]];
	
	[self setSearchResults:nil];
}




- (void)viewDidLoad
{
[super viewDidLoad];
	
	webServiceProcessor = [[WebServiceProcessor alloc] init];
	webServiceProcessor.viewController = self;

// Restore search term
if ([self savedSearchTerm])
{
[[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
}
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
	[self setSavedSearchTerm:searchTerm];
	
	if ([self searchResults] == nil)
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[self setSearchResults:array];
		[array release], array = nil;
	}
	
	[[self searchResults] removeAllObjects];
	
	[self getWebserviceData];
	
	
	
	if ([[self savedSearchTerm] length] != 0)
	{
		int count = [contentsList count];
		for(int i=0;i<count;i++)
		{
			OfferRequest *obj = [contentsList objectAtIndex:i];
		
		
		if ([[obj startPoint] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
			{
				[[self searchResults] addObject:obj];
			}
		
	
		if ([[obj endPoint] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
		{
					[[self searchResults] addObject:obj];
		}
		
		if ([[obj madeby] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
			{
					[[self searchResults] addObject:obj];
			}
			
		}
	}
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
	[self handleSearchForTerm:searchString];
    
	return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	[self setSavedSearchTerm:nil];
	
	[[self mainTableView] reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	NSString *contentForThisRow = nil;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView])
		contentForThisRow = [self getContentForCell:[[self searchResults] objectAtIndex:row]];
	else
		contentForThisRow = [self getContentForCell:[[self contentsList] objectAtIndex:row]];
	
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
	
	if (tableView == [[self searchDisplayController] searchResultsTableView])
		rows = [[self searchResults] count];
	else
		rows = [[self contentsList] count];
	
	return rows;
}

- (NSString *) getContentForCell:(OfferRequest *) obj
{

	NSString *returnContent = nil;
	NSString *offerReq = [obj requestType]=='O'?@"offer":@"request";
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [dateFormatter dateFromString:[obj time]];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
	NSInteger hour = [dateComponents hour];
	NSInteger min = [dateComponents minute];
	returnContent = [NSString stringWithFormat:@"%@ has made an %@ from %@ to %@ on %@ at %d:%d.",[obj madeby],offerReq,[obj startPoint],[obj endPoint],[obj date],hour,min];
	[gregorian release];
	return returnContent;
}

- (void) getWebserviceData
{
	NSLog(@"Inside getWebService");
	webServiceProcessor.successSelector = @selector(searchSuccess);
	[activityIndicator startAnimating];
	
	NSString *urlString = [[NSString alloc] initWithString:GET_OFFER_REQUEST_LIST_WEBSERVICE];
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
	NSLog(@"Inside Search success");
	
	[activityIndicator stopAnimating];
	
	if(webServiceProcessor.responseCode == @"Success")
	{
		OfferRequestXMLParser* parser = [OfferRequestXMLParser alloc];
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
		OfferRequest *obj = [searchArray objectAtIndex:i];
		NSLog(@"Print Nmaes - %@ -%@",[obj startPoint],[obj endPoint]);
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	/*NSLog(@"You picked something....");
	
	NSString *name = [[[self searchResults] objectAtIndex:indexPath.row] madeby];
    NSString *text = [NSString stringWithFormat:@"You selected %@.", [[[self searchResults] objectAtIndex:indexPath.row] additionalText]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:text message:@"Now what?" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];*/
	OfferRequest *offReqObj = [OfferRequest getSharedInstance];
	[offReqObj setAdditionalText:[[[self searchResults] objectAtIndex:indexPath.row] additionalText]];
	[offReqObj setRequestType:[[[self searchResults] objectAtIndex:indexPath.row] requestType] ];
	[offReqObj setStartPoint:[[[self searchResults] objectAtIndex:indexPath.row] startPoint] ];
	[offReqObj setEndPoint:[[[self searchResults] objectAtIndex:indexPath.row] endPoint] ];
	[offReqObj setMadeby:[[[self searchResults] objectAtIndex:indexPath.row] madeby] ];
	[offReqObj setDate:[[[self searchResults] objectAtIndex:indexPath.row] date] ];
	[offReqObj setTime:[[[self searchResults] objectAtIndex:indexPath.row] time] ];
	
	ReplyViewController *replyView = [[ReplyViewController alloc] initWithNibName:@"Reply" bundle:nil];
	[self.navigationController pushViewController:replyView animated:YES];
	
	
}


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.title = @"Search";
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
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
/*
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


(void)dealloc {
    [super dealloc];
	[
}
*/

@end

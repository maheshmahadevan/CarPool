    //
//  CommViewController.m
//  CarPool
//
//  Created by Madhura on 7/6/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "CommViewController.h"


@implementation CommViewController

@synthesize webServiceProcessor;

static NSString * const GET_USER_COMMUNITY_WEBSERVICE = @"http://localhost:3000/user_communities.xml";
static NSString * const GET_COMMUNITIES_WEBSERVICE = @"http://localhost:3000/communities.xml";

- (IBAction)createCommAction:(id)sender
{
	CreateComViewController *createCommView = [[CreateComViewController alloc] initWithNibName:@"CreateComm" bundle:nil];
	[self.navigationController pushViewController:createCommView animated:YES];
	[createCommView release];
}	

- (IBAction)joinCommAction:(id)sender
{
	JoinComViewController *joinCommView = [[JoinComViewController alloc] initWithNibName:@"JoinComm" bundle:nil];
	[self.navigationController pushViewController:joinCommView animated:YES];
	[joinCommView release];
}

- (IBAction)inviteFrdsAction:(id)sender
{
	InviteViewController *inviteFrdsView = [[InviteViewController alloc] initWithNibName:@"InviteFriends" bundle:nil];
	[self.navigationController pushViewController:inviteFrdsView animated:YES];
	[inviteFrdsView release];
}


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.title = @"Communities";
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
-(void)viewWillAppear:(BOOL)animated
{ [super viewWillAppear:NO];
	
	[self.navigationController setNavigationBarHidden:NO];		 
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	webServiceProcessor = [[WebServiceProcessor alloc] init];
	webServiceProcessor.viewController = self;
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
    [super dealloc];
	[webServiceProcessor release];
}


@end

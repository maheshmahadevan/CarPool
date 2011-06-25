//
//  CarPoolViewController.m
//  CarPool
//
//  Created by Madhura on 7/5/10.
//  Copyright Home 2010. All rights reserved.
//

#import "CarPoolViewController.h"

@implementation CarPoolViewController
//@synthesize loginText;
//@synthesize password;
@synthesize webServiceProcessor;

static NSString * const GET_USERS_LIST_WEBSERVICE = @"http://localhost:3000/users.xml";

- (IBAction)loginAction:(id)sender
{
	[loginText resignFirstResponder];
	[password resignFirstResponder];
	
	[self authenticate];
	
	/*if([loginText.text isEqualToString:@"mahesh@mahesh.com"] && [password.text isEqualToString:@"abcd"])
	{
		
		UITabBarController *tabBarController = [[UITabBarController alloc] init];
		
		UINavigationController *formViewNav = [[UINavigationController alloc] init];
		FormViewController *formView = [[FormViewController alloc] initWithNibName:@"FormView" bundle:nil];
		[formViewNav pushViewController:formView animated:YES];
		formViewNav.title = @"CarPool";
		formViewNav.tabBarItem.image = [UIImage imageNamed:@"47-fuel.png"];
		
		UINavigationController *notViewNav = [[UINavigationController alloc] init];
		NotifyViewController *notView = [[NotifyViewController alloc] initWithNibName:@"Notification" bundle:nil];
		[notViewNav pushViewController:notView animated:YES];
		notViewNav.title = @"Notifications";
		notViewNav.tabBarItem.image = [UIImage imageNamed:@"18-envelope.png"];
		
		
		UINavigationController *commViewNav = [[UINavigationController alloc] init];
		CommViewController *commView = [[CommViewController alloc] initWithNibName:@"Community" bundle:nil];
		[commViewNav pushViewController:commView animated:YES];
		commViewNav.title = @"Community";
		commViewNav.tabBarItem.image = [UIImage imageNamed:@"112-group.png"];
		
		UINavigationController *srhViewNav = [[UINavigationController alloc] init];
		SearchViewController *srhView = [[SearchViewController alloc] initWithNibName:@"SearchView" bundle:nil];
		[srhViewNav pushViewController:srhView animated:YES];
		srhViewNav.title = @"Search";
		srhViewNav.tabBarItem.image = [UIImage imageNamed:@"06-magnifying-glass.png"];
		
		tabBarController.viewControllers = [NSArray arrayWithObjects:formViewNav,notViewNav,commViewNav,srhViewNav,nil];
		[self.view addSubview:tabBarController.view];
		
		
	}
	else
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bad Cookie" message:@"Incorrect User or Password" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}*/
}

- (IBAction) registerAction:(id)sender
{
	NSLog(@"Inside register action");	
    //self 
	//[self.navigationController pushViewController:regView animated:YES];
	regView = [[RegViewController alloc] initWithNibName:@"Register" bundle:nil];
	[self.view addSubview:regView.view ];
	//[regView release];
}



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		NSLog(@"Inside init With Nib name");
		loginText.returnKeyType = UIReturnKeyDone;
		password.returnKeyType = UIReturnKeyDone;
		loginText.delegate = self;
		password.delegate =self;
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	
	[textField resignFirstResponder];
	
}

- (int) authenticate
{
	NSLog(@"Inside authenticate");
	webServiceProcessor.successSelector = @selector(loginSuccess);
	[activityIndicator startAnimating];
	
	NSString *urlString = [[NSString alloc] initWithString:GET_USERS_LIST_WEBSERVICE];
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

- (void) loginSuccess
{
	NSLog(@"Inside Login success");
	
	[activityIndicator stopAnimating];
	
	if(webServiceProcessor.responseCode == @"Success")
	{
		UserXMLParser* parser = [UserXMLParser alloc];
		parser.dataFoundSelector = @selector(matchUser:);
		parser.parentController = self;

		[parser initWithData:webServiceProcessor.rawWSData];
		
		//webServiceProcessor.wsTextResponse = parser.soapTagData;
		[parser release];
	}
	
}

- (void) matchUser:(NSMutableArray *)userArray
{
	NSLog(@"Inside match user");
	int count = [userArray count];
	BOOL flag = NO;
	for(int i=0;i<count;i++)
	{
		User *obj = [userArray objectAtIndex:i];
		NSLog(@"Print Nmaes - %@ -%@",[obj email],[obj password]);
		if([[obj email] isEqualToString:loginText.text] && [[obj password] isEqualToString:password.text])
		{
			
			User *usrObj = [User getSharedInstance];
			[usrObj setEmail:[obj email]];
			[usrObj setPassword:[obj password]];
			[usrObj setDob:[obj dob]];
			[usrObj setLocation:[obj location]];
			[usrObj setSex:[obj sex]];
			[usrObj setUsertype:[obj usertype]];
			flag = YES;
			break;
		}
	}	
		
		if(flag)
			[self initiateViews];
		else
		{
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bad Cookie" message:@"Incorrect User or Password" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
				[alertView show];
				[alertView release];
		}
		
	
		
}

- (void) initiateViews
{
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	
	UINavigationController *formViewNav = [[UINavigationController alloc] init];
	FormViewController *formView = [[FormViewController alloc] initWithNibName:@"FormView" bundle:nil];
	[formViewNav pushViewController:formView animated:YES];
	formViewNav.title = @"CarPool";
	formViewNav.tabBarItem.image = [UIImage imageNamed:@"47-fuel.png"];
	
	UINavigationController *notViewNav = [[UINavigationController alloc] init];
	NotifyViewController *notView = [[NotifyViewController alloc] initWithNibName:@"Notification" bundle:nil];
	[notViewNav pushViewController:notView animated:YES];
	notViewNav.title = @"Notifications";
	notViewNav.tabBarItem.image = [UIImage imageNamed:@"18-envelope.png"];
	
	
	UINavigationController *commViewNav = [[UINavigationController alloc] init];
	CommViewController *commView = [[CommViewController alloc] initWithNibName:@"Community" bundle:nil];
	[commViewNav pushViewController:commView animated:YES];
	commViewNav.title = @"Community";
	commViewNav.tabBarItem.image = [UIImage imageNamed:@"112-group.png"];
	
	UINavigationController *srhViewNav = [[UINavigationController alloc] init];
	SearchViewController *srhView = [[SearchViewController alloc] initWithNibName:@"SearchView" bundle:nil];
	[srhViewNav pushViewController:srhView animated:YES];
	srhViewNav.title = @"Search";
	srhViewNav.tabBarItem.image = [UIImage imageNamed:@"06-magnifying-glass.png"];
	
	tabBarController.viewControllers = [NSArray arrayWithObjects:formViewNav,notViewNav,commViewNav,srhViewNav,nil];
	[self.view addSubview:tabBarController.view];
	
	[formViewNav release];
	[notViewNav release];
	[commViewNav release];
	[srhViewNav release];


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
	
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    [backBarButtonItem release];
}
	 
-(void)viewWillAppear:(BOOL)animated
{ [super viewWillAppear:NO];
		
 //[self.navigationController setNavigationBarHidden:YES];		 
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
	NSLog(@"view unload called");
	//[self.navigationController release];
}


- (void)dealloc {
    [super dealloc];
	[regView release];
	[webServiceProcessor release];
	
}

@end

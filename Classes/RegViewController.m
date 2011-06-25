    //
//  RegViewController.m
//  CarPool
//
//  Created by Madhura on 7/15/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "RegViewController.h"


@implementation RegViewController

static NSString * const ADD_USER_WEBSERVICE = @"http://localhost:3000/users.xml";

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (IBAction) loginAction:(id)sender
{
	NSLog(@"Inside login action");
	[email resignFirstResponder];
	[password resignFirstResponder];
	[repassword resignFirstResponder];
	[dob resignFirstResponder];
	[sex resignFirstResponder];
	[location resignFirstResponder];
	[userType resignFirstResponder];
	
	if([self validateFields]==0)
	{
	/*UITabBarController *tabBarController = [[UITabBarController alloc] init];
	
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
	*/
	[activityIndicator startAnimating];
	User *userObj = [User getSharedInstance] ;	
	
	webServiceProcessor.successSelector = @selector(loginSuccess);
	
	NSMutableURLRequest *request =
	[NSMutableURLRequest requestWithURL:[NSURL URLWithString:ADD_USER_WEBSERVICE]];
	[request setHTTPMethod:@"POST"];
	
	NSString *postString = [NSString stringWithFormat:@"user[email]=%@&user[password]=%@&user[dob]=%@&user[sex]=%c&user[location]=%@&user[usertype]=%@",userObj.email,userObj.password,userObj.dob,userObj.sex,userObj.location,userObj.usertype];
	
	[request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
	[[NSURLConnection alloc] initWithRequest:request delegate:webServiceProcessor];
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
	
	
	
	
}


- (int) validateFields
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 

    if([emailTest evaluateWithObject:email.text] == NO)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bad Cookie" message:@"Incorrect Email Address" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return 1;
	}
	
	if([password.text isEqualToString:repassword.text] == NO)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bad Cookie" message:@"Password and Re-enter Password does not match" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return 1;
	}
	
	if([sex.text isEqualToString:@"M"] == NO && [sex.text isEqualToString:@"F"] == NO )
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bad Cookie" message:@"Enter Valid Sex M or F" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return 1;
	}
	
	if([dob.text length] == 0 || [location.text length] == 0 || [userType.text length] == 0)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bad Cookie" message:@"One or more mandatory fields empty" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return 1;
	}
	
	User *userObj = [User getSharedInstance] ;
	
	[userObj setEmail:email.text];
	[userObj setPassword:password.text];
	[userObj setDob:dob.text];
	[userObj setSex:[sex.text characterAtIndex:0]];
	[userObj setLocation:location.text];
	[userObj setUsertype:userType.text];
	
	return 0;
}

- (void) loginSuccess
{
	NSLog(@"Submit successful");
	
	[activityIndicator stopAnimating];
	
	if(webServiceProcessor.responseCode == @"Success")
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully created a user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
		User *userObj = [User getSharedInstance] ;
		
		[userObj setEmail:email.text];
		[userObj setPassword:password.text];
		[userObj setDob:dob.text];
		[userObj setSex:[sex.text characterAtIndex:0]];
		[userObj setLocation:location.text];
		[userObj setUsertype:userType.text];
		
		
		[self initiateViews];
	}

	
}

- (IBAction) resetAction:(id)sender
{
	email.text = @"";
	password.text =@"";
	repassword.text = @"";
	dob.text = @"";
	sex.text = @"";
	location.text = @"";
	userType.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect =
	[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
	[self.view.window convertRect:self.view.bounds fromView:self.view];
	
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
	midline - viewRect.origin.y
	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
	* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
	
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
	
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

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
	//[self.navigationController setNavigationBarHidden:NO];
}


-(void)viewWillAppear:(BOOL)animated
{ [super viewWillAppear:NO];
	
	//[self.navigationController setNavigationBarHidden:NO];		 
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
	
	//[self.navigationController release];
}


- (void)dealloc {
    [super dealloc];
	[webServiceProcessor release];
	
}


@end

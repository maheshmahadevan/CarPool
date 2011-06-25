    //
//  CreateComViewController.m
//  CarPool
//
//  Created by Madhura on 7/11/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "CreateComViewController.h"


@implementation CreateComViewController

@synthesize webServiceProcessor;

static NSString * const ADD_COMMUNITY_WEBSERVICE = @"http://localhost:3000/communities.xml";
static NSString * const ADD_USER_COMMUNITY_WEBSERVICE = @"http://localhost:3000/user_communities.xml";

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (IBAction) createAction:(id)sender
{
	NSLog(@"Inside Community create action");
	[name resignFirstResponder];
	[type resignFirstResponder];
	[city resignFirstResponder];
	[state resignFirstResponder];
	[description resignFirstResponder];
	
	Community *commShared = [Community getSharedInstance];
	NSLog(@"Community Name - %@",[commShared name]);
	if([[commShared name] length] != 0)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can only be a part on one community." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	else if([self validateFields]==0)
	{
		Community *commObj = [[Community alloc] init];
		[commObj setName:name.text];
		[commObj setType:type.text];
		[commObj setCity:city.text];
		[commObj setState:state.text];
		[commObj setDescription:description.text];
		User *userObj = [User getSharedInstance];
		[commObj setModerator:[userObj email]];
		
		[activityIndicator startAnimating];
		
		webServiceProcessor.successSelector = @selector(createSuccess);
		
		NSMutableURLRequest *request =
		[NSMutableURLRequest requestWithURL:[NSURL URLWithString:ADD_COMMUNITY_WEBSERVICE]];
		[request setHTTPMethod:@"POST"];
		
		
		NSString *postString = [NSString stringWithFormat:@"community[name]=%@&community[commtype]=%@&community[city]=%@&community[state]=%@&community[description]=%@&community[moderator]=%@",commObj.name,commObj.type,commObj.city,commObj.state,commObj.description,commObj.moderator];
		
		[request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
		[[NSURLConnection alloc] initWithRequest:request
										delegate:webServiceProcessor];
		[commObj release];
		
	}
}

- (int) validateFields
{
	if([name.text length]== 0 || [type.text length] == 0|| [city.text length] == 0 || [state.text length] == 0 || [description.text length] == 0 )
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bad Cookie" message:@"One or more mandatory fields are empty" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return 1;
	}
	else {
		
		return 0;
	}
}

- (void) createSuccess
{
	NSLog(@"Create Comunity successful");
	
	[activityIndicator stopAnimating];
	
	if(webServiceProcessor.responseCode == @"Success")
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully made a carpool community. You can go back and invite Friends to join." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		Community *commObj = [Community getSharedInstance];
		[commObj setName:name.text];
		[commObj setType:type.text];
		[commObj setCity:city.text];
		[commObj setState:state.text];
		[commObj setDescription:description.text];
		User *userObj = [User getSharedInstance];
		[commObj setModerator:[userObj email]];
		
		[activityIndicator startAnimating];
		
		webServiceProcessor.successSelector = @selector(createUserCommSuccess);
		
		NSMutableURLRequest *request =
		[NSMutableURLRequest requestWithURL:[NSURL URLWithString:ADD_USER_COMMUNITY_WEBSERVICE]];
		[request setHTTPMethod:@"POST"];
		
		
		NSString *postString = [NSString stringWithFormat:@"user_community[community]=%@&user_community[user]=%@&user_community[moderator]=%@",commObj.name,commObj.moderator,@"Y"];
		
		[request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
		[[NSURLConnection alloc] initWithRequest:request
										delegate:webServiceProcessor];
		
		name.text = @"";
		type.text =@"";
		city.text = @"";
		state.text = @"";
		description.text = @"";
	}
}

- (void) createUserCommSuccess
{
	NSLog(@"Create Comunity successful");
	
	[activityIndicator stopAnimating];
	
	if(webServiceProcessor.responseCode == @"Success")
	{
		NSLog(@"User Successfully added to user_communities");
	}
}	

- (IBAction) resetAction:(id)sender
{
	name.text = @"";
	type.text =@"";
	city.text = @"";
	state.text = @"";
	description.text = @"";
	
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



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.title = @"Create Community";
    }
    return self;
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

    //
//  FormViewController.m
//  CarPool
//
//  Created by Madhura on 7/6/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "FormViewController.h"


@implementation FormViewController

@synthesize webServiceProcessor;

static NSString * const ADD_OFFER_REQUEST_WEBSERVICE = @"http://localhost:3000/offer_requests.xml";

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (IBAction) submitAction:(id)sender
{
	[startPoint resignFirstResponder];
	[endPoint resignFirstResponder];
	[date resignFirstResponder];
	[time resignFirstResponder];
	[additionalText resignFirstResponder];
	
	
	if([self valdiateFields] == 0)
	{
	
	[activityIndicator startAnimating];
	
	webServiceProcessor.successSelector = @selector(submitSuccess);

	NSMutableURLRequest *request =
	[NSMutableURLRequest requestWithURL:[NSURL URLWithString:ADD_OFFER_REQUEST_WEBSERVICE]];
	[request setHTTPMethod:@"POST"];
	
	NSString *postString = [NSString stringWithFormat:@"offer_request[requestType]=%c&offer_request[startPoint]=%@&offer_request[endPoint]=%@&offer_request[date]=%@&offer_request[time]=%@&offer_request[additionalText]=%@&offer_request[searchType]=%@&offer_request[madeby]=%@",offerRequestObj.requestType,offerRequestObj.startPoint,offerRequestObj.endPoint,offerRequestObj.date,offerRequestObj.time,offerRequestObj.additionalText,offerRequestObj.searchType,offerRequestObj.madeby];
	
	[request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
	[[NSURLConnection alloc] initWithRequest:request
									delegate:webServiceProcessor];
	
	}
	
	
}

- (int ) valdiateFields
{
	if([startPoint.text length]== 0 || [endPoint.text length] == 0|| [date.text length] == 0 || [time.text length] == 0 )
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bad Cookie" message:@"One or more mandatory fields are empty" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return 1;
	}
	else {
		[offerRequestObj setStartPoint:startPoint.text];
		[offerRequestObj setEndPoint:endPoint.text];
		[offerRequestObj setDate:date.text];
		[offerRequestObj setTime:time.text];
		[offerRequestObj setAdditionalText:additionalText.text];
		User *usrObj = [User getSharedInstance];
		[offerRequestObj setMadeby:[usrObj email]];
		return 0;
	}
}

- (void) submitSuccess
{
	NSLog(@"Submit successful");
	
	[activityIndicator stopAnimating];
	
	if(webServiceProcessor.responseCode == @"Success")
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully made a carpool offer/request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		startPoint.text = @"";
		endPoint.text =@"";
		date.text = @"";
		time.text = @"";
		additionalText.text = @"";
	}
}

- (IBAction) resetAction:(id)sender
{
	startPoint.text = @"";
	endPoint.text =@"";
	date.text = @"";
	time.text = @"";
	additionalText.text = @"";
}

- (IBAction) offerRequestAction:(id)sender
{
	UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
	if([segmentControl selectedSegmentIndex] == 0)
		offerRequestObj.requestType = 'O';
	else if ([segmentControl selectedSegmentIndex] == 1)
		offerRequestObj.requestType = 'R';
	else
		offerRequestObj.requestType = 'O';
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
		self.title = @"Car-Pool";
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
    [super dealloc];
	[webServiceProcessor release];
}


@end

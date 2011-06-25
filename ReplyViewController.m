    //
//  ReplyViewController.m
//  CarPool
//
//  Created by Madhura on 7/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "ReplyViewController.h"


@implementation ReplyViewController

@synthesize webServiceProcessor;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

static NSString * const ADD_NOTIFICATION_WEBSERVICE = @"http://localhost:3000/notifications.xml";

- (IBAction) sendMessage:(id)sender
{
	//NSLog(@"Inside send message action");
	OfferRequest *offReqObj = [OfferRequest getSharedInstance];
	NSString *toString = [offReqObj madeby];
	/*NSString *offerReq = [offReqObj requestType]=='O'?@"offer":@"request";
	NSString *subject = @"Carpool%20Notification";*/
	User *user = [User getSharedInstance];
	NSString *userName = [user email];
	//NSString *commName = [[Community getSharedInstance] name];
	/*
	NSString *body = [NSString stringWithFormat:@"Hi %@ has replied to your %@.Sent from Carpool App. %@",userName,offerReq,message.text ];
	
	NSString *mailString = [NSString stringWithFormat:@"mailto:%@&subject=%@&body=%@",[toString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	NSLog(@"%@",mailString);
	

	if([[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]])
		NSLog(@"YES");*/
	[message resignFirstResponder];
	
	if([message.text length] >0)
	{
		
		[activityIndicator startAnimating];
		
		webServiceProcessor.successSelector = @selector(messageSuccess);
		
		NSMutableURLRequest *request =
		[NSMutableURLRequest requestWithURL:[NSURL URLWithString:ADD_NOTIFICATION_WEBSERVICE]];
		[request setHTTPMethod:@"POST"];
		NSString *offerReq = [offReqObj requestType]=='O'?@"Offer":@"Request";
		NSMutableString *newMsg = [[NSMutableString alloc]init];
		[newMsg appendFormat:[NSString stringWithFormat:@"For your %@ from %@ to %@ : %@",offerReq,[offReqObj startPoint],[offReqObj endPoint],message.text]];
		//[newMsg appendString:message.text];
		
		NSString *postString = [NSString stringWithFormat:@"notification[message]=%@&notification[recipient]=%@&notification[sender]=%@",newMsg,toString,userName];
		
		[request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
		[[NSURLConnection alloc] initWithRequest:request
										delegate:webServiceProcessor];
		
	}
	else
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bad Cookie" message:@"Message is empty" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
	}
	
}

- (void) messageSuccess
{
	NSLog(@"Message successful");
	
	[activityIndicator stopAnimating];
	
	if(webServiceProcessor.responseCode == @"Success")
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully sent a notification." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		message.text = @"";
	}
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.title = @"Reply Search";
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect textFieldRect =
	[self.view.window convertRect:textView.bounds fromView:textView];
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

- (void)textViewDidEndEditing:(UITextView *)textView
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
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	OfferRequest *offReqObj = [OfferRequest getSharedInstance];
	[headerText setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	headerText.lineBreakMode = UILineBreakModeWordWrap;
	headerText.numberOfLines = 0;
	[additionalText setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	additionalText.lineBreakMode = UILineBreakModeWordWrap;
	additionalText.numberOfLines =0;
	
	headerText.text = [self getContentForCell:offReqObj];
	additionalText.text = [offReqObj additionalText];
	
	webServiceProcessor = [[WebServiceProcessor alloc] init];
	webServiceProcessor.viewController = self;

	
}

- (NSString *) getContentForCell:(OfferRequest *) obj
{
	
	NSString *returnContent = nil;
	NSString *offerReq = [obj requestType]=='O'?@"offer":@"request";
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [dateFormatter dateFromString:[obj time]];
	NSLog(@"%@",[dateFormatter stringFromDate:date]);
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
	NSInteger hour = [dateComponents hour];
	NSInteger min = [dateComponents minute];
	
	NSString *time = [[obj time] substringWithRange:NSMakeRange(11,5)];
	returnContent = [NSString stringWithFormat:@"%@ has made an %@ from %@ to %@ for %@ at %@.",[obj madeby],offerReq,[obj startPoint],[obj endPoint],[obj date],time];
	[gregorian release];
	return returnContent;
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

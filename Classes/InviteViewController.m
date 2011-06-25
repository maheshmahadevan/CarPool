    //
//  InviteViewController.m
//  CarPool
//
//  Created by Madhura on 7/11/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "InviteViewController.h"


@implementation InviteViewController

@synthesize webServiceProcessor;


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

static NSString * const ADD_NOTIFICATION_WEBSERVICE = @"http://localhost:3000/notifications.xml";

- (IBAction) inviteAction:(id)sender
{
	/*NSLog(@"Inside invite action");
	NSString *toString = emailText.text;
	NSString *subject = @"Carpool Invitation";
	NSString *user = [[User getSharedInstance] email];
	NSString *commName = [[Community getSharedInstance] name];
	
	NSString *body = [NSString stringWithFormat:@"Hi,\n\nYou have been invited to Join Carpool community by User %@ .\n\nPlease use the below invite code and enter in Carpool App in Communities section to Join %@'s Community.\n\n%@.\n\nSent from Carpool App",user,commName,commName ];
	
	NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",[toString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
							[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
							*/
	[emailText resignFirstResponder];
	User *user = [User getSharedInstance];
	NSString *userName = [user email];
	
	Community *comm = [Community getSharedInstance];
	NSString *commName = [comm name];
	
	NSString *message = [NSString stringWithFormat:@"You have been invited to Join Community %@ by %@. Enter %@ in Join Community screen to Join",commName,userName,commName];
	
	if([emailText.text length] >0)
	{
		
		[activityIndicator startAnimating];
		
		webServiceProcessor.successSelector = @selector(inviteSuccess);
		
		NSMutableURLRequest *request =
		[NSMutableURLRequest requestWithURL:[NSURL URLWithString:ADD_NOTIFICATION_WEBSERVICE]];
		[request setHTTPMethod:@"POST"];
		
		NSString *postString = [NSString stringWithFormat:@"notification[message]=%@&notification[recipient]=%@&notification[sender]=%@",message,emailText.text,userName];
		
		[request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
		[[NSURLConnection alloc] initWithRequest:request
										delegate:webServiceProcessor];
		
	}
	else
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bad Cookie" message:@"Email address is empty" delegate:nil cancelButtonTitle:@"Try again" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		
	}
	
	
}

- (void) inviteSuccess
{
	NSLog(@"Message successful");
	
	[activityIndicator stopAnimating];
	
	if(webServiceProcessor.responseCode == @"Success")
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully sent a invitation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		emailText.text = @"";
	}
}

/*
- (void)textViewDidChange:(UITextView *)textView {
	
	NSLog([NSString stringWithFormat:@"%d,%d,%d,%d",textView.frame.origin.x,textView.frame.origin.y,textView.frame.size.width,textView.frame.size.height]);
	
	
	if(emailText == textView)
	{
	CGSize constraintSize = CGSizeMake(textView.bounds.size.width, textView.bounds.size.height +100);
		CGSize textViewSize = [[textView text] sizeWithFont:[textView font ] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
	if(textView.frame.size.height < textViewSize.height)
		[textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height+textViewSize.height + 10)];
	}
}*/


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.title = @"Invite";
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

//
//  InviteViewController.h
//  CarPool
//
//  Created by Madhura on 7/11/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Community.h"
#import "WebServiceProcessor.h"


@interface InviteViewController : UIViewController <UITextViewDelegate> {
	IBOutlet UITextView *emailText;
	CGFloat animatedDistance;
	
	WebServiceProcessor *webServiceProcessor;
	UIActivityIndicatorView *activityIndicator;
	
	
}

@property(nonatomic, assign) WebServiceProcessor *webServiceProcessor;

@property(nonatomic, retain) UITextView *emailText;

- (IBAction) inviteAction:(id)sender;
- (void) inviteSuccess;

@end

//
//  ReplyViewController.h
//  CarPool
//
//  Created by Madhura on 7/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferRequest.h"
#import "User.h"
#import "WebServiceProcessor.h"

@interface ReplyViewController : UIViewController <UITextViewDelegate>{
	IBOutlet UILabel *headerText;
	IBOutlet UILabel *additionalText;
	IBOutlet UITextView *message;
	CGFloat animatedDistance;
	
	
	WebServiceProcessor *webServiceProcessor;
	UIActivityIndicatorView *activityIndicator;
	

}

@property(nonatomic, assign) WebServiceProcessor *webServiceProcessor;

- (IBAction) sendMessage:(id)sender;
- (NSString *) getContentForCell:(OfferRequest *) obj;
- (void) messageSuccess;

@end

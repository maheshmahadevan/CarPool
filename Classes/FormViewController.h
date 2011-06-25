//
//  FormViewController.h
//  CarPool
//
//  Created by Madhura on 7/6/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferRequest.h"
#import "WebServiceProcessor.h"
#import "User.h"


@interface FormViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet OfferRequest *offerRequestObj;
	IBOutlet UITextField *startPoint;
	IBOutlet UITextField *endPoint;
	IBOutlet UITextField *date;
	IBOutlet UITextField *time;
	IBOutlet UITextField *additionalText;
	CGFloat animatedDistance;
	
	WebServiceProcessor *webServiceProcessor;
	UIActivityIndicatorView *activityIndicator;
	
}

@property(nonatomic, assign) WebServiceProcessor *webServiceProcessor;

- (IBAction) submitAction:(id)sender;
- (IBAction) resetAction:(id)sender;
- (IBAction) offerRequestAction:(id)sender;
- (void) submitSuccess;
- (int ) valdiateFields;

@end

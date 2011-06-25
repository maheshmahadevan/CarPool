//
//  CreateComViewController.h
//  CarPool
//
//  Created by Madhura on 7/11/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Community.h"
#import "User.h"
#import "WebServiceProcessor.h"
#import "Community.h"


@interface CreateComViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet Community *commObj;
	IBOutlet User *userObj;
	IBOutlet UITextField *name;
	IBOutlet UITextField *type;
    IBOutlet UITextField *city;
	IBOutlet UITextField *state;
	IBOutlet UITextField *description; 
	
	CGFloat animatedDistance;
	
	WebServiceProcessor *webServiceProcessor;
	UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic, assign) WebServiceProcessor *webServiceProcessor;

- (IBAction) createAction:(id)sender;
- (IBAction) resetAction:(id)sender;
- (void) createSuccess;
- (void) createUserCommSuccess;
- (int) validateFields;

@end

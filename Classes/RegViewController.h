//
//  RegViewController.h
//  CarPool
//
//  Created by Madhura on 7/15/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarPoolViewController.h"
#import "FormViewController.h"
#import "NotifyViewController.h"
#import "SearchViewController.h"
#import "CommViewController.h"
#import "WebServiceProcessor.h"
#import "User.h"

@interface RegViewController : UIViewController  <UITextFieldDelegate> {
//	IBOutlet CarPoolViewController viewController;
	IBOutlet User *userObj;
	IBOutlet UITextField *email;
	IBOutlet UITextField *password;
	IBOutlet UITextField *repassword;
	IBOutlet UITextField *dob;
	IBOutlet UITextField *sex;
	IBOutlet UITextField *location;
	IBOutlet UITextField *userType;
	CGFloat animatedDistance;
	
	WebServiceProcessor *webServiceProcessor;
	UIActivityIndicatorView *activityIndicator;

}

- (IBAction) loginAction:(id)sender;
- (IBAction) resetAction:(id)sender;
- (int) validateFields;
- (void) loginSuccess;
- (void) initiateViews;

@end

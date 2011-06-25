//
//  CarPoolViewController.h
//  CarPool
//
//  Created by Madhura on 7/5/10.
//  Copyright Home 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"
#import "NotifyViewController.h"
#import "SearchViewController.h"
#import "CommViewController.h"
#import "RegViewController.h"
#import "WebServiceProcessor.h"
#import "UserXMLParser.h"

@class RegViewController;



@interface CarPoolViewController : UIViewController <UITextFieldDelegate> {
	//UITabBarController *tabBarController;
	//IBOutlet UIButton *loginButton;
	IBOutlet UITextField *loginText;
	IBOutlet UITextField *password;
	RegViewController *regView;
	
	WebServiceProcessor *webServiceProcessor;
	UIActivityIndicatorView *activityIndicator;
	
}

@property(nonatomic, assign) WebServiceProcessor *webServiceProcessor;

- (IBAction)loginAction:(id)sender;
- (IBAction) registerAction:(id)sender;
- (int) authenticate;
- (void) initiateViews;
- (void) loginSuccess;
- (void) matchUser:(NSMutableArray *)userArray;

//@property (retain) IBOutlet UITextField *loginText;
//@property (retain) IBOutlet UITextField *password;

@end


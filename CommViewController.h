//
//  CommViewController.h
//  CarPool
//
//  Created by Madhura on 7/6/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateComViewController.h"
#import "JoinComViewController.h"
#import "InviteViewController.h"
#import "WebServiceProcessor.h"

@interface CommViewController : UIViewController {

	WebServiceProcessor *webServiceProcessor;
	UIActivityIndicatorView *activityIndicator;
	
}

@property(nonatomic, assign) WebServiceProcessor *webServiceProcessor;



- (IBAction)createCommAction:(id)sender;
- (IBAction)joinCommAction:(id)sender;
- (IBAction)inviteFrdsAction:(id)sender;

@end

//
//  CarPoolAppDelegate.h
//  CarPool
//
//  Created by Madhura on 7/5/10.
//  Copyright Home 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarPoolViewController;

@interface CarPoolAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CarPoolViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CarPoolViewController *viewController;

@end


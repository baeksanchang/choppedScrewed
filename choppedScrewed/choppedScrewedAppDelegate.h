//
//  choppedScrewedAppDelegate.h
//  choppedScrewed
//
//  Created by Baek Chang on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class choppedScrewedViewController;

@interface choppedScrewedAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet choppedScrewedViewController *viewController;

@end

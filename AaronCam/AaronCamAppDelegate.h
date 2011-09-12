//
//  AaronCamAppDelegate.h
//  AaronCam
//
//  Created by Seth Fitzsimmons on 9/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AaronCamViewController;

@interface AaronCamAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet AaronCamViewController *viewController;

@end

//
//  PegSolitaireAppDelegate.h
//  PegSolitaire
//
//  Created by Bruno Goncalves on 1/21/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface PegSolitaireAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	RootViewController *rootViewController;
	UIViewController *splashViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet UIViewController *splashViewController;

- (IBAction)onPlay;

@end


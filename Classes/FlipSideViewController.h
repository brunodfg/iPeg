//
//  FlipSideViewController.h
//  PegSolitaire
//
//  Created by Bruno Goncalves on 1/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;
@class HighScoresViewController;
@class HelpViewController;
@class AboutViewController;

@interface FlipSideViewController : UIViewController <UITabBarDelegate> {
	UITabBar *optionsTabBar;
	SettingsViewController *settingsViewController;
	HighScoresViewController *highScoresViewController;
	HelpViewController *helpViewController;
	AboutViewController *aboutViewController;
}

@property (nonatomic, retain) IBOutlet UITabBar *optionsTabBar;
@property (nonatomic, retain) SettingsViewController *settingsViewController;
@property (nonatomic, retain) HighScoresViewController *highScoresViewController;
@property (nonatomic, retain) HelpViewController *helpViewController;
@property (nonatomic, retain) AboutViewController *aboutViewController;

- (void) refresh;

@end

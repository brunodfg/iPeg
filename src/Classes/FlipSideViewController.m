//
//  FlipSideViewController.m
//  PegSolitaire
//
//  Created by Bruno Goncalves on 1/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FlipSideViewController.h"
#import "SettingsViewController.h"
#import "HighScoresViewController.h"
#import "HelpViewController.h"
#import "AboutViewController.h"

@implementation FlipSideViewController

@synthesize optionsTabBar;
@synthesize settingsViewController;
@synthesize highScoresViewController;
@synthesize helpViewController;
@synthesize aboutViewController;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad {

    [super viewDidLoad];

	// Create options views
	UIViewController *viewController;

	viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
    self.settingsViewController = (SettingsViewController *) viewController;
    [viewController release];
	
	viewController = [[HighScoresViewController alloc] initWithNibName:@"HighScoresView" bundle:nil];
    self.highScoresViewController = (HighScoresViewController *) viewController;
    [viewController release];
	
	viewController = [[HelpViewController alloc] initWithNibName:@"HelpView" bundle:nil];
    self.helpViewController = (HelpViewController *) viewController;
    [viewController release];
	
	viewController = [[AboutViewController alloc] initWithNibName:@"AboutView" bundle:nil];
    self.aboutViewController = (AboutViewController *) viewController;
    [viewController release];
	
	// Assign settings views as the default view
	[self.view addSubview:self.settingsViewController.view];
	self.optionsTabBar.selectedItem = (UITabBarItem*) [self.optionsTabBar.items objectAtIndex:0];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
	
	[settingsViewController dealloc];
	[highScoresViewController dealloc];
	[helpViewController dealloc];
	[aboutViewController dealloc];	
	[optionsTabBar dealloc];
    [super dealloc];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	
	UIView *settingsView = settingsViewController.view;
	[settingsView removeFromSuperview];
	
	UIView *highScoresView = highScoresViewController.view;
	[highScoresView removeFromSuperview];
	
	UIView *helpView = helpViewController.view;
	[helpView removeFromSuperview];
	
	UIView *aboutView = aboutViewController.view;
	[aboutView removeFromSuperview];
	
	if ([item.title isEqualToString:@"Settings"]) {
		[self.view addSubview:settingsView];
	} else if ([item.title isEqualToString:@"High Scores"]) {
		[highScoresViewController showCurrentHighScoreTable];
		[self.view addSubview:highScoresView];
	} else if ([item.title isEqualToString:@"Help"]) {
		[self.view addSubview:helpView];		
	} else if ([item.title isEqualToString:@"About"]) {
		[self.view addSubview:aboutView];				
	}
}

- (void) refresh {
	
	if ([self.highScoresViewController.view superview])
		[self.highScoresViewController showCurrentHighScoreTable];
}

@end

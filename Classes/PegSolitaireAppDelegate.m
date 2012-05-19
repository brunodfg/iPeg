//
//  PegSolitaireAppDelegate.m
//  PegSolitaire
//
//  Created by Bruno Goncalves on 1/21/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "PegSolitaireAppDelegate.h"
#import "RootViewController.h"
#import "PegSettings.h"

@implementation PegSolitaireAppDelegate

@synthesize window;
@synthesize rootViewController;
@synthesize splashViewController;

- (void) applicationDidFinishLaunching:(UIApplication *) application {    

	// Create root view controller to be inserted when the user clicks the "Play" button
	RootViewController *viewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
	self.rootViewController = viewController;
	[viewController release];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	
	[window addSubview:splashViewController.view];
	[window makeKeyAndVisible];
}

- (void) applicationWillTerminate:(UIApplication *) application {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SaveState" object:self userInfo:nil];
}

- (void) dealloc {
	
	[rootViewController release];
    [window release];
    [super dealloc];
}

- (void) onPlay {
	
	[splashViewController.view removeFromSuperview];
	[window addSubview:rootViewController.view];
}


@end

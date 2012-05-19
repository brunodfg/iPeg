//
//  RootViewController.m
//  PegSolitaire
//
//  Created by Bruno Goncalves on 1/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "PegViewController.h"
#import "FlipSideViewController.h"

@implementation RootViewController

@synthesize infoButton;

@synthesize pegViewController;
@synthesize flipSideViewController;
@synthesize flipSideNavigationBar;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad {
	
	[super viewDidLoad];
    
	PegViewController *viewController = [[PegViewController alloc] initWithNibName:@"PegView" bundle:nil];
    self.pegViewController = viewController;
    [viewController release];
    
    [self.view insertSubview:pegViewController.view belowSubview:infoButton];
}

- (void) loadFlipSideViewController {
    
    FlipSideViewController *viewController = [[FlipSideViewController alloc] initWithNibName:@"FlipSideView" bundle:nil];
    self.flipSideViewController = viewController;
    [viewController release];
    
    // Set up the navigation bar
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    navigationBar.barStyle = UIBarStyleBlackOpaque;
	navigationBar.alpha = 0.7;
    self.flipSideNavigationBar = navigationBar;
    [navigationBar release];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeFlipSideView)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    navigationItem.rightBarButtonItem = buttonItem;
    [flipSideNavigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem release];
    [buttonItem release];
}

- (void) closeFlipSideView {

	[self onToggleView];
}

- (IBAction) onToggleView {    
    
	/*
     This method is called when the info or Done button is pressed.
     It flips the displayed view from the main view to the flipside view and vice-versa.
     */
	
    if (flipSideViewController == nil)
        [self loadFlipSideViewController];
    
    UIView *pegView = pegViewController.view;
    UIView *flipSideView = flipSideViewController.view;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:([pegView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
    
    if ([pegView superview] != nil) {
		
		[pegViewController enableRestart:NO];
		[flipSideViewController refresh];
		[flipSideViewController viewWillAppear:YES];
        [pegViewController viewWillDisappear:YES];
        [pegView removeFromSuperview];
        [infoButton removeFromSuperview];
        [self.view addSubview:flipSideView];
        [self.view insertSubview:flipSideNavigationBar aboveSubview:flipSideView];
        [pegViewController viewDidDisappear:YES];
        [flipSideViewController viewDidAppear:YES];
    
	} else {
		
		[pegViewController enableRestart:YES];
        [pegViewController viewWillAppear:YES];
        [flipSideViewController viewWillDisappear:YES];
        [flipSideView removeFromSuperview];
        [flipSideNavigationBar removeFromSuperview];
        [self.view addSubview:pegView];
        [self.view insertSubview:infoButton aboveSubview:pegViewController.view];
        [flipSideViewController viewDidDisappear:YES];
        [pegViewController viewDidAppear:YES];
    }
	
    [UIView commitAnimations];
}

- (void) didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
	
	[super dealloc];
}

@end

//
//  RootViewController.h
//  PegSolitaire
//
//  Created by Bruno Goncalves on 1/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PegViewController;
@class FlipSideViewController;

@interface RootViewController : UIViewController {
    UIButton *infoButton;
    PegViewController *pegViewController;
	FlipSideViewController *flipSideViewController;
    UINavigationBar *flipSideNavigationBar;
}

@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) PegViewController *pegViewController;
@property (nonatomic, retain) FlipSideViewController *flipSideViewController;
@property (nonatomic, retain) UINavigationBar *flipSideNavigationBar;

- (IBAction)onToggleView;

@end

//
//  SettingsViewController.h
//  PegSolitaire
//
//  Created by Bruno Goncalves on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRowHeight 35

@class BoardTypeTableView;

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	UISegmentedControl *difficultyLevelControl;
	BoardTypeTableView *gameTypeTable;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *difficultyLevelControl;
@property (nonatomic, retain) IBOutlet BoardTypeTableView *gameTypeTable;

- (IBAction) difficultyLevelChanged:(id)sender;

@end

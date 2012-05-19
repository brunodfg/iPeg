//
//  SettingsViewController.m
//  PegSolitaire
//
//  Created by Bruno Goncalves on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "PegSettings.h"

@implementation SettingsViewController

@synthesize difficultyLevelControl;
@synthesize gameTypeTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
		
		PegSettings *settings = [PegSettings sharedSettings];
		
		// Set the control with the selected difficulty level
		if (settings.difficulty == Easy)
			self.difficultyLevelControl.selectedSegmentIndex = 0;
		else if (settings.difficulty == Medium)
			self.difficultyLevelControl.selectedSegmentIndex = 1;
		else if (settings.difficulty == Hard)
			self.difficultyLevelControl.selectedSegmentIndex = 2;
		
		// Set the control with the selected game type
		[self.gameTypeTable reloadData];
		[self.gameTypeTable setBackgroundColor:[UIColor clearColor]];
		[self.gameTypeTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:settings.gameType inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
	}
	
	return self;
}

- (void)dealloc {
	
    [super dealloc];
}

- (void) difficultyLevelChanged:(id)sender {

	PegSettings* settings = [PegSettings sharedSettings];
	
	int selectedIndex = [self.difficultyLevelControl selectedSegmentIndex];
	if (selectedIndex == 0)
		settings.difficulty = Easy;
	else if (selectedIndex == 1)
		settings.difficulty = Medium;
	else if (selectedIndex == 2)
		settings.difficulty = Hard;
}

// -----------------------
// Board types UITableView
// -----------------------

// This method will tell UITableView how many sections it will have. 
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {

	return 1;
}

// This method will tell UITableView what to display in section headers.
- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section {

	return @"";
}

// This method will tell UITableView how many cells it will have per section.
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {

	PegSettings *settings = [PegSettings sharedSettings];
	return [[settings getBoardNames] count];
}

// This is the most important method in datasource. After UITableView is created and has a datasource, 
// when a cell is visible on screen, UITableView will query datasource for the cell to decide what to draw in the cell.
- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {

	PegSettings *settings = [PegSettings sharedSettings];
	NSMutableArray *boardNames = [settings getBoardNames];

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil)
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
	
	cell.text = [boardNames objectAtIndex:indexPath.row];
	cell.font = [UIFont boldSystemFontOfSize:12.0];
	
	// Hack to center text
	UILabel* label = [[[cell contentView] subviews] objectAtIndex:0];
	[label setTextAlignment:UITextAlignmentCenter];
	
	return cell;
}

// Defines the height of each table cell
- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {

	return kRowHeight;
}

// Tells the delegate that the specified row is now selected. This method is optional.
- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
		
	PegSettings *settings = [PegSettings sharedSettings];
	settings.gameType = indexPath.row;
	
	//[self.gameTypeTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

@end

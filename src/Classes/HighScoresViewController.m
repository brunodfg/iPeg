//
//  HighScoresViewController.m
//  PegSolitaire
//
//  Created by Bruno Gonçalves on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HighScoresViewController.h"
#import "PegSettings.h"
#import "HighScoreManager.h"
#import "Score.h"

@implementation HighScoresViewController

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil {
    
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
		PegSettings *settings = [PegSettings sharedSettings];
		
		self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
		highScorestableView.backgroundColor = [UIColor clearColor];
		
		NSMutableArray *boardNames = [settings getBoardNames];
		pageControl.numberOfPages = [boardNames count];
		
		[self showCurrentHighScoreTable];
    }
	
    return self;
}

- (void) showCurrentHighScoreTable {
	
	PegSettings *settings = [PegSettings sharedSettings];
	
	pageControl.currentPage = settings.gameType;
	lastPage = pageControl.currentPage;
	[highScorestableView reloadData];
}

- (void) didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
	
    [super dealloc];
}

- (void) pageChanged {

	[pageControl updateCurrentPageDisplay];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:(lastPage < pageControl.currentPage) ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft forView:highScorestableView cache:YES];
	
	[highScorestableView removeFromSuperview];
	[self.view addSubview:highScorestableView];
	
	[UIView commitAnimations];

	[highScorestableView reloadData];
	lastPage = pageControl.currentPage;
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
	
	PegSettings *settings = [PegSettings sharedSettings];
	return [[settings getBoardNames] objectAtIndex:pageControl.currentPage];
}

// This method will tell UITableView how many cells it will have per section.
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {

	return kMaxNumberOfHighScores;
}

// This is the most important method in datasource. After UITableView is created and has a datasource, 
// when a cell is visible on screen, UITableView will query datasource for the cell to decide what to draw in the cell.
- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {

	HighScoreManager *highScoreManager = [HighScoreManager sharedManager];
	NSMutableArray *highScores = [highScoreManager getHighScoresForGameType:pageControl.currentPage];
	
	Score *score = nil;
	if (indexPath.row < [highScores count])
		score = [highScores objectAtIndex:indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil)
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];	
	
	NSString *text = [NSString stringWithFormat:@"%i.", (indexPath.row+1)];
	if (score != nil)
		text = [NSString stringWithFormat:@"%@ %@", text, [score toString]];
	
	cell.text = text;
	cell.font = [UIFont boldSystemFontOfSize:13.0];
	
	return cell;
}

// Defines the height of each table cell
- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	
	return 38;
}

#define kMinDragDistanceRatioToFlip 0.5
#define kMaxDragAngleToFlip 45
#define kMinDragAngleToFlip -45
#define kPI 3.14159265358979323846

- (void) checkFingerDrag {
	
	CGPoint p0 = firstPoint;
	CGPoint p1 = lastPoint;
	
	CGFloat minDistnaceToFlip = self.view.frame.size.width * kMinDragDistanceRatioToFlip;
	CGFloat finalDistance = [self distanceBetweenTwoPoints:p0 toPoint:p1];
	double angDeg = (180 * atan((p1.y - p0.y) / (p1.x - p0.x))) / kPI;
	
	if (finalDistance >= minDistnaceToFlip && (angDeg >= kMinDragAngleToFlip && angDeg <= kMaxDragAngleToFlip)) {
		
		// Flip Right
		if (p1.x < p0.x && pageControl.currentPage < (pageControl.numberOfPages-1)) {
			
			pageControl.currentPage++;
			[self pageChanged];
		}
		
		// Flip Left
		if (p1.x > p0.x && pageControl.currentPage > 0) {
			
			pageControl.currentPage--;
			[self pageChanged];
		}
	}
}

- (CGFloat) distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
	
	float x = toPoint.x - fromPoint.x;
	float y = toPoint.y - fromPoint.y;
	
	return sqrt(x * x + y * y);
}

- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event {
	
	NSSet *allTouches = [event allTouches];
	
	switch ([allTouches count]) {
			
		case 1: {
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			lastPoint = [touch locationInView:self.view];
		} break;			
	}
	
	[self checkFingerDrag];
}


- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
	
	NSSet *allTouches = [event allTouches];
	
	switch ([allTouches count]) {
			
		case 1: {
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			firstPoint = [touch locationInView:self.view];
		} break;			
	}
}

@end

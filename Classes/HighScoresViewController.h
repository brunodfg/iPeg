//
//  HighScoresViewController.h
//  PegSolitaire
//
//  Created by Bruno Gonçalves on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HighScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UIPageControl *pageControl;
	IBOutlet UITableView *highScorestableView;
	CGPoint firstPoint;
	CGPoint lastPoint;
	int lastPage;	
}

- (void) checkFingerDrag;
- (CGFloat) distanceBetweenTwoPoints:(CGPoint) fromPoint toPoint:(CGPoint) toPoint;	
- (IBAction) pageChanged;
- (void) showCurrentHighScoreTable;

@end

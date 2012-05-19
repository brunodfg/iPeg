//
//  PegView.h
//  PegSolitaire
//
//  Created by Bruno Goncalves on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PegBoard;
@class PegViewController;
@class Score;

@interface PegView : UIView <UITextFieldDelegate> {
@public
	PegViewController *pegViewController;
	PegBoard *pegBoard;
	int currentXTouch;
	int currentYTouch;
	int movePhase;
	BOOL isAskingForHighScore;
@private	
	int boardWidth;
	int boardHeight;
	int boardWidthPx;
	int boardHeightPx;
	int xGapPx;
	int yGapPx;
	float cellWidthPx;
	float cellHeightPx;
	int xStartPx;
	int yStartPx;
	UIImage *bgImage;
	UIImage *possibleMoveImage;
	UIImage *selectedSphereImage;
	UIImage *sphereImage;	
	CGImageRef bgImageRef;
	CGImageRef possibleMoveImageRef;
	CGImageRef selectedSphereImageRef;
	CGImageRef sphereImageRef;
	UITextField *txtName;
	Score *currentScore;
}

@property (nonatomic, retain) IBOutlet PegViewController *pegViewController;
@property (nonatomic, retain) PegBoard *pegBoard;
@property int currentXTouch;
@property int currentYTouch;
@property int movePhase;
@property BOOL isAskingForHighScore;
@property (retain) UIImage *bgImage;
@property (retain) UIImage *possibleMoveImage;
@property (nonatomic, retain) UIImage *selectedSphereImage;
@property (nonatomic, retain) UIImage *sphereImage;
@property (nonatomic, assign) CGImageRef bgImageRef;
@property (nonatomic, assign) CGImageRef possibleMoveImageRef;
@property (nonatomic, assign) CGImageRef selectedSphereImageRef;
@property (nonatomic, assign) CGImageRef sphereImageRef;		

- (void) start;
- (void) undoMove;
- (BOOL) isGameOver;

@end
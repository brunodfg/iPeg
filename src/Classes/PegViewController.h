//
//  PegViewController.h
//  PegSolitaire
//
//  Created by Bruno Goncalves on 1/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PegViewController : UIViewController <UIAccelerometerDelegate, UIAlertViewDelegate> {
@public
	UILabel *timeElapsed;
	UILabel *pegsLeft;
	UILabel *undosLeft;	
	UILabel *gameState;
	UIButton *undoButton;
	UIImageView *gameOverView;
	IBOutlet UIImageView *undosBadge;
@private	
	UIAlertView *restartAlertView;	
	UIAcceleration *lastAcceleration;
	int shakeCount;
	BOOL isGameRestarting;
}

@property (nonatomic, retain) IBOutlet UILabel *timeElapsed;
@property (nonatomic, retain) IBOutlet UILabel *pegsLeft;
@property (nonatomic, retain) IBOutlet UILabel *undosLeft;
@property (nonatomic, retain) IBOutlet UILabel *gameState;
@property (nonatomic, retain) IBOutlet UIButton *undoButton;
@property (nonatomic, retain) IBOutlet UIImageView *gameOverView;
@property (nonatomic, retain) UIAlertView *restartAlertView;
@property (nonatomic, retain) UIAcceleration *lastAcceleration;
@property int shakeCount;
@property BOOL isGameRestarting;

- (IBAction) undoMove;
- (IBAction) onRestart;
- (void) updateTimeElapsed:(int) totalSecondsElapsed;
- (void) updatePegsLeft:(int) pegsCount;
- (void) updateUndosLeft:(int) undosCount;
- (void) updateGameState:(BOOL) isGameOver;
- (void) enableRestart:(BOOL) isEnabled;

@end;

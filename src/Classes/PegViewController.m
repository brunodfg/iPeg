//
//  PegViewController.m
//  PegSolitaire
//
//  Created by Bruno Goncalves on 1/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PegViewController.h"
#import "PegView.h"

@interface PegViewController (Private)

- (void) configureFonts;
- (void) configureRestartAlert;
- (void) configureAccelerometer;
- (BOOL) accelerationIsShakingLast:(UIAcceleration *)last current:(UIAcceleration *)current threshold:(double)threshold;
- (void) restartGame;
	
@end

@implementation PegViewController (Private)

// ---------------
// Private methods
// ---------------

- (void) configureFonts {

	[self.timeElapsed setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	[self.pegsLeft setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	[self.gameState setFont:[UIFont fontWithName:@"Helvetica" size:24.0]];
}

- (void) configureRestartAlert {

	self.restartAlertView = [[UIAlertView alloc] initWithTitle:@"Restart Game" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
	[self.restartAlertView addButtonWithTitle:@"Ok"];
}

#define AccelerometerFrequency 50 //Hz
- (void) configureAccelerometer {
	
    UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 1 / AccelerometerFrequency;
    accelerometer.delegate = self;
}

- (BOOL) accelerationIsShakingLast:(UIAcceleration *)last current:(UIAcceleration *)current threshold:(double)threshold {
	
    double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y),
    deltaZ = fabs(last.z - current.z);
	
    return
    (deltaX > threshold && deltaY > threshold) ||
    (deltaX > threshold && deltaZ > threshold) ||
    (deltaY > threshold && deltaZ > threshold);
}

- (void) restartGame {
	
	PegView *pegView = (PegView *) self.view;
	
	if (!self.isGameRestarting && !pegView.isAskingForHighScore) {
		
		self.shakeCount = 0;
		
		// Restart without confirmation
		if ([pegView isGameOver]) {
		
			[pegView start];

		// Ask confirmation before restart
		} else {
			
			self.isGameRestarting = YES;
			[self.restartAlertView show];
		}
	}
}

@end

// ---------------------
// Public implementation
// ---------------------

@implementation PegViewController

@synthesize timeElapsed;
@synthesize pegsLeft;
@synthesize undosLeft;
@synthesize gameState;
@synthesize undoButton;
@synthesize gameOverView;
@synthesize restartAlertView;
@synthesize lastAcceleration;
@synthesize shakeCount;
@synthesize isGameRestarting;

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	self.isGameRestarting = NO;
	
	if (buttonIndex == 1) {
		
		PegView* pegView = (PegView*) self.view;
		[pegView start];
	}
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
	if (self.lastAcceleration) {
		
        if ([self accelerationIsShakingLast:self.lastAcceleration current:acceleration threshold:0.5] && shakeCount >= 7) {
			[self restartGame];
        } else if ([self accelerationIsShakingLast:self.lastAcceleration current:acceleration threshold:0.5]) {
			shakeCount = shakeCount + 5;
        } else if (![self accelerationIsShakingLast:self.lastAcceleration current:acceleration threshold:0.2]) {
			if (shakeCount > 0) {
				shakeCount--;
			}
        }
    }
	
    self.lastAcceleration = acceleration;
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		self.isGameRestarting = NO;
		
		[self configureFonts];
		[self configureAccelerometer];
		[self configureRestartAlert];
		
		PegView* pegView = (PegView*) self.view;
		[pegView start];
	}
    
	return self;
}

- (void) undoMove {
	
	PegView* pegView = (PegView*) self.view;
	[pegView undoMove];
}

- (void) onRestart {
	
	[self restartGame];
}

- (void) updateTimeElapsed:(int) totalSecondsElapsed {
	
	if (totalSecondsElapsed < 0) {
		
		self.timeElapsed.text = @"";
		return;
	}
		
	int minutesElapsed = abs(totalSecondsElapsed / 60);
	int secondsElapsed = abs(totalSecondsElapsed % 60);
	
	NSString* tmp = [[NSString alloc] initWithFormat:@"%02d:%02d", minutesElapsed, secondsElapsed];
	self.timeElapsed.text = tmp;
	
	[tmp release];
}

- (void) updatePegsLeft:(int) pegsCount {

	NSString* tmp = [[NSString alloc] initWithFormat:@"%i Pegs", pegsCount];
	self.pegsLeft.text = tmp;
	
	[tmp release];
}

- (void) updateUndosLeft:(int) undosCount {
	
	NSString* tmp;
	if (undosCount >= 0) {
		
		undosBadge.alpha = 1.0;
		tmp = [[NSString alloc] initWithFormat:@"%i", undosCount];
	
	} else {
		
		undosBadge.alpha = 0.0;
		tmp = @"";
	}
	
	self.undosLeft.text = tmp;
	[tmp release];
}

- (void) updateGameState:(BOOL) isGameOver {
	
	if (isGameOver)
		[self.view addSubview: self.gameOverView];
	else
		[self.gameOverView removeFromSuperview];
}

- (void) enableRestart:(BOOL) isEnabled {

	self.isGameRestarting = !isEnabled;
}

- (void)dealloc {
	
	[timeElapsed release];
	[pegsLeft release];
	[undosLeft release];	
	[gameState release];
	
    [super dealloc];
}

@end

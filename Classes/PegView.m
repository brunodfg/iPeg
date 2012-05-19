//
//  PegView.m
//  PegSolitaire
//
//  Created by Bruno Goncalves on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PegView.h"
#import "PegBoard.h"
#import "PegViewController.h"
#import "PegSettings.h"
#import "Score.h"
#import "HighScoreManager.h"

@interface PegView (Private) 

- (void) initDisplaySettings:(PegBoard *) board;
- (void) timeElapsed:(NSNotification *)notification;
- (NSMutableArray *) convertTouch:(NSSet *) touches;
- (void) drawPegsOnContext:(CGContextRef) context;
- (void) askForHighScoreName;
- (void) computeScore;

@end

@implementation PegView (Private)

// ---------------
// Private methods
// ---------------

- (void) initDisplaySettings:(PegBoard *) board {
	
	self.bgImage = [UIImage imageNamed:board.boardImagePath];
	self.possibleMoveImage = [UIImage imageNamed:@"PossibleMoveSphere.png"];
	self.selectedSphereImage = [UIImage imageNamed:@"SelectedSphere.png"];
	self.sphereImage = [UIImage imageNamed:@"Sphere.png"];
	
	self.bgImageRef = CGImageRetain(bgImage.CGImage);
	self.possibleMoveImageRef = CGImageRetain(possibleMoveImage.CGImage);
	self.selectedSphereImageRef = CGImageRetain(selectedSphereImage.CGImage);
	self.sphereImageRef = CGImageRetain(sphereImage.CGImage);	
	
	boardWidth = board.width;
	boardHeight = board.height;
	boardWidthPx = boardWidth * 44;
	boardHeightPx = boardWidth * 44;
	xGapPx = 1;
	yGapPx = 1;
	
	cellWidthPx = (boardWidthPx / boardWidth) - xGapPx;
	cellHeightPx = (boardHeightPx / boardHeight) - yGapPx;
	xStartPx = (320 - boardWidthPx) / 2;
	yStartPx = (board.width == 6) ? (cellHeightPx * 2.5) : cellHeightPx * 2;
}

- (void) timeElapsed:(NSNotification *) notification {

	[self.pegViewController updateTimeElapsed: pegBoard.elapsedSeconds];
}


- (NSMutableArray *) convertTouch:(NSSet *) touches {
	
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];	
	// Get the pixel location of the touch
	CGPoint touchPoint = [touch locationInView:self];	
	
	// Convert the pixel location of the touch to an index of the board
	NSMutableArray * boardLocation = [[NSMutableArray alloc] initWithCapacity:2];
	[boardLocation addObject:[[NSNumber alloc] initWithInt: ((touchPoint.x - xStartPx) / cellWidthPx)]];
	[boardLocation addObject:[[NSNumber alloc] initWithInt: ((touchPoint.y - yStartPx) / cellHeightPx)]];
	
	return boardLocation;
}

- (void) drawPegsOnContext:(CGContextRef) context {
	
	// Update the peg count label
	[self.pegViewController updatePegsLeft:[self.pegBoard getNumberOfPegs]];
	
	// Get possible moves from current selected peg
	NSMutableArray *possibleMoves = nil;
	if (self.currentXTouch != -1 && self.currentYTouch != -1)
		possibleMoves = [self.pegBoard getPossibleMovesFromX:self.currentXTouch andY:self.currentYTouch];
	
	// Draw pegs
	for (int x = 0 ; x < boardHeight ; x++) {
		
		float xPx = xStartPx + (x * (cellHeightPx + xGapPx));
		
		for (int y = 0 ; y < boardWidth ; y++) {
			
			BOOL isPossibleMoveLocation = NO;
			if (possibleMoves != nil && [possibleMoves count] > 0) {
				for (int i = 0 ; i < [possibleMoves count] ; i++) {
					
					NSArray *point = [possibleMoves objectAtIndex:i];
					
					int tmpX = [(NSNumber *) [point objectAtIndex:0] intValue];
					int tmpY = [(NSNumber *) [point objectAtIndex:1] intValue];
					if (tmpX == x && tmpY == y)
						isPossibleMoveLocation = YES;
				}
			}
			
			if ([self.pegBoard isValidBoardPositionOnX:x andY:y]) {
				
				float yPx = yStartPx + (y * (cellWidthPx + yGapPx));
				CGRect pegRect = CGRectMake(xPx, yPx, cellWidthPx, cellHeightPx);
				
				if (isPossibleMoveLocation) {
					// Possible move position
					CGContextDrawImage(context, pegRect, possibleMoveImageRef);
				} else if (x == self.currentXTouch && y == self.currentYTouch) {
					// Selected position
					CGContextDrawImage(context, pegRect, selectedSphereImageRef);
				} else if ([self.pegBoard hasPegOnX:x andY:y]) {
					// Peg image
					CGContextDrawImage(context, pegRect, sphereImageRef);
				}
			}
		}
	}
	
	// ToDo: How to release the possibleMoves array?
}

- (void) askForHighScoreName {

	PegSettings *settings = [PegSettings sharedSettings];
	
	self.isAskingForHighScore = YES;
	
	txtName = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 47.0, 260.0, 25.0)];
	
	txtName.text = settings.lastNameInserted;
	txtName.textAlignment = UITextAlignmentCenter;
	txtName.textColor = [UIColor grayColor];
	txtName.backgroundColor = [UIColor whiteColor];
	txtName.delegate = self;
	txtName.clearsOnBeginEditing = YES;
	
	UIAlertView *highScoreAlertView = [[UIAlertView alloc] initWithTitle:@"New high score!" message:@"Your name here" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	
	[highScoreAlertView setTransform:CGAffineTransformMakeTranslation(0.0, 125.0)];
	[highScoreAlertView addSubview:txtName];
	[highScoreAlertView show];
	[highScoreAlertView release];	
}

- (void) computeScore {
	
	PegSettings *settings = [PegSettings sharedSettings];
	HighScoreManager *highScoreManager = [HighScoreManager sharedManager];
	
	[currentScore release];
	
	currentScore = [[Score alloc] init];
	currentScore.pegsLeft = [self.pegBoard getNumberOfPegs];
	currentScore.timeElapsed = self.pegBoard.elapsedSeconds;
	currentScore.difficultyLevel = settings.difficulty;
	
	if ([highScoreManager isHighScore:currentScore forGameType:self.pegBoard.gameType]) {
		
		[self askForHighScoreName];
	}
}

@end

// ---------------------
// Public implementation
// ---------------------

@implementation PegView

@synthesize pegViewController;
@synthesize pegBoard;
@synthesize currentXTouch;
@synthesize currentYTouch;
@synthesize movePhase;
@synthesize bgImage;
@synthesize possibleMoveImage;
@synthesize selectedSphereImage;
@synthesize sphereImage;
@synthesize bgImageRef;
@synthesize possibleMoveImageRef;
@synthesize selectedSphereImageRef;
@synthesize sphereImageRef;
@synthesize isAskingForHighScore;

- (void) start {

	// Makes sure the pegBoard is released each time the player restarts the game 
	[self.pegBoard stopTimer];
	self.pegBoard = nil;
	
	self.currentXTouch = -1;
	self.currentYTouch = -1;
	self.movePhase = 1;
	self.isAskingForHighScore = NO;
	
	PegBoard *tmpBoard = [[PegBoard alloc] init];
	self.pegBoard = tmpBoard;
	[tmpBoard release];
	
	// Initializes default view settings such as distances for holes and pegs...
	[self initDisplaySettings:self.pegBoard];

	// Register time elapsed notification
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeElapsed:) name:@"GameTimeElapsed" object:nil];

	// Reset the elapsed time
	[self.pegViewController updateTimeElapsed:self.pegBoard.elapsedSeconds];
	
	// Update the number of pegs left
	[self.pegViewController updatePegsLeft:[self.pegBoard getNumberOfPegs]];

	// Update the number of undos left
	[self.pegViewController updateUndosLeft:[self.pegBoard getNumberOfUndosLeft]];
	
	// Update the game state
	[self.pegViewController updateGameState:![self.pegBoard hasPossibleMovesLeft]];
	
	[self setNeedsDisplay];
}

- (void) undoMove {
		
	if ([self.pegBoard undoMove]) {
		
		// Reset possible selected peg
		self.currentXTouch = -1;
		self.currentYTouch = -1;
		self.movePhase = 1;

		[self.pegViewController updateUndosLeft:[self.pegBoard getNumberOfUndosLeft]];
		[self setNeedsDisplay];
	}
}

- (BOOL) isGameOver {

	if (self.pegBoard)
		return ![self.pegBoard hasPossibleMovesLeft];
	
	return YES;
}

- (void) drawRect:(CGRect)rect {

	// Clear view
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
		
	// Draw board
	CGContextDrawImage(context, rect, self.bgImageRef);
	
	// Draw pegs
	[self drawPegsOnContext:context];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// Nothing is selected - leave as is and set the move phase to 1
	if (self.currentXTouch == -1 && self.currentYTouch == -1) {

		self.movePhase = 1;
		
		[self setNeedsDisplay];
		return;
	}
	
	// Something is selected
	if (self.currentXTouch != -1 && self.currentYTouch != -1) {
	
		self.movePhase = 2;
		
		// A peg is being pointed at by currentX and currentY.
		// We just need to make sure if it is a movable peg
		if (![self.pegBoard hasPossibleMoveOnX:self.currentXTouch andY:self.currentYTouch]) {
			
			self.currentXTouch = -1;
			self.currentYTouch = -1;
			self.movePhase = 1;
		}
		
		[self setNeedsDisplay];
		return;
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// Note:
	// Phase ONE of the move lifecycle: Waiting for a peg to be selected
	// Phase TWO of the move lifecycle: Waiting for a hole to be selected
	
	NSMutableArray * tmp = [self convertTouch:touches];
	int tmpXTouch = [[tmp objectAtIndex:0] intValue];
	int tmpYTouch = [[tmp objectAtIndex:1] intValue];
	[tmp release];
	
	// Click is outside of the board.
	if (![self.pegBoard isValidBoardPositionOnX:tmpXTouch andY:tmpYTouch]) {
		
		// If we are in phase ONE of the move lifecycle then we leave the currentTouch var with -1
		// If we are in phase TWO of the move lifecycle, we should ignore this touch and leave the selected peg as it is
	
		[self setNeedsDisplay];
		return;
	}
	
	// Click is inside of the board - either a Peg or a Hole

	// We are in phase ONE of the move lifecycle - nothing is selected
	if (self.movePhase == 1) {
		
		// Only select the touched location if it is a coordinate with a peg
		// Advance the move phase to the second one
		if ([self.pegBoard hasPegOnX:tmpXTouch andY:tmpYTouch]) {
			
			self.currentXTouch = tmpXTouch;
			self.currentYTouch = tmpYTouch;

		} else {
			
			self.currentXTouch = -1;
			self.currentYTouch = -1;
		}
		
		[self setNeedsDisplay];
		return;
	}

	
	// We are in phase TWO of the move lifecycle - a movable peg is already selected
	if (self.movePhase == 2) {
		
		// The same peg was selected. Unselect so that the move phase can be reverted to 1 in the
		// touchesEnded event
		if (self.currentXTouch == tmpXTouch && self.currentYTouch == tmpYTouch) {
				
			self.currentXTouch = -1;
			self.currentYTouch = -1;
		
		// Try to move the peg to the selected position.
		} else {
			
			BOOL moved = [self.pegBoard movePegFromX:self.currentXTouch andY:self.currentYTouch toX:tmpXTouch andY:tmpYTouch];
			
			// If the peg was successfully moved set the currentTouch var to -1
			// so that the move phase can be reverted to 1 in the touchesEnded event
			if (moved) {

				self.currentXTouch = -1;
				self.currentYTouch = -1;

				
				// Game is over - compute score
				if (![self.pegBoard hasPossibleMovesLeft]) {

					[self computeScore];
					[self.pegViewController updateGameState:YES];
				}

			} else {
				
				// Either the move couldn't be done because a invalid hole was selected
				// In this case we should leave the selected peg as it is
				
				// Or because another peg was selected
				// In this case we should set that peg as the one selected
				if ([self.pegBoard hasPegOnX:tmpXTouch andY:tmpYTouch]) {
					self.currentXTouch = tmpXTouch;
					self.currentYTouch = tmpYTouch;
				}
			}
		}
		
		[self setNeedsDisplay];
		return;
	}
}

- (void)dealloc {

	[self.pegBoard release];
    [super dealloc];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField { 
	
	if (textField == txtName)
		[txtName resignFirstResponder];

	return YES;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0) {
		
		[self textFieldShouldReturn:txtName];

		HighScoreManager *highScoreManager = [HighScoreManager sharedManager];
		PegSettings *settings = [PegSettings sharedSettings];
		
		// Insert high score after name has been provided
		[currentScore setName:txtName.text];
		[highScoreManager insertHighScore:currentScore forGameType:self.pegBoard.gameType];
		[settings setLastNameInserted:txtName.text];
		
		self.isAskingForHighScore = NO;
	}
}

@end

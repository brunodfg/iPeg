//
//  PegBoard.h
//  PegSolitaire
//
//  Created by Bruno Goncalves on 1/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ValueNotDefined -9999
#define HVMove 0 // Horizontal and Vertical moves only
#define HVDMove 1 // Horizontal, Vertical and Diagonal moves

@interface PegBoard : NSObject {
@public
	NSString *boardImagePath;
	NSMutableArray *board;
	NSMutableArray *moves;
	NSTimer *timer;
	int gameType;
	int difficulty;
	int movesType;
	int undoCount;
	int width;
	int height;
	int elapsedSeconds;
}

@property (retain) NSString *boardImagePath;
@property (retain) NSMutableArray *board;
@property (retain) NSMutableArray *moves;
@property (retain) NSTimer *timer;
@property int gameType;
@property int difficulty;
@property int movesType;
@property int undoCount;
@property int width;
@property int height;
@property int elapsedSeconds;

// Invalidates a timer
- (void) stopTimer;

// Method called on each tick of the timer
- (void) onTimer;

// Undo the last move by putting the board in the previous state
- (BOOL) undoMove;

// Returns true if there is a peg on the specified position (x,y)
- (BOOL) hasPegOnX:(int) x andY:(int) y;

// Tries moving a peg from one position (fX, fY) to another (tX, tY)
- (BOOL) movePegFromX:(int) fromX andY:(int)fromY toX:(int)toX andY:(int)toY;	

// Returns true if the player still can perform valid moves on the board, false otherwise
- (BOOL) hasPossibleMovesLeft;

// Returns true if the playes has won the game, i.e: there is only one peg left. False otherwise
- (BOOL) isGameFinished;

// Checks whether a given board location (x,y) is a valid position
- (BOOL) isValidBoardPositionOnX:(int) x andY:(int) y;

// Checks whether the peg located on (x,y) can make a valid move
- (BOOL) hasPossibleMoveOnX:(int) x andY:(int) y;

// Returns a set of all possible moves from a single location
- (NSMutableArray *) getPossibleMovesFromX:(int) fromX andY:(int) fromY;

// Returns the number of pegs currently on the board
- (int) getNumberOfPegs;

// Returns the number of undos that the user can still perform. This value will depend on the difficulty level
- (int) getNumberOfUndosLeft;

// Retrieves a saved pegBoard from NSUserDefaults
- (void) loadState;

// Saves the current pegBoard to NSUserDefaults
- (void) saveState;

// Gets the pegBoar representation in form of a dictionary
- (NSDictionary *) getStateDictionary;

@end
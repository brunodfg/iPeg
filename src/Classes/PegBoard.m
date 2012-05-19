//
//  PegBoard.m
//  PegSolitaire
//
//  Created by Bruno Goncalves on 1/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PegBoard.h"
#import "PegSettings.h"

@interface PegBoard (Private)

- (void) parseSettings:(NSArray *) settings;
- (BOOL) isInvalidValueAtIndex:(int) i;
- (int) getValueAtIndex:(int) i;
- (BOOL) isValidMoveFromX:(int) fromX andY:(int) fromY toX:(int) toX andY:(int) toY;
- (int) getIndexFromX:(int) x andY:(int) y;
- (int) getMiddleIndexFromX:(int) fromX andY:(int) fromY toX:(int) toX andY:(int) toY;
- (void) onSaveState:(NSNotification *) notification;

+ (void) initialize;

@end

@implementation PegBoard (Private)

static NSNumber* Hole;
static NSNumber* Peg;
static NSNumber* Out;

// ---------------
// Private methods
// ---------------
- (void) parseSettings:(NSArray *) settings {
	
	for (int i = 0 ; i < [settings count] ; i++) {
		
		NSString *separator = [NSString stringWithFormat:@"="];
		NSArray  *kvp = [[settings objectAtIndex:i] componentsSeparatedByString:separator];
		
		if ([kvp count] == 2) {
			
			NSString *key = [kvp objectAtIndex:0];
			NSString *val = [kvp objectAtIndex:1];
			
			if ([key compare:@"width" options:NSCaseInsensitiveSearch] == 0) {
				self.width = [val intValue];
			} else if ([key compare:@"height" options:NSCaseInsensitiveSearch] == 0) {
				self.height = [val intValue];
			} else if ([key compare:@"bg" options:NSCaseInsensitiveSearch] == 0) {
				self.boardImagePath = [NSString stringWithString:val];
			} else if ([key compare:@"movesType" options:NSCaseInsensitiveSearch] == 0) {
				self.movesType = [val intValue];
			} else if ([key compare:@"board" options:NSCaseInsensitiveSearch] == 0) {
				
				NSArray *boardValues = [val componentsSeparatedByString:@" "];
				for (int j = 0 ; j < [boardValues count] ; j++) {
					
					int boardItemValue = [[boardValues objectAtIndex:j] intValue];
					
					if (boardItemValue == [Out intValue]) {
						[self.board addObject:[Out copy]]; 
					} else if (boardItemValue == [Hole intValue]) { 
						[self.board addObject:[Hole copy]]; 
					} else if (boardItemValue == [Peg intValue]) { 
						[self.board addObject:[Peg copy]]; 
					}
				}
			}
		}
	}
}

// Returns true if the position trying to be accessed is not a valid PegBoard position.
// This is needed because the PegBoard is a cross implemented in a linear array
- (BOOL) isInvalidValueAtIndex:(int) i {
	
	int value = [self getValueAtIndex:i]; 
	if ((value == [Out intValue]) || (value == ValueNotDefined))
		return YES;
	else
		return NO;
}

- (int) getValueAtIndex:(int) i {
	
	int value = ValueNotDefined;

	if (i >= 0 && i < [self.board count]) {
		
		NSNumber *tmp = [board objectAtIndex:i];
		value = [tmp intValue];
	}
	
	return value;
}

- (BOOL) isValidMoveFromX:(int) fromX andY:(int) fromY toX:(int) toX andY:(int) toY {
	
	// ToDo: Refactor this method
	
	int pFrom = [self getIndexFromX:fromX andY:fromY];
	int pTo = [self getIndexFromX:toX andY:toY];
	int pMiddle = ValueNotDefined;
	
	// Invalid board positions - outside of the board
	if ([self isInvalidValueAtIndex:pFrom] || [self isInvalidValueAtIndex:pTo])
		return NO;

	if (self.movesType == HVMove) {
		
		// From and To either in the same position or in different line and column
		if ((fromX == toX && fromY == toY) || (fromX != toX && fromY != toY))
			return NO;
	}
	
	if (self.movesType == HVDMove) {
		
		// From and To are in the same position
		if (fromX == toX && fromY == toY)
			return NO;
	}
	
	// From is empty or To is occupied
	if (([self getValueAtIndex:pFrom] != [Peg intValue]) || ([self getValueAtIndex:pTo] != [Hole intValue]))
		return NO;

	// From and To are NOT one hole either horizontaly, vertically or diagonally appart
	// Middle position is NOT occupied
	pMiddle = [self getMiddleIndexFromX:fromX andY:fromY toX:toX andY:toY];
	if ([self getValueAtIndex:pMiddle] != [Peg intValue])
		return NO;
	
	// All rules for movement are valid at this point. Return true
	return YES;
}

// Private method to convert a two-dimentional position to a linear position
- (int) getIndexFromX:(int) x andY:(int) y {
	
	if (x < 0 || x >= self.width)
		return ValueNotDefined;
	
	if (y < 0 || y >= self.height)
		return ValueNotDefined;
	
	return (y * self.width) + x;
}

// Returns the index of the position which is in the middle of the specified locations. 
// Returns -1 if the specified locations are not one hole appart
- (int) getMiddleIndexFromX:(int) fromX andY:(int) fromY toX:(int) toX andY:(int) toY {
	
	// ToDo: Refactor this method
	
	if (self.movesType == HVMove)
		if ((fromX == toX && abs(fromY-toY) != 2) || (fromY == toY && abs(fromX-toX) != 2))
			return ValueNotDefined;
	
	if (self.movesType == HVDMove) {
		
		// Horizontal and vertical moves
		if ((fromX == toX && abs(fromY-toY) != 2) || (fromY == toY && abs(fromX-toX) != 2))
			return ValueNotDefined;
		
		// Diagonal move
		if ((fromX != toX) && (fromY != toY) && (abs(fromX-toX) != 2 || abs(fromY-toY) != 2))
			return ValueNotDefined;
	}
	
	if (self.movesType == HVMove) {
		
		if (fromX == toX) {
			if (fromY > toY)
				return [self getIndexFromX:fromX andY:fromY-1];
			else
				return [self getIndexFromX:fromX andY:fromY+1];
		}
		
		if (fromY == toY) {
			if (fromX > toX)
				return [self getIndexFromX:fromX-1 andY:fromY];
			else
				return [self getIndexFromX:fromX+1 andY:fromY];
		}
	}
	
	if (self.movesType == HVDMove) {
		
		int middleX = fromX;
		int middleY = fromY;
		
		if (fromX > toX)
			middleX = fromX-1;
		else if (fromX < toX)
			middleX = fromX+1;
		
		if (fromY > toY)
			middleY = fromY-1;
		else if (fromY < toY)
			middleY = fromY+1;
		
		return [self getIndexFromX:middleX andY:middleY];		
	}
	
	return ValueNotDefined;
}

- (void) onSaveState:(NSNotification *) notification {

	[self saveState];
}

// --------------
// Static methods
// --------------

// Static method to initialize board static variables
+ (void) initialize {

	Out = [NSNumber numberWithInt:-1];
	Hole = [NSNumber numberWithInt:0];
	Peg = [NSNumber numberWithInt:1];
}

@end

// ---------------------
// Public implementation
// ---------------------

@implementation PegBoard

@synthesize board;
@synthesize moves;
@synthesize timer;
@synthesize gameType;
@synthesize difficulty;
@synthesize movesType;
@synthesize boardImagePath;
@synthesize undoCount;
@synthesize width;
@synthesize height;
@synthesize elapsedSeconds;

- (PegBoard*) init {

	self = [super init];
	
	if (self) {
	
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSaveState:) name:@"SaveState" object:nil];
		
		[self loadState];

		// Only start the timer if the game is in a state which allows moves
		if ([self hasPossibleMovesLeft])
			[self setTimer:[NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(onTimer) userInfo:nil repeats:YES]];
	}
	
	return self;
}

// -----------------------
// Public instance methods
// -----------------------

// Undo the last move by putting the board in the previous state
- (BOOL) undoMove {

	if ([moves count] > 0) {

		if ([self getNumberOfUndosLeft] == 0)
			return NO;
		
		if ([self hasPossibleMovesLeft]) {
			
			NSArray* tmp = [moves lastObject];
		
			// ToDo: What happens to the replaced value? Is it released?
			int pFrom = [[tmp objectAtIndex:0] intValue];
			[self.board replaceObjectAtIndex:pFrom withObject:[Peg copy]];
			
			int pMiddle = [[tmp objectAtIndex:1] intValue];
			[self.board replaceObjectAtIndex:pMiddle withObject:[Peg copy]];

			int pTo = [[tmp objectAtIndex:2] intValue];
			[self.board replaceObjectAtIndex:pTo withObject:[Hole copy]];
		
			[moves removeLastObject];
			undoCount++;
			
			return YES;
		}
	}
	
	return NO;
}

// Returns true if there is a peg on the specified position (x,y)
- (BOOL) hasPegOnX:(int) x andY:(int) y {
	
	int p0 = [self getIndexFromX:x andY:y];
	
	if ([self getValueAtIndex:p0] == [Peg intValue])
		return YES;
	else
		return NO;
}

// Tries moving a peg from one position (fX, fY) to another (tX, tY)
- (BOOL) movePegFromX:(int) fromX andY:(int)fromY toX:(int)toX andY:(int)toY {

	if (![self isValidMoveFromX: fromX andY:fromY toX: toX andY:toY])
		return NO;
	
	int pFrom = [self getIndexFromX:fromX andY:fromY];
	int pMiddle = [self getMiddleIndexFromX:fromX andY:fromY toX:toX andY:toY];
	int pTo = [self getIndexFromX:toX andY:toY];

	// ToDo: What happens to the replaced value? Is it released?
	NSNumber* tmpValue = [self.board objectAtIndex:pFrom];
	[self.board replaceObjectAtIndex:pFrom withObject:[Hole copy]];
	[tmpValue release];
	
	tmpValue = [self.board objectAtIndex:pMiddle];
	[self.board replaceObjectAtIndex:pMiddle withObject:[Hole copy]];
	[tmpValue release];
	
	tmpValue = [self.board objectAtIndex:pTo];
	[self.board replaceObjectAtIndex:pTo withObject:[Peg copy]];
	[tmpValue release];
	
	// Adds the move indexes to the end of the moves array (to allow undoing the move)
	NSArray* tmp = [[NSArray alloc] initWithObjects: [NSNumber numberWithInt: pFrom], [NSNumber numberWithInt: pMiddle], [NSNumber numberWithInt: pTo], nil];
	[moves addObject:tmp];
	[tmp release];
	
	// Stop the timer when the user has no possible moves left
	if (![self hasPossibleMovesLeft])
		[self.timer invalidate];
	
	return YES;
}

// Returns true if the player still can perform valid moves on the board, false otherwise
- (BOOL) hasPossibleMovesLeft {

	for (int x = 0 ; x < self.width ; x++)
		for (int y = 0 ; y < self.height ; y++)
			if ([self getValueAtIndex:[self getIndexFromX:x andY:y]] == [Peg intValue])
				if ([self hasPossibleMoveOnX:x andY:y])
					return YES;
	
	return NO;
}

// Returns true if the playes has won the game, i.e: there is only one peg left. False otherwise
- (BOOL) isGameFinished {
	
	int count = 0;
	for (int i = 0 ; i < [self.board count] ; i++)
		if ([self getValueAtIndex:i] == [Peg intValue])
			count++;

	if (count == 1)
		return YES;
	else
		return NO;
}

// Checks whether a given board location (x,y) is a valid position
- (BOOL) isValidBoardPositionOnX:(int) x andY:(int) y {

	int i = [self getIndexFromX:x andY:y];	
	return ![self isInvalidValueAtIndex:i];
}

// Checks whether the peg located on (x,y) can make a valid move
- (BOOL) hasPossibleMoveOnX:(int) x andY:(int) y {
	
	if (![self isValidBoardPositionOnX:x andY:y])
		return NO;
	
	if (![self hasPegOnX:x andY:y])
		return NO;
	
	// Up
	if ([self isValidMoveFromX:x andY:y toX:x andY:(y-2)])
		return YES;
		
	// Down
	if ([self isValidMoveFromX:x andY:y toX:x andY:(y+2)])
		return YES;
	
	// Left
	if ([self isValidMoveFromX:x andY:y toX:(x-2) andY:y])
		return YES;
	
	// Right
	if ([self isValidMoveFromX:x andY:y toX:(x+2) andY:y])
		return YES;
	
	// Check diagonally as well
	if (self.movesType == HVDMove) {
		
		// Up-Left
		if ([self isValidMoveFromX:x andY:y toX:(x-2) andY:(y-2)])
			return YES;
		
		// Up-Right
		if ([self isValidMoveFromX:x andY:y toX:(x+2) andY:(y-2)])
			return YES;
		
		// Down-Left
		if ([self isValidMoveFromX:x andY:y toX:(x-2) andY:(y+2)])
			return YES;
		
		// Down-Right
		if ([self isValidMoveFromX:x andY:y toX:(x+2) andY:(y+2)])
			return YES;
	}
	
	return NO;
}

// Returns a set of all possible moves from a single location
- (NSMutableArray *) getPossibleMovesFromX:(int) fromX andY:(int) fromY {
	
	// ToDo: Analyze possible memory leaks or missing deallocations
	
	NSMutableArray *possibleMoves = [NSMutableArray arrayWithCapacity:0];
	NSMutableArray *point = [NSMutableArray arrayWithCapacity:2];
	
	if ([self hasPegOnX:fromX andY:fromY]) {

		// Check move up
		[point removeAllObjects];
		[point addObject:[NSNumber numberWithInt:fromX]];
		[point addObject:[NSNumber numberWithInt:(fromY-2)]];
		if ([self isValidMoveFromX:fromX andY:fromY toX:fromX andY:(fromY-2)])
			[possibleMoves addObject: [NSArray arrayWithArray:point]];
		
		// Check move down
		[point removeAllObjects];
		[point addObject:[NSNumber numberWithInt:fromX]];
		[point addObject:[NSNumber numberWithInt:(fromY+2)]];
		if ([self isValidMoveFromX:fromX andY:fromY toX:fromX andY:(fromY+2)])
			[possibleMoves addObject: [NSArray arrayWithArray:point]];
		
		// Check move left
		[point removeAllObjects];
		[point addObject:[NSNumber numberWithInt:(fromX-2)]];
		[point addObject:[NSNumber numberWithInt:fromY]];
		if ([self isValidMoveFromX:fromX andY:fromY toX:(fromX-2) andY:fromY])
			[possibleMoves addObject: [NSArray arrayWithArray:point]];
		
		// Check move right
		[point removeAllObjects];
		[point addObject:[NSNumber numberWithInt:(fromX+2)]];
		[point addObject:[NSNumber numberWithInt:fromY]];
		if ([self isValidMoveFromX:fromX andY:fromY toX:(fromX+2) andY:fromY])
			[possibleMoves addObject: [NSArray arrayWithArray:point]];
		
		if (self.movesType == HVDMove) {
			
			// Up-Left
			[point removeAllObjects];
			[point addObject:[NSNumber numberWithInt:(fromX-2)]];
			[point addObject:[NSNumber numberWithInt:(fromY-2)]];
			if ([self isValidMoveFromX:fromX andY:fromY toX:(fromX-2) andY:(fromY-2)])
				[possibleMoves addObject: [NSArray arrayWithArray:point]];
			
			// Up-Right
			[point removeAllObjects];
			[point addObject:[NSNumber numberWithInt:(fromX+2)]];
			[point addObject:[NSNumber numberWithInt:(fromY-2)]];
			if ([self isValidMoveFromX:fromX andY:fromY toX:(fromX+2) andY:(fromY-2)])
				[possibleMoves addObject: [NSArray arrayWithArray:point]];
			
			// Down-Left
			[point removeAllObjects];
			[point addObject:[NSNumber numberWithInt:(fromX-2)]];
			[point addObject:[NSNumber numberWithInt:(fromY+2)]];
			if ([self isValidMoveFromX:fromX andY:fromY toX:(fromX-2) andY:(fromY+2)])
				[possibleMoves addObject: [NSArray arrayWithArray:point]];
						
			// Down-Right
			[point removeAllObjects];
			[point addObject:[NSNumber numberWithInt:(fromX+2)]];
			[point addObject:[NSNumber numberWithInt:(fromY+2)]];
			if ([self isValidMoveFromX:fromX andY:fromY toX:(fromX+2) andY:(fromY+2)])
				[possibleMoves addObject: [NSArray arrayWithArray:point]];
		}
	}
	
	// ToDo: How to release point?
	return possibleMoves;
}

// Returns the number of pegs currently on the board
- (int) getNumberOfPegs {
	
	int count = 0;
	
	for (int i = 0 ; i < [self.board count] ; i++)
		if ([self getValueAtIndex:i] == [Peg intValue])
			count++;
	
	return count;
}

// Returns the number of undos that the user can still perform. This value will depend on the difficulty level
- (int) getNumberOfUndosLeft {

	int undosLeft;
	if (self.difficulty == Easy)
		undosLeft = EasyUndoLimit - self.undoCount;
	
	if (self.difficulty == Medium)
		undosLeft = MediumUndoLimit - self.undoCount;
	
	if (self.difficulty == Hard)
		undosLeft = HardUndoLimit - self.undoCount;
	
	return undosLeft;
}

- (void) onTimer {

	self.elapsedSeconds++;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"GameTimeElapsed" object:self userInfo:nil];
}

- (void) stopTimer {
	
	[self.timer invalidate];
}

- (void) dealloc {

	[self.board removeAllObjects];
	[self.board autorelease];
	
	[self.boardImagePath autorelease];
	
	[self.moves removeAllObjects];
	[self.moves autorelease];
	
	[self.timer autorelease];
	 
	[super dealloc];
}

- (void) loadState {
	
	PegSettings *settings = [PegSettings sharedSettings];
	
	// Load settings from NSUserDefaults
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSDictionary *stateDict = (NSDictionary *) [prefs objectForKey:@"PegBoardKey"];
	
	// There is a saved board
	if (stateDict) {

		[self.board removeAllObjects];
		[self.moves removeAllObjects];
		
		// Default values
		self.board = [NSMutableArray arrayWithCapacity:0];
		self.moves = [NSMutableArray arrayWithCapacity:0];
		self.boardImagePath = @"PegEnglish.png";
		self.gameType = English;
		self.difficulty = Easy;
		self.movesType = HVMove;
		self.undoCount = EasyUndoLimit;
		self.width = 7;
		self.height = 7;
		self.elapsedSeconds = 0;

		id value = nil;
		
		value = [stateDict objectForKey:@"PegBoardBoardKey"];
		if (value)
			self.board = [NSMutableArray arrayWithArray:value];
		
		value = [stateDict objectForKey:@"PegBoardMovesKey"];
		if (value)
			self.moves = [NSMutableArray arrayWithArray:value];
		
		value = [stateDict objectForKey:@"PegBoardImagePathKey"];
		if (value)
			self.boardImagePath = value;
		
		value = [stateDict objectForKey:@"PegBoardGameTypeKey"];
		if (value)
			self.gameType = [value intValue];
		
		value = [stateDict objectForKey:@"PegBoardDifficultyKey"];
		if (value)
			self.difficulty = [value intValue];
		
		value = [stateDict objectForKey:@"PegBoardMovesTypeKey"];
		if (value)
			self.movesType = [value intValue];

		value = [stateDict objectForKey:@"PegBoardUndoCountKey"];
		if (value)
			self.undoCount = [value intValue];

		value = [stateDict objectForKey:@"PegBoardWidthKey"];
		if (value)
			self.width = [value intValue];

		value = [stateDict objectForKey:@"PegBoardHeightKey"];
		if (value)
			self.height = [value intValue];

		value = [stateDict objectForKey:@"PegBoardElapsedSecondsKey"];
		if (value)
			self.elapsedSeconds = [value intValue];
	
		// Discard state so that when restarting the game we don't load the previous state again
		[prefs removeObjectForKey:@"PegBoardKey"];
		
	} else {
	
		NSString * path = [[NSBundle mainBundle] pathForResource:[settings boardResource] ofType:@"txt"]; 
		NSString *info = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

		[self setBoard:[NSMutableArray arrayWithCapacity:0]];
		[self setMoves:[NSMutableArray arrayWithCapacity:0]];
		
		[self setDifficulty:settings.difficulty];
		[self setGameType:settings.gameType];
		[self parseSettings:[info componentsSeparatedByString:@"\n"]];
	}
}

- (void) saveState {
	
	// Load NSUserDefaults
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// Save settings
	[prefs setObject:[self getStateDictionary] forKey:@"PegBoardKey"];
}

- (NSDictionary *) getStateDictionary {
	
	NSMutableDictionary *stateDict = [NSMutableDictionary dictionaryWithCapacity:0];

	[stateDict setValue:[NSArray arrayWithArray:self.board] forKey:@"PegBoardBoardKey"];
	[stateDict setValue:[NSArray arrayWithArray:self.moves] forKey:@"PegBoardMovesKey"];
	[stateDict setValue:boardImagePath forKey:@"PegBoardImagePathKey"];
	[stateDict setValue:[NSNumber numberWithInt:self.gameType] forKey:@"PegBoardGameTypeKey"];
	[stateDict setValue:[NSNumber numberWithInt:self.difficulty] forKey:@"PegBoardDifficultyKey"];
	[stateDict setValue:[NSNumber numberWithInt:self.movesType] forKey:@"PegBoardMovesTypeKey"];
	[stateDict setValue:[NSNumber numberWithInt:self.undoCount] forKey:@"PegBoardUndoCountKey"];
	[stateDict setValue:[NSNumber numberWithInt:self.width] forKey:@"PegBoardWidthKey"];
	[stateDict setValue:[NSNumber numberWithInt:self.height] forKey:@"PegBoardHeightKey"];
	[stateDict setValue:[NSNumber numberWithInt:self.elapsedSeconds] forKey:@"PegBoardElapsedSecondsKey"];
	
	return [NSDictionary dictionaryWithDictionary:stateDict];
}

@end




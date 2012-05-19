//
//  HighScoreManager.m
//  PegSolitaire
//
//  Created by Bruno Goncalves on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HighScoreManager.h"
#import "PegSettings.h"
#import "Score.h";

@interface HighScoreManager (Private)

- (void) registerSaveStateNotification;
- (void) onSaveState:(NSNotification *) notification;

@end

// ---------------
// Private methods
// ---------------

@implementation HighScoreManager (Private)

- (void) registerSaveStateNotification {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSaveState:) name:@"SaveState" object:nil];
}

- (void) onSaveState:(NSNotification *) notification {
	
	[self saveState];
}

@end

// -----------------------
// Public instace methods
// -----------------------

@implementation HighScoreManager

@synthesize highScoresDict;

static HighScoreManager *sharedHighScoreManager = nil;

+ (HighScoreManager *) sharedManager {
	
    @synchronized(self) {
		
        if (sharedHighScoreManager == nil) {
			
            [[self alloc] init];
        }
    }
	
    return sharedHighScoreManager;	
}

+ (id) allocWithZone:(NSZone *) zone {
	
    @synchronized(self) {
		
        if (sharedHighScoreManager == nil) {
			
            sharedHighScoreManager = [super allocWithZone:zone];
			[sharedHighScoreManager registerSaveStateNotification];
			[sharedHighScoreManager loadState];
            return sharedHighScoreManager;
        }
    }
	
    return nil;	
}

- (id) copyWithZone:(NSZone *) zone {
	
    return self;
}

- (id) retain {
	
    return self;
}

- (unsigned) retainCount {
	
    return UINT_MAX;
}

- (void) release {}

- (id) autorelease {
	
    return self;
}

- (void) loadState {
	
	// Load settings from NSUserDefaults
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSDictionary *savedHighScores = (NSDictionary *) [prefs objectForKey:@"HighScoresKey"];
	
	self.highScoresDict = [NSMutableDictionary dictionaryWithCapacity:0];

	if (savedHighScores) {
		
		NSArray *keys = [savedHighScores allKeys];
		
		for (int i = 0 ; i < [keys count] ; i++) {
		
			int gameType = [[keys objectAtIndex:i] intValue];
			NSArray *boardStateScores = [savedHighScores objectForKey:[keys objectAtIndex:i]];
			
			for (int j = 0 ; j < [boardStateScores count] ; j++) {
			
				Score *score = [[Score alloc] initFromStateDictionary:[boardStateScores objectAtIndex:j]];
				[self insertHighScore:score forGameType:gameType];
			}
		}
	}
}

- (void) saveState {

	// Load NSUserDefaults
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// Save settings
	[prefs setObject:[self getStateDictionary] forKey:@"HighScoresKey"];
}

- (NSDictionary *) getStateDictionary {

	// ToDo: Refactor
	
	PegSettings *settings = [PegSettings sharedSettings];
	NSArray *boardNames = [settings getBoardNames];
	
	NSMutableDictionary *stateDict = [NSMutableDictionary dictionaryWithCapacity:0];
	
	for (int i = 0 ; i < [boardNames count] ; i++) {
	
		NSMutableArray *boardStateScores = [NSMutableArray arrayWithCapacity:0];
		NSMutableArray *highScores = [self getHighScoresForGameType:i];
		
		for (int j = 0 ; j < [highScores count] ; j++)  {
		
			NSDictionary *scoreStateDict = [[highScores objectAtIndex:j] getStateDictionary];
			[boardStateScores addObject:scoreStateDict];
		}
		
		NSString *gameKey = [NSString stringWithFormat:@"%i", i];
		[stateDict setValue:[NSArray arrayWithArray:boardStateScores] forKey:gameKey];
	}
	
	return [NSDictionary dictionaryWithDictionary:stateDict];
}

- (BOOL) isHighScore: (Score *) score forGameType:(int) gameType {

	NSMutableArray *highScores = [self getHighScoresForGameType:gameType];
	
	// If we haven't reached the top kMaxNumberOfHighScores, then any score is a highScore
	if ([highScores count] < kMaxNumberOfHighScores)
		return YES;

	for (int i = 0 ; i < [highScores count] ; i++) {
	
		Score *tmpScore = (Score *) [highScores objectAtIndex:i];

		if ([score compareScore:tmpScore] == NSOrderedAscending)
			return YES;
	}
	
	return NO;
}

- (void) insertHighScore:(Score *) score forGameType:(int) gameType {
	
	NSMutableArray *highScores = [self getHighScoresForGameType:gameType];
	
	if ([self isHighScore:score forGameType:gameType]) {
	
		// Insert
		[highScores addObject:score];
		
		// Sort
		[highScores sortUsingSelector:@selector(compareScore:)];
		
		// Trim high scores to top kMaxNumberOfHighScores
		if ([highScores count] > kMaxNumberOfHighScores) {
		
			NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
			for (int i = (kMaxNumberOfHighScores+1) ; i < [highScores count] ; i++)
				[indexes addIndex:i];

			[highScores removeObjectsAtIndexes:indexes];
		}
	}
}

- (NSMutableArray *) getHighScoresForGameType:(int) gameType {
	
	NSString *gameKey = [NSString stringWithFormat:@"%i", gameType];
	
	// A high score array for the specified game type doesn't yet exist. Lets create it then!
	if (![self.highScoresDict objectForKey:gameKey])
		[self.highScoresDict setValue:[NSMutableArray arrayWithCapacity:0] forKey:gameKey];

	return [self.highScoresDict objectForKey:gameKey];
}

@end

//
//  HighScoreManager.h
//  PegSolitaire
//
//  Created by Bruno Goncalves on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMaxNumberOfHighScores 5

@class Score;

@interface HighScoreManager : NSObject {
	
	NSMutableDictionary *highScoresDict;
}

@property (nonatomic, retain) NSMutableDictionary *highScoresDict;

+ (HighScoreManager *) sharedManager;
- (BOOL) isHighScore:(Score *) score forGameType:(int) gameType;
- (void) insertHighScore:(Score *) score forGameType:(int) gameType;
- (void) loadState;
- (void) saveState;
- (NSDictionary *) getStateDictionary;
- (NSMutableArray *) getHighScoresForGameType:(int) gameType;

@end

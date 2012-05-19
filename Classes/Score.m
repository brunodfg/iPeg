//
//  Score.m
//  PegSolitaire
//
//  Created by Bruno Goncalves on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Score.h"
#import "PegSettings.h"

@implementation Score

@synthesize pegsLeft;
@synthesize timeElapsed;
@synthesize difficultyLevel;
@synthesize name;

- (Score *) initFromStateDictionary:(NSDictionary *) stateDict {

	self = [super init];
	
	if (self) {

		// Default values
		self.name = @"Developer";
		self.pegsLeft = 5;
		self.timeElapsed = 500;
		self.difficultyLevel = Easy;
		
		id value = nil;
		
		value = [stateDict objectForKey:@"ScoreName"];
		if (value)
			self.name = [NSString stringWithString:value];
		
		value = [stateDict objectForKey:@"ScorePegsLeft"];
		if (value)
			self.pegsLeft = [value intValue];
		
		value = [stateDict objectForKey:@"ScoreTimeElapsed"];
		if (value)
			self.timeElapsed = [value intValue];

		value = [stateDict objectForKey:@"ScoreDifficultyLevel"];
		if (value)
			self.difficultyLevel = [value intValue];
	}
	
	return self;
}

- (NSComparisonResult) compareScore:(Score *) otherScore {
	
	// self is higher
	if (self.pegsLeft < otherScore.pegsLeft)
		return NSOrderedAscending;
	
	// self is lower
	if (self.pegsLeft > otherScore.pegsLeft)
		return NSOrderedDescending;
	
	// self is higher
	if (self.timeElapsed < otherScore.timeElapsed)
		return NSOrderedAscending;
	
	// self is lower
	if (self.timeElapsed > otherScore.timeElapsed)
		return NSOrderedDescending;
	
    return NSOrderedSame;
}

- (NSString *) toString {

	int minutesElapsed = abs(timeElapsed / 60);
	int secondsElapsed = abs(timeElapsed % 60);

	// ToDo: Plural and singular
	if (pegsLeft > 1)
		return [NSString stringWithFormat:@"%@: %i Pegs in %02d:%02d", name, pegsLeft, minutesElapsed, secondsElapsed];
	else
		return [NSString stringWithFormat:@"%@: %i Peg in %02d:%02d", name, pegsLeft, minutesElapsed, secondsElapsed];
}

- (NSDictionary *) getStateDictionary {

	NSMutableDictionary *stateDict = [NSMutableDictionary dictionaryWithCapacity:0];
	
	[stateDict setObject:name forKey:@"ScoreName"];
	[stateDict setObject:[NSNumber numberWithInt:pegsLeft] forKey:@"ScorePegsLeft"];
	[stateDict setObject:[NSNumber numberWithInt:timeElapsed] forKey:@"ScoreTimeElapsed"];
	[stateDict setObject:[NSNumber numberWithInt:difficultyLevel] forKey:@"ScoreDifficultyLevel"];
	
	return [NSDictionary dictionaryWithDictionary:stateDict];
}

@end

//
//  Score.h
//  PegSolitaire
//
//  Created by Bruno Goncalves on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Score : NSObject {
	int pegsLeft;
	int timeElapsed;
	int difficultyLevel;
	NSString *name;
}

@property int pegsLeft;
@property int timeElapsed;
@property int difficultyLevel;
@property (nonatomic, retain) NSString *name;

- (Score *) initFromStateDictionary:(NSDictionary *) stateDict;
- (NSComparisonResult) compareScore:(Score *) otherScore;
- (NSString *) toString;
- (NSDictionary *) getStateDictionary;

@end

//
//  PegSettings.h
//  PegSolitaire
//
//  Created by Bruno Goncalves on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define European 0
#define English 1
#define SixBySix 2
#define Cross 3
#define Fireplace 4
#define Pyramid 5

#define Easy 1
#define Medium 2
#define Hard 3

#define EasyUndoLimit -1 // Unlimited
#define MediumUndoLimit 3
#define HardUndoLimit 0

@interface PegSettings : NSObject {
	int difficulty;
	int gameType;
	NSString *lastNameInserted;
}

@property int difficulty;
@property int gameType;
@property (nonatomic, retain) NSString *lastNameInserted;

+ (PegSettings*) sharedSettings;
- (NSString *) boardResource;
- (NSMutableArray *) getBoardNames;
- (void) loadState;
- (void) saveState;
- (NSDictionary *) getStateDictionary;

@end

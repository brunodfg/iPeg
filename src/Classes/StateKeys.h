//
//  StateKeys.h
//  PegSolitaire
//
//  Created by Bruno Goncalves on 2/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateKeys : NSObject {

	NSString * const SettingsKey;
	NSString * const GameTypeSettingsKey;
	NSString * const DifficultySettingsKey;
}

@property (readonly) SettingsKey;
@property (readonly) GameTypeSettingsKey;
@property (readonly) DifficultySettingsKey;

+ (StateKeys*) sharedKeys;

@end

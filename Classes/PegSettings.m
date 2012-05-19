//
//  PegSettings.m
//  PegSolitaire
//
//  Created by Bruno Goncalves on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PegSettings.h"

@interface PegSettings (Private)

- (void) registerSaveStateNotification;
- (void) onSaveState:(NSNotification *) notification;

@end

// ---------------
// Private methods
// ---------------

@implementation PegSettings (Private)

- (void) registerSaveStateNotification {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSaveState:) name:@"SaveState" object:nil];
}

- (void) onSaveState:(NSNotification *) notification {
	
	[self saveState];
}

@end

// -----------------------
// Public insntace methods
// -----------------------


@implementation PegSettings

@synthesize difficulty;
@synthesize gameType;
@synthesize lastNameInserted;

static PegSettings* sharedPegSettings = nil;

+ (PegSettings*) sharedSettings {
	
    @synchronized(self) {
		
        if (sharedPegSettings == nil) {
			
            [[self alloc] init];
        }
    }
	
    return sharedPegSettings;	
}

+ (id) allocWithZone:(NSZone *) zone {
	
    @synchronized(self) {
		
        if (sharedPegSettings == nil) {

			// Default settings
            sharedPegSettings = [super allocWithZone:zone];
			[sharedPegSettings registerSaveStateNotification];
			[sharedPegSettings loadState];
            return sharedPegSettings;
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
	NSDictionary *savedSettings = (NSDictionary *) [prefs objectForKey:@"PegSettingsKey"];

	// Default values
	self.gameType = English;
	self.difficulty = Easy;
	self.lastNameInserted = [NSString stringWithFormat:@"insert your name here"];
	
	// First time it is being loaded
	if (!savedSettings) {

		[self saveState];
	
	} else {

		id value = nil;
		
		value = [savedSettings objectForKey:@"GameTypeSettingsKey"];
		if (value)
			self.gameType = [value intValue];

		value = [savedSettings objectForKey:@"DifficultySettingsKey"];
		if (value)
			self.difficulty = [value intValue];
		
		value = [savedSettings objectForKey:@"LastNameInsertedSettingsKey"];
		if (value)
			self.lastNameInserted = [NSString stringWithString:value];
	}
}

- (void) saveState {
	
	// Load NSUserDefaults
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// Save settings
	[prefs setObject:[self getStateDictionary] forKey:@"PegSettingsKey"];
}

- (NSDictionary *) getStateDictionary {

	NSMutableDictionary *stateDict = [NSMutableDictionary dictionaryWithCapacity:0];
	
	[stateDict setValue:[NSNumber numberWithInt:self.gameType] forKey:@"GameTypeSettingsKey"];
	[stateDict setValue:[NSNumber numberWithInt:self.difficulty] forKey:@"DifficultySettingsKey"];
	[stateDict setValue:self.lastNameInserted forKey:@"LastNameInsertedSettingsKey"];
	
	return [NSDictionary dictionaryWithDictionary:stateDict];
}

- (NSString *) boardResource {
	
	if (self.gameType == European)
		return @"European";
	
	if (self.gameType == English)
		return @"English";
	
	if (self.gameType == SixBySix)
		return @"6x6";
	
	if (self.gameType == Cross)
		return @"Cross";
	
	if (self.gameType == Fireplace)
		return @"Fireplace";
	
	if (self.gameType == Pyramid)
		return @"Pyramid";
	
	return nil;
}

- (NSMutableArray *) getBoardNames {

	NSMutableArray *boardNames = [NSMutableArray arrayWithCapacity:0];
	
	[boardNames addObject:@"European"];
	[boardNames addObject:@"English"];
	[boardNames addObject:@"6x6"];
	[boardNames addObject:@"Cross"];
	[boardNames addObject:@"Fireplace"];
	[boardNames addObject:@"Pyramid"];
	
	return boardNames;
}

@end

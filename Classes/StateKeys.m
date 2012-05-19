//
//  StateKeys.m
//  PegSolitaire
//
//  Created by Bruno Goncalves on 2/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StateKeys.h"

@implementation StateKeys

@synthesize PegSettings;
@synthesize GameTypeSettingsKey;
@synthesize DifficultySettingsKey;

static StateKeys* sharedStateKeys = nil;

+ (StateKeys*) sharedKeys {
	
    @synchronized(self) {
		
        if (sharedStateKeys == nil) {
			
            [[self alloc] init];
        }
    }
	
    return sharedStateKeys;	
}

+ (id) allocWithZone:(NSZone *) zone {
	
    @synchronized(self) {
		
        if (sharedStateKeys == nil) {
			
			// Default settings
            sharedStateKeys = [super allocWithZone:zone];
            return sharedStateKeys;
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

@end

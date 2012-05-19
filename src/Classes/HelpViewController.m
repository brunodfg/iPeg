//
//  HelpViewController.m
//  PegSolitaire
//
//  Created by Bruno Gonçalves on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"


@implementation HelpViewController

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
		self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
	
    return self;
}

- (void) didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
	
    [super dealloc];
}

@end

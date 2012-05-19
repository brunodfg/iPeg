//
//  AboutViewController.m
//  PegSolitaire
//
//  Created by Bruno Gonçalves on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

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

- (void) onSendEmail {

	NSString *url = [NSString stringWithString: @"mailto://support.ipeg@gmail.com?subject=iPeg%20user%20feedback"];
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

- (void) onOpenWebSite {
	
	NSString *url = [NSString stringWithString: @"http://ibruno.pt.to"];
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

@end

//
//  BoardTypeTableView.m
//  PegSolitaire
//
//  Created by Bruno Goncalves on 2/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BoardTypeTableView.h"


@implementation BoardTypeTableView

- (void) deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {

	return;
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {

	[super scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

@end

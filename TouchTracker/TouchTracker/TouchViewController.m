//
//  TouchViewController.m
//  TouchTracker
//
//  Created by Paul Yoder on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TouchViewController.h"
#import "TouchDrawView.h"

@implementation TouchViewController

- (void)loadView
{
  [self setView:[[TouchDrawView alloc] initWithFrame:CGRectZero]];
}

@end

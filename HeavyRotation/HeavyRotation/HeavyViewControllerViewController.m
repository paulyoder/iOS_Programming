//
//  HeavyViewControllerViewController.m
//  HeavyRotation
//
//  Created by Paul Yoder on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HeavyViewControllerViewController.h"

@interface HeavyViewControllerViewController ()

@end

@implementation HeavyViewControllerViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)x
{
  return (x == UIInterfaceOrientationPortrait) || UIInterfaceOrientationIsLandscape(x);
}

@end

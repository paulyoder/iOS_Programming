//
//  HypnosisViewController.m
//  HypnoTime
//
//  Created by Paul Yoder on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"

@implementation HypnosisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  
{
  self = [super self];
  if (self) {
    UITabBarItem *tabBar = [self tabBarItem];
    [tabBar setTitle:@"Hypnosis"];
    [tabBar setImage:[UIImage imageNamed:@"Hypno.png"]];
  }
  return self;
}

- (void)loadView
{
  // Create a view
  CGRect frame = [[UIScreen mainScreen] bounds];
  HypnosisView *v = [[HypnosisView alloc] initWithFrame:frame];
  
  [self setView:v];
}

@end

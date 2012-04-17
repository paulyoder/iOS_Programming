//
//  TimeViewController.m
//  HypnoTime
//
//  Created by Paul Yoder on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeViewController.h"

@implementation TimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  
{
  self = [super self];
  if (self) {
    UITabBarItem *tabBar = [self tabBarItem];
    [tabBar setTitle:@"Time"];
    [tabBar setImage:[UIImage imageNamed:@"Time.png"]];
  }
  return self;
}

- (IBAction)showCurrentTime:(id)sender
{
  NSDate *now = [NSDate date];
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setTimeStyle:NSDateFormatterMediumStyle];
  
  [timeLabel setText:[formatter stringFromDate:now]];
}

@end

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
  NSBundle *appBundle = [NSBundle mainBundle];
  self = [super initWithNibName:@"TimeViewController" bundle:appBundle];
  
  if (self) {
    UITabBarItem *tabBar = [self tabBarItem];
    [tabBar setTitle:@"Time"];
    [tabBar setImage:[UIImage imageNamed:@"Time.png"]];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSLog(@"TimeViewController loaded its view");
  
  [[self view] setBackgroundColor:[UIColor greenColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
  NSLog(@"CurrentTimeViewController will appear");
  [super viewWillAppear:animated];
  [self showCurrentTime:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
  NSLog(@"CurrentTimeViewController will disappear");
  [super viewWillDisappear:animated];
}

- (IBAction)showCurrentTime:(id)sender
{
  NSDate *now = [NSDate date];
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setTimeStyle:NSDateFormatterMediumStyle];
  
  [timeLabel setText:[formatter stringFromDate:now]];
}

@end

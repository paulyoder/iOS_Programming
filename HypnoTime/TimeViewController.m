//
//  TimeViewController.m
//  HypnoTime
//
//  Created by Paul Yoder on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeViewController.h"
#import <QuartzCore/QuartzCore.h>

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
  
  [self bounceTimeLabel];
}

- (void)spinTimeLabel
{
  // Create a basic animation
  CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
  
  // fromValue is implied
  [spin setToValue:[NSNumber numberWithFloat:M_PI * 2.0]];
  [spin setDuration:1.0];
  [spin setDelegate:self];
  
  // Set the timing function
  CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [spin setTimingFunction:tf];
  
  // Kick off the animation by adding it to the layer
  [timeLabel.layer addAnimation:spin forKey:@"spinAnimation"];
}

- (void)bounceTimeLabel
{
  // Create a key frame animation
  CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
  
  // Create the values it will pass through
  CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
  CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
  CATransform3D forward2 = CATransform3DMakeScale(1.2, 1.2, 1);
  CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
  
  [bounce setValues:[NSArray arrayWithObjects:
                     [NSValue valueWithCATransform3D:CATransform3DIdentity],
                     [NSValue valueWithCATransform3D:forward],
                     [NSValue valueWithCATransform3D:back],
                     [NSValue valueWithCATransform3D:forward2],
                     [NSValue valueWithCATransform3D:back2],
                     [NSValue valueWithCATransform3D:CATransform3DIdentity],
                     nil]];
  
  // Set the duration
  [bounce setDuration:0.6];
  
  // Animate the layer
  [timeLabel.layer addAnimation:bounce forKey:@"bounceAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  NSLog(@"%@ finished: %d", anim, flag);
}

@end

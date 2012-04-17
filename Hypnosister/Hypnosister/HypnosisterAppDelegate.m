//
//  HypnosisterAppDelegate.m
//  Hypnosister
//
//  Created by Paul Yoder on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HypnosisterAppDelegate.h"
#import "HypnosisView.h"

@implementation HypnosisterAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
  // Override point for customization after application launch.
  
  CGRect screenRect = [[self window] bounds];
  
  // Create the UIScrollView to have the size of the window, matching its size
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
  [[self window] addSubview:scrollView];
  
  // Create the HypnosisView with a frame that is twice the size of the screen
  HypnosisView *view = [[HypnosisView alloc] initWithFrame:screenRect];
  [scrollView addSubview:view];
  CGRect rightRect = screenRect;
  rightRect.origin.x = screenRect.size.width;
  [scrollView addSubview:[[HypnosisView alloc] initWithFrame:rightRect]];
  
  CGRect scrollRect = screenRect;
  scrollRect.size.width *= 2.0;
  [scrollView setContentSize:scrollRect.size];
  [scrollView setPagingEnabled:YES];
  
  BOOL success = [view becomeFirstResponder];
  if (success) {
    NSLog(@"Hypnosis became the first responder");
  } else {
    NSLog(@"Could not become first responder");
  }
  
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

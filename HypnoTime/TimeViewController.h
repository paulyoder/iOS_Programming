//
//  TimeViewController.h
//  HypnoTime
//
//  Created by Paul Yoder on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeViewController : UIViewController
{
  __weak IBOutlet UILabel *timeLabel;
}

- (IBAction)showCurrentTime:(id)sender;

- (void)spinTimeLabel;
- (void)bounceTimeLabel;

@end

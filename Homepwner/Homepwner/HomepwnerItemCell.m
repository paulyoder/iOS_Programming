//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Paul Yoder on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell

@synthesize thumbnailView;
@synthesize nameLabel;
@synthesize serialNumberLabel;
@synthesize valueLabel;
@synthesize controller;
@synthesize tableView;

- (IBAction)showImage:(id)sender 
{
  // Get this name of this method, "showImage"
  NSString *selector = NSStringFromSelector(_cmd);
  // selector is now "showImage:atIndexPath:"
  selector = [selector stringByAppendingString:@"atIndexPath:"];
  // Prepare a selector from this string
  SEL newSelector = NSSelectorFromString(selector);
  
  NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
  if (indexPath && [controller respondsToSelector:newSelector]) {
      [[self controller] performSelector:newSelector 
                              withObject:sender 
                              withObject:indexPath];
  }
}
@end

//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Paul Yoder on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsViewController : UITableViewController <UIPopoverControllerDelegate>
{
  BOOL deviceIsIpad;
  UIPopoverController *imagePopover;
}

- (IBAction)addNewItem:(id)sender;

@end

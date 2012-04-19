//
//  DetailViewControllerViewController.h
//  Homepwner
//
//  Created by Paul Yoder on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRItem.h"

@interface DetailViewController : UIViewController
{
  __weak IBOutlet UITextField *nameField;
  __weak IBOutlet UITextField *serialField;
  __weak IBOutlet UITextField *valueField;
  __weak IBOutlet UILabel *dateLabel;
}

@property (nonatomic, strong) BNRItem *item;

@end

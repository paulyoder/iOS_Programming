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
  <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate,
   UIPopoverControllerDelegate>
{
  __weak IBOutlet UITextField *nameField;
  __weak IBOutlet UITextField *serialField;
  __weak IBOutlet UITextField *valueField;
  __weak IBOutlet UILabel *dateLabel;
  __weak IBOutlet UIImageView *imageView;
  
  UIPopoverController *imagePickerPopover;
  BOOL deviceIsIpad;
}

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (id)initForNewItem:(BOOL)isNew;
- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@end

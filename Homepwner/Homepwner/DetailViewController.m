//
//  DetailViewControllerViewController.m
//  Homepwner
//
//  Created by Paul Yoder on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"

@implementation DetailViewController

@synthesize item;

- (void)setItem:(BNRItem *)i
{
  item = i;
  [[self navigationItem] setTitle:[item itemName]];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [nameField setText:[item itemName]];
  [serialField setText:[item serialNumber]];
  [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
  
  // Create a NSDateFormatter that will turn a date into a simple date string
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  // Clear first responder
  [[self view] endEditing:YES];
  
  // "Save" changes to item
  [item setItemName:[nameField text]];
  [item setSerialNumber:[serialField text]];
  [item setValueInDollars:[[valueField text] intValue]];
}

- (void)viewDidUnload {
  nameField = nil;
  serialField = nil;
  valueField = nil;
  dateLabel = nil;
  [super viewDidUnload];
}

@end

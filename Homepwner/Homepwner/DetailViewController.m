//
//  DetailViewControllerViewController.m
//  Homepwner
//
//  Created by Paul Yoder on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

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
  
  NSString *imageKey = [item imageKey];
  
  if (imageKey) {
    UIImage *image = [[BNRImageStore sharedStore] imageForKey:imageKey];
    [imageView setImage:image];
  }
  else {
    [imageView setImage:nil];
  }
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
    imageView = nil;
  [super viewDidUnload];
}

- (IBAction)takePicture:(id)sender 
{
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  
  // If our device has a camera, we want to take a picture, otherwise, we just
  // pick from photo library
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
  else
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
  
  [imagePicker setDelegate:self];
  
  [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)backgroundTapped:(id)sender 
{
  [[self view] endEditing:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  NSString *oldKey = [item imageKey];
  if (oldKey) {
    [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
  }
  // Get picked image from info dictionary
  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  
  CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
  CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
  
  NSString *key = (__bridge NSString *)newUniqueIDString;
  [item setImageKey:key];
  
  [[BNRImageStore sharedStore] setImage:image forKey:key];
  
  CFRelease(newUniqueID);
  CFRelease(newUniqueIDString);
  
  // Put that image onto the screen in our image view
  [imageView setImage:image];
  
  // Take image picker off the screen -
  // you must cal this dismiss method
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

@end

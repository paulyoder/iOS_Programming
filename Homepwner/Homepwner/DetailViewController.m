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
#import "BNRItemStore.h"
#import "AssetTypePicker.h"

@implementation DetailViewController

@synthesize item, dismissBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  @throw [NSException exceptionWithName:@"Wrong Initializer" 
                                 reason:@"Use initForNewItem:" 
                               userInfo:nil];
  return nil;
}

- (id)initForNewItem:(BOOL)isNew
{
  self = [super initWithNibName:@"DetailViewController" bundle:nil];
  
  if (self && isNew) {
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] 
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                      target:self 
                                                      action:@selector(save:)];
    [[self navigationItem] setRightBarButtonItem:doneItem];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] 
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                        target:self 
                                                        action:@selector(cancel:)];
    [[self navigationItem] setLeftBarButtonItem:cancelItem];    
  }
  deviceIsIpad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
  
  return self;
}

- (void)setItem:(BNRItem *)i
{
  item = i;
  [[self navigationItem] setTitle:[item itemName]];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIColor *color = nil;
  if (deviceIsIpad)
    color = [UIColor colorWithRed: 0.875 green:0.88 blue:0.91 alpha:1];
  else 
    color = [UIColor groupTableViewBackgroundColor];
  
  [[self view] setBackgroundColor:color];
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
  NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[item dateCreated]];
  [dateLabel setText:[dateFormatter stringFromDate:date]];
  
  NSString *imageKey = [item imageKey];
  
  if (imageKey) {
    UIImage *image = [[BNRImageStore sharedStore] imageForKey:imageKey];
    [imageView setImage:image];
  }
  else {
    [imageView setImage:nil];
  }
  
  NSString *typeLabel = [[item assetType] valueForKey:@"label"];
  if (!typeLabel)
    typeLabel = @"None";
  
  [assetTypeButton setTitle:[NSString stringWithFormat:@"Type: %@", typeLabel] 
                   forState:UIControlStateNormal];
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
  assetTypeButton = nil;
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    return YES;
  else
    return (io == UIInterfaceOrientationPortrait);
}

- (IBAction)takePicture:(id)sender 
{
  if ([imagePickerPopover isPopoverVisible]) {
    [imagePickerPopover dismissPopoverAnimated:YES];
    imagePickerPopover = nil;
    return;
  }
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  
  // If our device has a camera, we want to take a picture, otherwise, we just
  // pick from photo library
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
  else
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
  
  [imagePicker setDelegate:self];
  
  // Place image picker on the screen
  // Check for iPad device before instantiating the popover controller
  if (deviceIsIpad) {
    // Create a new popover controller that will display the imagePicker
    imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    
    [imagePickerPopover setDelegate:self];
    
    // Display the popover controller; sender
    // is the camera bar button item
    [imagePickerPopover presentPopoverFromBarButtonItem:sender 
                               permittedArrowDirections:UIPopoverArrowDirectionAny 
                                               animated:YES];
  } else {
    [self presentViewController:imagePicker animated:YES completion:nil];
  }
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
  
  [item setThumbnailDataFromImage:image];
  
  CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
  CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
  
  NSString *key = (__bridge NSString *)newUniqueIDString;
  [item setImageKey:key];
  
  [[BNRImageStore sharedStore] setImage:image forKey:key];
  
  CFRelease(newUniqueID);
  CFRelease(newUniqueIDString);
  
  // Put that image onto the screen in our image view
  [imageView setImage:image];
  
  if (deviceIsIpad) {
    [imagePickerPopover dismissPopoverAnimated:YES];
    imagePickerPopover = nil;
  } else {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
  NSLog(@"User dismissed popover");
  imagePickerPopover = nil;
}

- (void)save:(id)sender
{
  [[self presentingViewController] dismissViewControllerAnimated:YES 
                                                      completion:dismissBlock];
}

- (void)cancel:(id)sender
{
  [[BNRItemStore sharedStore] removeItem:item];
  [[self presentingViewController] dismissViewControllerAnimated:YES 
                                                      completion:dismissBlock];
}

- (void)assetTypeButtonTapped:(id)sender
{
  [[self view] endEditing:YES];
  
  AssetTypePicker *picker = [[AssetTypePicker alloc] init];
  [picker setItem:item];
  
  [[self navigationController] pushViewController:picker animated:YES];
}

@end

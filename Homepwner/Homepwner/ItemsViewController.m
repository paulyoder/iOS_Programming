//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Paul Yoder on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "DetailViewController.h"
#import "HomepwnerItemCell.h"
#import "BNRImageStore.h"
#import "imageViewController.h"

@implementation ItemsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
      [[self navigationItem] setTitle:@"Homepwner"];
      
      // Create a new bar button item that will send
      // addNewItem: to ItemsViewController
      UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                                           target:self 
                                                                           action:@selector(addNewItem:)];
      
      [[self navigationItem] setRightBarButtonItem:bbi];
      [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
      
      deviceIsIpad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    }
    return self;
}

- (id)init
{
  return [self initWithStyle:UITableViewStyleGrouped];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)oi
{
  if (deviceIsIpad)
    return YES;
  else
    return (oi == UIInterfaceOrientationPortrait);
}

- (IBAction)toggleEditingMode:(id)sender
{
  // If we are currently in editing mode...
  if ([self isEditing]) {
    // Change text of button to inform user of state
    [sender setTitle:@"Edit" forState:UIControlStateNormal];
    // Turn off editing mode
    [self setEditing:NO animated:YES];
  } else {
    // Change text of button to inform user of state
    [sender setTitle:@"Done" forState:UIControlStateNormal];
    // Enter editing mode
    [self setEditing:YES animated:YES];
  }
}

- (IBAction)addNewItem:(id)sender
{
  BNRItem *item = [[BNRItemStore sharedStore] createItem];
  
  DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
  [detailViewController setItem: item];
  [detailViewController setDismissBlock:^{
    [[self tableView] reloadData];
  }];
  
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
  [navController setModalPresentationStyle:UIModalPresentationFormSheet];
  [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
  
  [self presentViewController:navController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [[self tableView] reloadData];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Load the NIB which contains the cell
  UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
  
  // Register this NIB which contains the cell
  [[self tableView] registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
}

- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)ip
{
  NSLog(@"Going to show the image for %@", ip);
  
  if (deviceIsIpad) {
    // Get the item for the index path
    BNRItem *item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:ip.row];
    NSString *imageKey = [item imageKey];
    
    // If there is no image, we don't need to display anything
    UIImage *image = [[BNRImageStore sharedStore] imageForKey:imageKey];
    if (!image)
      return;
    
    // Make a rectangle that the frame of the button relative to our table view
    CGRect rect = [[self view] convertRect:[sender bounds] fromView:sender];
    
    // Create a new ImageViewController and set its image
    ImageViewController *ivc = [[ImageViewController alloc] init];
    [ivc setImage:image];
    
    // Present a 600x600 popover from the rect
    imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
    [imagePopover setDelegate:self];
    [imagePopover setPopoverContentSize:CGSizeMake(600, 600)];
    [imagePopover presentPopoverFromRect:rect 
                                  inView:[self view] 
                permittedArrowDirections:UIPopoverArrowDirectionAny 
                                animated:YES];
  }
}

#pragma mark popover Delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
  [imagePopover dismissPopoverAnimated:YES];
  imagePopover = nil;
}

#pragma mark tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
  return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  BNRItem *item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
  
  HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
  [cell setController:self];
  [cell setTableView:tableView];
  [[cell thumbnailView] setImage:[item thumbnail]];
  [[cell nameLabel] setText:[item itemName]];
  [[cell serialNumberLabel] setText:[item serialNumber]];
  [[cell valueLabel] setText:[NSString stringWithFormat:@"$%d", [item valueInDollars]]];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView 
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    BNRItem *item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    [[BNRItemStore sharedStore] removeItem:item];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewScrollPositionBottom];
  }
}

- (void)tableView:(UITableView *)tableView 
    moveRowAtIndexPath:(NSIndexPath *)fromIp 
           toIndexPath:(NSIndexPath *)toIp
{
  [[BNRItemStore sharedStore] moveItemAtIndex:fromIp.row toIndex:toIp.row];
}

- (void)tableView:(UITableView *)tableView 
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  DetailViewController *detailView = [[DetailViewController alloc] initForNewItem:NO];
  BNRItem *item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:indexPath.row];
  [detailView setItem:item];
  
  // Push it on top of the navigation controller's stack
  [[self navigationController] pushViewController:detailView animated:YES];
}

@end

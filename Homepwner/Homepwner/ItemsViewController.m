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

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
  return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  BNRItem *item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
  

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:@"UITableViewCell"];
  
  [[cell textLabel] setText:[item description]];
  return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    BNRItem *item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    [[BNRItemStore sharedStore] removeItem:item];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewScrollPositionBottom];
  }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIp toIndexPath:(NSIndexPath *)toIp
{
  [[BNRItemStore sharedStore] moveItemAtIndex:fromIp.row toIndex:toIp.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  DetailViewController *detailView = [[DetailViewController alloc] initForNewItem:NO];
  BNRItem *item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:indexPath.row];
  [detailView setItem:item];
  
  // Push it on top of the navigation controller's stack
  [[self navigationController] pushViewController:detailView animated:YES];
}

@end

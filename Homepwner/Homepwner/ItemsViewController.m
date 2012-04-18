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

@implementation ItemsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (id)init
{
  return [self initWithStyle:UITableViewStyleGrouped];
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
  
  // Make a new index path for the 0th section, last row
  int newRowIndex = [[[BNRItemStore sharedStore] allItems] indexOfObject:item];
  NSIndexPath *ip = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
  
  // Insert this new row into the table
  [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
}

- (UIView *)headerView
{
  // If we haven't loaded the headerView yet...
  if (!headerView) {
    // Load HeaderView.xib
    [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
  }
  return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  return [self headerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  // The height of the header view should be determined from the height of the
  // view in the XIB file
  return [[self headerView] bounds].size.height;
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

@end

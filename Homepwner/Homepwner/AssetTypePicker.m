//
//  AssetTypePicker.m
//  Homepwner
//
//  Created by Paul Yoder on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AssetTypePicker.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation AssetTypePicker

@synthesize item;

- (id)init
{
  return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[[BNRItemStore sharedStore] allAssetTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
  
  if (cell == nil)
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:@"UITableViewCell"];
  
  NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
  NSManagedObject *assetType = [allAssets objectAtIndex:[indexPath row]];
  
  // Use key-value coding to get the asset type's label
  NSString *assetLabel= [assetType valueForKey:@"label"];
  [[cell textLabel] setText:assetLabel];
  
  // Checkmark the one that is currently selected
  if (assetType == [item assetType])
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
  else 
    [cell setAccessoryType:UITableViewCellAccessoryNone];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
  
  NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
  NSManagedObject *assetType = [allAssets objectAtIndex:[indexPath row]];
  [item setAssetType:assetType];
  
  [[self navigationController] popViewControllerAnimated:YES];
}

@end

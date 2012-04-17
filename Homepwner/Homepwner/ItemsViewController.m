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
      for (int i = 0; i < 5; i++)
        [[BNRItemStore sharedStore] createItem];
    }
    return self;
}

- (id)init
{
  return [self initWithStyle:UITableViewStyleGrouped];
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



@end

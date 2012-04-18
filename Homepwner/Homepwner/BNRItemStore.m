//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Paul Yoder on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation BNRItemStore

- (id)init
{
  self = [super init];
  if (self)
    allItems = [[NSMutableArray alloc] init];
  return self;
}

+ (BNRItemStore *)sharedStore
{
  static BNRItemStore *sharedStore = nil;
  if (!sharedStore)
    sharedStore = [[super allocWithZone:nil] init];
  
  return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
  return [self sharedStore];
}

- (NSArray *)allItems
{
  return allItems;
}

- (BNRItem *)createItem
{
  BNRItem *item = [BNRItem randomItem];
  [allItems addObject:item];
  return item;
}

- (void)removeItem:(BNRItem *)item
{
  [allItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
  if (from == to) return;
  BNRItem *item = [allItems objectAtIndex:from];
  [allItems removeObjectAtIndex:from];
  [allItems insertObject:item atIndex:to];
}

@end

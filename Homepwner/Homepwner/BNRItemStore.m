//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Paul Yoder on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@implementation BNRItemStore

- (id)init
{
  self = [super init];
  if (self) {
    NSString *path = [self itemArchivePath];
    allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    // if the array hadn't been saved previously, create a new empty one
    if (!allItems)
      allItems = [[NSMutableArray alloc] init];
  }
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
  BNRItem *item = [[BNRItem alloc] init];
  [allItems addObject:item];
  return item;
}

- (void)removeItem:(BNRItem *)item
{
  [[BNRImageStore sharedStore] deleteImageForKey:[item imageKey]];
  [allItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
  if (from == to) return;
  BNRItem *item = [allItems objectAtIndex:from];
  [allItems removeObjectAtIndex:from];
  [allItems insertObject:item atIndex:to];
}

- (NSString *)itemArchivePath
{
  NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  
  // Get the one and only document directory from that list
  NSString *documentDirectory = [documentDirectories objectAtIndex:0];
  
  return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
  return [NSKeyedArchiver archiveRootObject:allItems toFile:[self itemArchivePath]]; 
}

@end

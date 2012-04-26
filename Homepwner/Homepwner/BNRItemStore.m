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
    // Read in Homepwner.xcdatamodeld
    model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // Where does the SQLite file go?
    NSString *path = [self itemArchivePath];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType 
                           configuration:nil 
                                     URL:storeURL 
                                 options:nil 
                                   error:&error])
      [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    
    // Create the managed object context
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:psc];
    
    // The managed object context can manage undo, but we don't need it
    [context setUndoManager:nil];
    
    [self loadAllItems];
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
  BNRItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" 
                                                inManagedObjectContext:context];
  
  double order;
  if ([allItems count ] == 0)
    order = 1.0;
  else 
    order = [[allItems lastObject] orderingValue] + 1.0;
  [item setOrderingValue:order];
  NSLog(@"Adding after %d items, order = %.2f", [allItems count], order);

  [allItems addObject:item];
  return item;
}

- (void)removeItem:(BNRItem *)item
{
  [[BNRImageStore sharedStore] deleteImageForKey:[item imageKey]];
  [context deleteObject:item];
  [allItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
  if (from == to) return;
  BNRItem *item = [allItems objectAtIndex:from];
  [allItems removeObjectAtIndex:from];
  [allItems insertObject:item atIndex:to];
  
  // Computing a new orderValue for the object that was moved
  double lowerBound = 0.0;
  
  // Is there an object before it?
  if (to > 0)
    lowerBound = [[allItems objectAtIndex:to - 1] orderingValue];
  else
    lowerBound = [[allItems objectAtIndex:1] orderingValue] + 2.0;
  
  double upperBound = 0.0;
  
  // Is there an object after it?
  if (to < [allItems count])
    upperBound = [[allItems objectAtIndex:to + 1] orderingValue];
  else 
    upperBound = [[allItems objectAtIndex:to - 1] orderingValue] + 2.0;
  
  double newOrderValue = (lowerBound + upperBound) / 2.0;
  
  NSLog(@"moving to order %f", newOrderValue);
  [item setOrderingValue:newOrderValue];
}

- (NSString *)itemArchivePath
{
  NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  
  // Get the one and only document directory from that list
  NSString *documentDirectory = [documentDirectories objectAtIndex:0];
  
  return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
  NSError *err = nil;
  BOOL success = [context save:&err];
  if (!success)
    NSLog(@"Error saving: %@", [err localizedDescription]);
  return success;
}

- (void)loadAllItems
{
  if (allItems)
    return;
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *ent = [[model entitiesByName] objectForKey:@"BNRItem"];
  [request setEntity:ent];
  
  NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
  [request setSortDescriptors:[NSArray arrayWithObject:sorter]];
  
  NSError *err;
  NSArray *result = [context executeFetchRequest:request error:&err];
  if (!result)
    [NSException raise:@"Fetch failed" format:@"Reason: %@", [err localizedDescription]];
  
  allItems = [[NSMutableArray alloc] initWithArray:result];
}

- (NSArray *)allAssetTypes
{
  if (allAssetTypes)
    return allAssetTypes;
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *ent = [[model entitiesByName] objectForKey:@"BNRAssetType"];
  [request setEntity:ent];
  
  NSError *err;
  NSArray *results = [context executeFetchRequest:request error:&err];
  if (!results)
    [NSException raise:@"Fetch failed" format:@"Reason: %@", [err localizedDescription]];
  allAssetTypes = [results mutableCopy];
  
  if ([allAssetTypes count] > 0)
    return allAssetTypes;
  
  // Seed asset types if none exist
  NSManagedObject *type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" 
                                                         inManagedObjectContext:context];
  [type setValue:@"Furniture" forKey:@"label"];
  [allAssetTypes addObject:type];
  
  type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" 
                                       inManagedObjectContext:context];
  [type setValue:@"Jewlry" forKey:@"label"];
  [allAssetTypes addObject:type];
  
  type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" 
                                       inManagedObjectContext:context];
  [type setValue:@"Electronics" forKey:@"label"];
  [allAssetTypes addObject:type];
  
  return allAssetTypes;
}

@end

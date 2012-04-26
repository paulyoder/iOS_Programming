//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Paul Yoder on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import <CoreData/CoreData.h>

@interface BNRItemStore : NSObject
{
  NSMutableArray *allItems;
  NSMutableArray *allAssetTypes;
  NSManagedObjectContext *context;
  NSManagedObjectModel *model;
}

+ (BNRItemStore *)sharedStore;

- (NSArray *)allItems;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)item;
- (void)moveItemAtIndex:(int)from toIndex:(int)to;
- (void)loadAllItems;

- (NSString *)itemArchivePath;
- (BOOL)saveChanges;

- (NSArray *)allAssetTypes;

@end

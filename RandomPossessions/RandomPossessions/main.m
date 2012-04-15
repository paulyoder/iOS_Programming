//
//  main.m
//  RandomPossessions
//
//  Created by Paul Yoder on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

int main(int argc, const char * argv[])
{

  @autoreleasepool {
        
    // Create a mutable array object, store its adrees in items variable
    NSMutableArray *items = [[NSMutableArray alloc] init];
        
    BNRItem *backpack = [[BNRItem alloc] init];
    [backpack setItemName:@"Backpack"];
    [items addObject: backpack];
    
    BNRItem *calculator = [[BNRItem alloc] init];
    [calculator setItemName:@"Calculator"];
    [items addObject:calculator];
    
    [backpack setContainedItem:calculator];
        
    // Destroy the array pointed to by items
    NSLog(@"Setting items to nil...");
    items = nil;
  }
  return 0;
}


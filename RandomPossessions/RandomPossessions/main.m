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
        
    for (int i = 0; i < 10; i++) {
      BNRItem *p = [BNRItem randomItem];
      [items addObject:p];
    }
    
    for (BNRItem *item in items) {
      NSLog(@"%@", item);
    }
        
    // Destroy the array pointed to by items
    items = nil;
  }
  return 0;
}


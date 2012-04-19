//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Paul Yoder on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

+ (id)allocWithZone:(NSZone *)zone
{
  return [self sharedStore];
}

+ (BNRImageStore *)sharedStore
{
  static BNRImageStore *sharedStore = nil;
  if (!sharedStore) {
    // Create the singleton
    sharedStore = [[super allocWithZone:NULL] init];
  }
  return sharedStore;
}

- (id)init
{
  self = [super init];
  if (self) {
    dictionary = [[NSMutableDictionary alloc] init];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self 
           selector:@selector(clearCache:) 
               name:UIApplicationDidReceiveMemoryWarningNotification 
             object:nil];
  }
  return self;
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
  [dictionary setObject:i forKey:s];
  
  // Turn imiage into JPEG data
  NSData *jpg = UIImageJPEGRepresentation(i, 0.5);
  
  // Write it to the full path
  [jpg writeToFile:[self imagePathForKey:s] atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)s
{
  // If possible, get it from the dictionary
  UIImage *result = [dictionary objectForKey:s];
  
  if (!result) {
    // Create UIImage object from file
    result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
    
    // If we found an image on the file system, place it into the cache
    if (result)
      [dictionary setValue:result forKey:s];
    else 
      NSLog(@"Error: unable to find %@", [self imagePathForKey:s]);
  }
  
  return result;
}

- (void)deleteImageForKey:(NSString *)s
{
  if (!s)
    return;
  
  [dictionary removeObjectForKey:s];
  [[NSFileManager defaultManager] removeItemAtPath:[self imagePathForKey:s] error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key
{
  NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentDirectory = [documentDirectories objectAtIndex:0];
  
  return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)clearCache:(NSNotification *)note
{
  NSLog(@"flushing %d images out of the cache", [dictionary count]);
  [dictionary removeAllObjects];
}

@end

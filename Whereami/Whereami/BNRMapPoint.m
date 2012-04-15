//
//  BNRMapPoint.m
//  Whereami
//
//  Created by Paul Yoder on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRMapPoint.h"

@implementation BNRMapPoint

@synthesize coordinate, title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
  self = [super init];
  if (self) {
    coordinate = c;
    title = t;
  }
  return self;
}

- (id)init
{
  return [self initWithCoordinate:CLLocationCoordinate2DMake(43.07, -89.32) 
                            title:@"Hometown"];
}

@end

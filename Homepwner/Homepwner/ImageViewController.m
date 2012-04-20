//
//  ImageViewController.m
//  Homepwner
//
//  Created by Paul Yoder on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageViewController.h"

@implementation ImageViewController

@synthesize image;

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  CGSize size = [[self image] size];
  [scrollView setContentSize:size];
  [imageView setFrame:CGRectMake(0, 0, size.width, size.height)];
  [imageView setImage:image];
}

@end

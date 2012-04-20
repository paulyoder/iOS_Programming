//
//  ImageViewController.h
//  Homepwner
//
//  Created by Paul Yoder on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
{
  __weak IBOutlet UIScrollView *scrollView;
  __weak IBOutlet UIImageView *imageView;
}

@property (nonatomic, strong) UIImage *image;

@end

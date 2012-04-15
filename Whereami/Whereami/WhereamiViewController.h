//
//  WhereamiViewController.h
//  Whereami
//
//  Created by Paul Yoder on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WhereamiViewController : UIViewController <CLLocationManagerDelegate>
{
  CLLocationManager *locationManager;
}

@end

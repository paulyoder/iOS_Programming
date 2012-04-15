//
//  WhereamiViewController.h
//  Whereami
//
//  Created by Paul Yoder on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface WhereamiViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITextInput>
{
  CLLocationManager *locationManager;
  
  IBOutlet MKMapView *worldView;
  IBOutlet UIActivityIndicatorView *activityIndicator;
  IBOutlet UITextField *locationTitleField;
}

- (void)findLocation;
- (void)foundLocation:(CLLocation *)location;

@end

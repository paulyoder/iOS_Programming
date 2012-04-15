//
//  WhereamiViewController.m
//  Whereami
//
//  Created by Paul Yoder on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WhereamiViewController.h"
#import "BNRMapPoint.h"

@implementation WhereamiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  
  if (self) {
    // Create location manager object
    locationManager = [[CLLocationManager alloc] init];
    
    // And we want it to be as accurate as possible
    // regardless of how much time/power it takes
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [locationManager setDelegate:self];
  }
  
  return self;
}


- (void)dealloc
{
  // Tell the location manager to stop sending us messages
  [locationManager setDelegate:nil];
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
  NSLog(@"%@", newLocation);
  
  // How many seconds ago was this new location created?
  NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
  
  // CLLocationManagers will return the last found location of the
  // device first, you don't want that data in this case.
  // If this location was made more than 3 mnutes ago, ignore it
  if (t < -180) {
    // This is cached data, you don't want it, keep looking
    return;
  }
  
  [self foundLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error
{
  NSLog(@"Could not find location: %@", error);
}

- (void)viewDidLoad
{
  [worldView setShowsUserLocation:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([userLocation coordinate], 250, 250);
  [mapView setRegion: region animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self findLocation];
  
  [textField resignFirstResponder];
  
  return YES;
}

- (void)findLocation
{
  [locationManager startUpdatingLocation];
  [activityIndicator startAnimating];
  [locationTitleField setHidden:YES];
}

- (void)foundLocation:(CLLocation *)location;
{
  CLLocationCoordinate2D coord = [location coordinate];
  
  // Create an instance of BNRMapPoint with the current data
  BNRMapPoint *mp = [[BNRMapPoint alloc] initWithCoordinate:coord title:[locationTitleField text]];
  
  // Add it to the map view
  [worldView addAnnotation:mp];
  
  // Zoom the region to this location
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
  [worldView setRegion:region animated:YES];
  
  // Reset the UI
  [locationTitleField setText:@""];
  [locationTitleField setHidden:NO];
  [activityIndicator stopAnimating];
  [locationManager stopUpdatingLocation];
}

@end

//
//  KCGeoLocation.m
//  Keychn
//
//  Created by Keychn Experience SL on 29/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCGeoLocation.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>


@interface KCGeoLocation () <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@property (nonatomic,copy) void(^finished)(BOOL status);

@end

@implementation KCGeoLocation

+ (instancetype)sharedInstance {
    
    static KCGeoLocation *geoLocation;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        geoLocation = [[KCGeoLocation alloc] init];
        
    });
    
    return geoLocation;
}

- (void)getUserLocationWithCompletionHandeler:(void(^)(BOOL status))finished {
    self.finished = finished;
    locationManager  = [[CLLocationManager alloc] init];
    locationManager.delegate            = self;
    locationManager.distanceFilter      = kCLDistanceFilterNone;
    locationManager.desiredAccuracy     = kCLLocationAccuracyBestForNavigation;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(DEBUGGING) NSLog(@"locationManager didFailWithError");
    self.finished(NO);
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied)
    {
        if(DEBUGGING) NSLog(@"location denied, handle accordingly");
        //location denied, handle accordingly
        self.finished(NO);
    }
    else if (status == kCLAuthorizationStatusAuthorizedAlways) {
        if(DEBUGGING) NSLog(@"hooray! begin startTracking");
        //hooray! begin startTracking
    }
}

// Got location and now update
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocation *currentLocation = newLocation;
    if(DEBUGGING) NSLog(@"didUpdateToLocation --> %@", currentLocation);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
     [geocoder reverseGeocodeLocation:locationManager.location
     completionHandler:^(NSArray *placemarks, NSError *error) {
     if(DEBUGGING)  NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
     CLPlacemark *placemark = [placemarks objectAtIndex:0];
         self.state     = placemark.administrativeArea;
         self.country   = placemark.country;
         self.city      = placemark.locality;
         
         //location found and reverse geo coded successfully
         self.finished(YES);
     }];
    //stop locaiton update
    [self stopLocationUpdate];
}

- (void) stopLocationUpdate {
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}


@end

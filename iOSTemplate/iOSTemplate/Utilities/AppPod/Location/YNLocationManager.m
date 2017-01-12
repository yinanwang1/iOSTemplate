//
//  YNLocationManager.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNLocationManager.h"

#import <CoreLocation/CoreLocation.h>

@interface YNLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isPositioning;

@end

@implementation YNLocationManager

#pragma mark - Initial Methods

+ (instancetype)shareInstance
{
    static YNLocationManager *locationManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [[YNLocationManager alloc] init];
    });
    
    return locationManager;
}


#pragma mark - positioning

- (void)startPositioning
{
    if(!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10.0f;
    }
    
    if(self.isPositioning) {
        return;
    }
    self.isPositioning = YES;
    
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        [self locationManager:self.locationManager didUpdateLocations:[NSArray array]];
    } else { // the user has closed this function
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    
    if(locations.count > 0) {
        CLLocation * location = [locations lastObject];
        self.latitude = location.coordinate.latitude;
        self.longitude = location.coordinate.longitude;
    }
    
    self.isPositioning = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationDidUpdateLatitude:longitude:)]) {
        [self.delegate locationDidUpdateLatitude:self.latitude longitude:self.longitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    
    self.isPositioning = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationdidFailWithError:)]) {
        [self.delegate locationdidFailWithError:error];
    }
}

@end

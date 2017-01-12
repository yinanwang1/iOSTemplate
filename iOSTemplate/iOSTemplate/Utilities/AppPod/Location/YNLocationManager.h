//
//  YNLocationManager.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YNLocationManagerDelegate <NSObject>

- (void)locationDidUpdateLatitude:(double)latitude longitude:(double)longitude;

@optional

- (void)locationdidFailWithError:(NSError *)error;

@end

@interface YNLocationManager : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) id<YNLocationManagerDelegate> delegate;


+ (instancetype)shareInstance;

- (void)startPositioning;

@end

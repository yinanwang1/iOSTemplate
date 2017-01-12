//
//  YNAppDeviceHelper.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//SAMPLE:SYSTEM_VERSION_EQUAL_TO(@"5.0.1")
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


typedef enum {
    YNDeviceUnknown,
    
    YNDeviceSimulator,
    YNDeviceSimulatoriPhone,
    YNDeviceSimulatoriPad,
    YNDeviceSimulatorAppleTV,
    
    YNDevice1GiPhone,
    YNDevice3GiPhone,
    YNDevice3GSiPhone,
    YNDevice4iPhone,
    YNDevice4SiPhone,
    YNDevice5iPhone,
    YNDevice5CiPhone,
    YNDevice5SiPhone,
    
    YNDevice1GiPod,
    YNDevice2GiPod,
    YNDevice3GiPod,
    YNDevice4GiPod,
    YNDevice5GiPod,//15
    
    YNDevice1GiPad,
    YNDevice2GiPad,
    YNDevice3GiPad,
    YNDevice4GiPad,
    YNDeviceMiniPad,
    YNDeviceiPadAir,
    YNDeviceMiniPad2G,
    
    YNDeviceAppleTV2,
    YNDeviceAppleTV3,
    YNDeviceAppleTV4,
    
    YNDeviceUnknowniPhone,
    YNDeviceUnknowniPod,
    YNDeviceUnknowniPad,
    YNDeviceUnknownAppleTV,
    YNDeviceIFPGA,
    
    YNDevice6iPhone,
    YNDevice6PlusiPhone,
    
} YNDeviceModel;

typedef enum {
    YNDeviceFamilyiPhone,
    YNDeviceFamilyiPod,
    YNDeviceFamilyiPad,
    YNDeviceFamilyAppleTV,
    YNDeviceFamilyUnknown,
    
} YNDeviceFamily;

@interface YNAppDeviceHelper : NSObject {
    
}

+ (BOOL)isDeviceIPad;
+ (BOOL)isDeviceIPhone;
+ (BOOL)deviceHasRetinaScreen;
+ (CGFloat)iosVersion;

+ (NSNumber *)totalDiskSpace;
+ (NSNumber *)freeDiskSpace;
+ (YNDeviceModel)modelType;
+ (NSString*)modelTypeString;

+ (NSString *)modelString;
+ (YNDeviceFamily)deviceFamily;

+ (NSUInteger)userMemory;
+ (NSUInteger)totalMemory;
+ (NSUInteger)cpuCount;
+ (NSUInteger)busFrequency;
+ (NSUInteger)cpuFrequency;

+ (BOOL)isInternetConnectionAvailable;

+ (NSString *)uniqueDeviceIdentifier;
+ (NSString *)currentLocaleId;
+ (CGSize)currentScreenSize;
+ (BOOL)isScreen480Height;
+ (BOOL)isScreen568Height;
+ (BOOL)isScreen667Height;
+ (BOOL)isScreen736Height;
+ (BOOL)isScreenMoreThanOrEqualTo568Height;

+ (BOOL)isIPhone5;
+ (BOOL)isIPhone6;
+ (BOOL)isIPhone6Plus;

+ (BOOL)canBlur;

+ (BOOL)isJailbroken;

@end

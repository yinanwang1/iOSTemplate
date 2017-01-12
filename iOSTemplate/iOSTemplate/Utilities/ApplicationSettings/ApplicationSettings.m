//
//  ApplicationSettings.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//


#import "ApplicationSettings.h"

#import "YNMacrosDefault.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

#pragma mark - Service Url

// http  TODO
NSString* const ServiceURLProduct      = @"http://www.baidu.com";

NSString* const ServiceURLTest         = @"http://www.baidu.com";

NSString* const ServiceURLStage        = @"http://www.baidu.com";

NSString* const ServiceURLQA           = @"http://www.baidu.com";


NSString* const kServiceURL                    = @"kServiceURL";
NSString* const kServiceURLType                = @"kServiceURLType";


static ApplicationSettings * instance;

@interface ApplicationSettings() {
    
}

@end

@implementation ApplicationSettings

+ (ApplicationSettings *)instance {
    @synchronized(self) {
        if (!instance) {
            instance = [[ApplicationSettings alloc] init];
        }
    }
    return instance;
}

+ (void)clearInstance {
    @synchronized(self) {
        if (instance) {
            instance = nil;
        }
    }
}

- (NSString*)currentServiceURL
{
    NSString *urlStr = [self serviceURLForEnvironmentType:[self currentEnvironmentType]];
    
    return urlStr;
}

- (void)setCurrentServiceURL:(NSString*)urlString
{
    [[NSUserDefaults standardUserDefaults] setObject:urlString forKey:kServiceURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (EnvironmentType)currentEnvironmentType
{
#if DEBUG
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey: kServiceURLType];
    
    return (number == nil) ? EnvironmentQA : (EnvironmentType)[number intValue];
#else
    return EnvironmentProduct;
#endif
}

- (void)setCurrentEnvironmentType:(EnvironmentType)type
{
    [[NSUserDefaults standardUserDefaults] setObject:@(type) forKey:kServiceURLType];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)serviceURLForEnvironmentType:(EnvironmentType) type {
    switch(type) {
        case EnvironmentProduct:    return ServiceURLProduct;
        case EnvironmentTemai:       return ServiceURLTest;
        case EnvironmentStage:      return ServiceURLStage;
        case EnvironmentQA:         return ServiceURLQA;
        default:
            break;
    }
    return @"";
}

/** 域名 */
- (NSArray *)hosts
{
    NSURL *serviceURLProductUrl   = [NSURL URLWithString:ServiceURLProduct];
    NSURL *serviceURLTest         = [NSURL URLWithString:ServiceURLTest];
    NSURL *serviceURLStage        = [NSURL URLWithString:ServiceURLStage];
    NSURL *serviceURLQA           = [NSURL URLWithString:ServiceURLQA];
    
    
    return @[serviceURLProductUrl.host,
             serviceURLTest.host,
             serviceURLStage.host,
             serviceURLQA.host,
             ];
}


@end

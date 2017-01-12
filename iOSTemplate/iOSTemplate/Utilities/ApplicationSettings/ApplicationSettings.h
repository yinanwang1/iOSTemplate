//
//  ApplicationSettings.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EnvironmentType) {
    EnvironmentProduct = 0,
    EnvironmentTemai,                    // 特卖环境, Dev环境
    EnvironmentStage,                    // Stage测试
    EnvironmentQA,                       // 测试环境

    ServiceURLCounts
};


@interface ApplicationSettings : NSObject

+ (ApplicationSettings *)instance;
+ (void)clearInstance;

// service base surl
- (NSString*)currentServiceURL;

- (EnvironmentType)currentEnvironmentType;

- (void)setCurrentEnvironmentType:(EnvironmentType)type;

- (NSString *)serviceURLForEnvironmentType:(EnvironmentType)type;

/** 域名 */
- (NSArray *)hosts;

@end

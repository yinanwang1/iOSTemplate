//
//  YNMacros.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#ifndef store_YNMacros_h
#define store_YNMacros_h

// 分享 结果
typedef NS_ENUM(NSUInteger, YNShareResult) {
    kYNShareResultOk = 0,
    kYNShareResultCancel = 1,
    kYNShareResultFailed = 2
};

typedef NS_ENUM(NSInteger, BikePowerMode) {
    kBikePowerModePureElectric      = 1,  // 电动模式
    kBikePowerModeAssistElectric    = 2,  // 助力模式
    kBikePowerModeLabour            = 3,  // 人力模式
};




#endif

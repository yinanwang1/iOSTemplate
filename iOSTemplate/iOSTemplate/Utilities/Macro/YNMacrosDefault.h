//
//  YNMacrosDefault.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#ifndef store_YNMacrosDefault_h
#define store_YNMacrosDefault_h

// Keys
static NSString * const kAmapKey = @"";  // 高德地图 应用key

#define kTokenRefreshed                 @"kTokenRefreshed"

static CGFloat const kHeightTabBar = 49.0f;


// 颜色
#define kMainColor                              UIColorFromRGB(0x00A8EA) // 主色
#define kComplementaryOrangeColor               UIColorFromRGB(0xF5A623) // 辅助色
#define kComplementaryRedColor                  UIColorFromRGB(0xFF4C4C) // 辅助色
#define kComplementaryGreenColor                UIColorFromRGB(0x3CBCA3) // 辅助色
#define kButtonDisableColor                     UIColorFromRGBA(0x00A8EA73) // 未输入任何信息的按钮
#define kButtonNormalColor                      UIColorFromRGB(0x00A8EA) // 输入信息后的按钮
#define kButtonHightedColor                     UIColorFromRGB(0x008BD1) // 触摸按下的按钮
#define kPrincipalMarkTextColor                 UIColorFromRGB(0x333333) // 主标字体颜色
#define kSecondaryMarkTextColor                 UIColorFromRGB(0x999999) // 次标字体颜色
#define kThirdlyMarkTextColor                   UIColorFromRGB(0xCCCCCC) // 次次标字体颜色
#define kNavigationSeparateLineColor            UIColorFromRGB(0xCCCCCC) // 导航栏分割线
#define kPageSeparateLineColor                  UIColorFromRGB(0xEBEBEB) // 页面分割线

// END 颜色

// 常用宏
#define USER_DEFAULTS_SET(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]
#define USER_DEFAULTS_OBJECT_FOR_KEY(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]



#endif

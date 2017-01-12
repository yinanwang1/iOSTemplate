//
//  YNCustomPickerView.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YNCustomPickerViewBlock)(int index, BOOL finished);

@interface YNCustomPickerView : UIView

+ (void)showWithStringArray:(NSArray *)array defaultValue:(NSString *)defaultValue toolBarColor:(UIColor *)color completeBlock:(YNCustomPickerViewBlock)block;

@end

//
//  YNSelectionControl.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNSelectionControlStyle : NSObject

@property(nonatomic) UIFont     *titleFont;         // default: HelveticaNeue-Medium 15
@property(nonatomic) UIColor    *titleColor;        // default: darkTextColor
@property(nonatomic) UIColor    *selectedColor;     // default: 0xFD5A00

+ (YNSelectionControlStyle*)defaultStyle;

@end


/*
 *
*/
@interface YNSelectionControl : UIControl

@property(nonatomic) YNSelectionControlStyle *style;    // default style, change if needed

@property(nonatomic) NSInteger selectedIdx;
@property(nonatomic) NSArray   *titles;
@property(nonatomic) BOOL showBottomSepratorLine;

@end

//
//  YNAddressSelectionControl.h
//  Pods
//
//  Created by 格格 on 16/7/19.
//
//

#import <UIKit/UIKit.h>

@interface YNAddressSelectionControlStyle : NSObject

/** 默认:系统16 */
@property (nonatomic, strong) UIFont  *titleFont;
/** 默认: darkTextColor */
@property (nonatomic, strong) UIColor *titleColor;
/** 默认: 0x07A9FA */
@property (nonatomic, strong) UIColor *selectedColor;
/** 默认: 0x999999 */
@property (nonatomic, strong) UIColor *invalidColor;
/** 默认: 0xFFFFFF */
@property (nonatomic, strong) UIColor *backgroundColor;

+ (YNAddressSelectionControlStyle*)defaultStyle;

@end

@interface YNAddressSelectionControl : UIControl

/**  default style, change if needed */
@property (nonatomic, strong) YNAddressSelectionControlStyle *style; 
@property (nonatomic, strong) NSArray   *titles;
@property (nonatomic, assign) NSInteger selectedIdx;
@property (nonatomic, assign) NSInteger availableIdx;
@property (nonatomic, assign) BOOL showBottomSepratorLine;

@end

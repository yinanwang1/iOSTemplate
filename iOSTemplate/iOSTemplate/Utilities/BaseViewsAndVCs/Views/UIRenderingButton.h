//
//  UIRenderingButton.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Used to rendering border, corner in xib/storyboard
 */

IB_DESIGNABLE
@interface UIRenderingButton : UIButton

@property(nonatomic) IBInspectable UIColor *borderColor;
@property(nonatomic) IBInspectable UIColor *highlightedBorderColor;
@property(nonatomic) IBInspectable CGFloat  borderWidth;
@property(nonatomic) IBInspectable CGFloat  cornerRadius;
@property(nonatomic) IBInspectable UIColor *highlightedbackGroundColor;
@property(nonatomic) IBInspectable UIColor *highlightedTitleColor;

@end

//
//  UIView+Extension.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "UIRenderingView.h"

@implementation UIRenderingView

#pragma mark - getter/setter

// borderColor
-(UIColor*)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

// border width
-(CGFloat)borderWidth {
    return self.layer.borderWidth;
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

// corner Radius
-(CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = cornerRadius > 0;
    self.layer.cornerRadius = cornerRadius;
}

@end

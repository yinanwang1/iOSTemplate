//
//  YNLineView.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNLineView.h"

#import "UIVIew+Extension.h"

@implementation YNLineView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    NSLayoutConstraint *consH = self.constraintHeight;
    NSLayoutConstraint *consW = self.constraintWidth;
    
    // storyboard/xib 里面只能设置至少为1的constraint
    if (consH != nil && (consH.constant <= 1.0 || consH.constant <= self.width)) { // 横线
        self.constraintHeight.constant = 1.0 / [UIScreen mainScreen].scale;
    }
    
    else if (consW != nil && (consW.constant <= 1.0 || consW.constant <= self.height)) { // 竖线
        self.constraintWidth.constant = 1.0 / [UIScreen mainScreen].scale;
    }
}

@end

//
//  YNLocationSearchBar.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNLocationSearchBar.h"

#import "UIView+Extension.h"

@implementation YNLocationSearchBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIButton *cancelBtn = (UIButton*)[self subviewOfClassType:[UIButton class] searchRecursively:YES];
    if (cancelBtn) {
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消 " forState:UIControlStateNormal];
    }
}

@end

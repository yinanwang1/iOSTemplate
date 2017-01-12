//
//  YNVerticalDashLine.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNVerticalDashLine.h"

@implementation YNVerticalDashLine

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_line_vertical"]]];
}

@end

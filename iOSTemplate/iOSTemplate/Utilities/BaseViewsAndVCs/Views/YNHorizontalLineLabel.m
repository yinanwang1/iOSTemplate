//
//  YNHorizontalLineLabel.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNHorizontalLineLabel.h"

@implementation YNHorizontalLineLabel

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_horizontal"]]];
}

@end

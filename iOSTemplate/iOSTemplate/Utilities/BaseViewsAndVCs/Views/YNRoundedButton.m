//
//  YNRoundedButton.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNRoundedButton.h"

#import "Color+Image.h"
#import "UIColor+Extensions.h"
#import "YNMacrosUtils.h"

@implementation YNRoundedButton

- (id)init {
    if(self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor highlightedColorFromColor:MAIN_COLOR]] forState:UIControlStateHighlighted];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.0;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor highlightedColorFromColor:MAIN_COLOR]] forState:UIControlStateHighlighted];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.0;
    }
    
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    if (enabled) {
        self.userInteractionEnabled = YES;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        self.userInteractionEnabled = NO;
        [self setTitleColor:UIColorFromRGB(0x45B6FB) forState:UIControlStateNormal];
    }
}

@end

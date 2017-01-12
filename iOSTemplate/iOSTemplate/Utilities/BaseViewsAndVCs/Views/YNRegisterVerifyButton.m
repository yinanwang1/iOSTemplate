//
//  YNRegisterVerifyButton.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNRegisterVerifyButton.h"

#import "UIColor+Extensions.h"
#import "UIImage+Extension.h"
#import "YNAppDeviceHelper.h"

@interface YNRegisterVerifyButton() {
    NSInteger   _count;
    NSTimer     *_timer;
}

- (void)setupVerifyBtn;
- (void)refresh:(NSTimer *)timer;
- (void)updateDynamicTitle;

@end

@implementation YNRegisterVerifyButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupVerifyBtn];
}

- (void)setupVerifyBtn
{
    self.backgroundColor = [UIColor whiteColor];

    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRGBHex:0x08A9FA] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    [self setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithRGBHex:0xE1E2E3]]
                    forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithRGBHex:0xdaf5ff]]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageFromColor:[UIColor highlightedColorFromColor:[UIColor colorWithRGBHex:0xdaf5ff]]]
                    forState:UIControlStateHighlighted];
}

#pragma mark - override

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (![[self titleForState:UIControlStateNormal] isEqualToString:@"重新发送"]) {
        [self setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self setTitle:@"发送验证码" forState:UIControlStateDisabled];
    }
}

#pragma mark - private method

- (void)updateDynamicTitle
{
    NSString *title = [NSString stringWithFormat:@"已发送%dS", (int)_count]; // 获取验证码
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [UIView setAnimationsEnabled:NO];
        [self setTitle:title forState:UIControlStateDisabled];
        [UIView setAnimationsEnabled:YES];
    }
    else {
        self.titleLabel.text = title;
        [self setTitle:title forState:UIControlStateDisabled];
    }
}

- (void)refresh:(NSTimer *)timer
{
    if(--_count > 0) {
        [self updateDynamicTitle];
    }
    else {
        [_timer invalidate];
        self.enabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self setTitle:@"重新发送" forState:UIControlStateNormal];
    }
}

#pragma mark - public method

- (BOOL) isCounting
{
    return [_timer isValid];
}

- (void)countingSeconds:(NSInteger)seconds
{
    _count = seconds;
    
    if(_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
    self.enabled = NO;
    _count--;
    [self updateDynamicTitle];
}


@end

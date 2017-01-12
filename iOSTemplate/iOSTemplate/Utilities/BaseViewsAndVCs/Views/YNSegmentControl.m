//
//  YNSegmentControl.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNSegmentControl.h"

#import "UIColor+Extensions.h"
#import "UIImage+Extension.h"
#import "UIView+Extension.h"

@implementation YNSegmentStyle

+ (YNSegmentStyle *)defaultStyle
{
    YNSegmentStyle* style = [[YNSegmentStyle alloc] init];
    
    style.borderColor = [UIColor whiteColor];
    style.titleFont = [UIFont systemFontOfSize:15.0];
    style.titleColor = [UIColor whiteColor];
    style.backGroundColor = [UIColor colorWithRGBHex:0x07A9FA];
    style.selectedTitleColor = [UIColor colorWithRGBHex:0x07A9FA];
    style.selectedBackgroundColor = [UIColor whiteColor];
    
    return style;
}

@end

// ================================================================================

@interface YNSegmentControl()
{
    NSMutableArray *_buttons;
}

- (void)setup;
- (UIButton *)buttonWithTitle:(NSString*)title;
- (void)buttonPressed:(UIButton *)btn;
- (void)updateLookAndFeel;

@end

@implementation YNSegmentControl

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = _buttons.count;
    if(count > 0) {
        CGFloat btnW = (self.width - (count - 1))/count;
        for(int i = 0; i < count; i++) {
            UIButton* btn = _buttons[i];
            btn.frame = CGRectMake((btnW + 1)*i, 0, btnW, self.height);
        }
    }
}


- (void)updateLookAndFeel
{
    self.backgroundColor = _style.borderColor;
    self.layer.borderColor = _style.borderColor.CGColor;
    
    [_buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
         btn.titleLabel.font = _style.titleFont;
        [btn setTitleColor:_style.titleColor forState:UIControlStateNormal];
        [btn setTitleColor:_style.selectedTitleColor forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageFromColor:_style.backGroundColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageFromColor:[UIColor highlightedColorFromColor: _style.backGroundColor]] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageFromColor:_style.selectedBackgroundColor] forState:UIControlStateSelected];
    }];
}

#pragma mark - private method

- (void)setup
{
    _style = [YNSegmentStyle defaultStyle];
    
    self.layer.borderWidth = 1.0;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0;
    
    _buttons = [NSMutableArray array];
    [self updateLookAndFeel];
}

- (UIButton *)buttonWithTitle:(NSString*)title
{
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor clearColor];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

- (void)buttonPressed:(UIButton *)btn
{
    NSInteger idx = [_buttons indexOfObject:btn];
    self.selectedIdx = idx;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - getter/setter

- (void)setStyle:(YNSegmentStyle *)style
{
    _style = style;
    
    [self updateLookAndFeel];
}

- (void)setSelectedIdx:(NSInteger)selectedIdx
{
    _selectedIdx = selectedIdx;
    if(selectedIdx >= 0 && selectedIdx < _buttons.count) {
        [_buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
            btn.selected = (idx == selectedIdx);
            btn.userInteractionEnabled = !(idx == selectedIdx);
        }];
    }
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    for(UIButton *btn in _buttons) {
        [btn removeFromSuperview];
    }
    
    [_buttons removeAllObjects];
    
    NSUInteger count = titles.count;
    for(int i = 0; i < count ; i++) {
        UIButton *btn = [self buttonWithTitle:titles[i]];
        [_buttons addObject:btn];
        [self addSubview:btn];
    }
    
    [self updateLookAndFeel];
    [self setNeedsLayout];
}

- (void)setSelectedIdx:(NSInteger)selectedIdx sendmessage:(BOOL)sendMessage
{
    if (!sendMessage) {
        self.selectedIdx = selectedIdx;
    }
    else {
        if(selectedIdx < _buttons.count) {
            [self buttonPressed:_buttons[selectedIdx]];
        }
    }
}

@end

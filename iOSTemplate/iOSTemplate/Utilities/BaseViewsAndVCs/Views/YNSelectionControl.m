//
//  YNSelectionControl.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNSelectionControl.h"

#import "UIColor+Extensions.h"
#import "UIView+Extension.h"

@implementation YNSelectionControlStyle

+ (YNSelectionControlStyle*)defaultStyle
{
    YNSelectionControlStyle *style = [[YNSelectionControlStyle alloc] init];
    style.titleFont = [UIFont systemFontOfSize:16];
    style.titleColor = [UIColor colorWithRGBHex:0x333333];
    style.selectedColor = [UIColor colorWithRGBHex:0x09A9FA];
    
    return style;
}

@end

// ================================================================================

@interface YNSelectionControl() {
    UIScrollView    *_contentView;
    NSMutableArray  *_buttons;
    UIView          *_bottomBar;
    UIView          *_bottomLine;
}

- (void)setup;
- (void)clearButtons;
- (UIButton*)buttonWithTitle:(NSString*)title;
- (void)buttonPressed:(UIButton *)btn;

- (void)updateLookAndFeel;

@end

@implementation YNSelectionControl

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
    
    _contentView.frame = self.bounds;
    
    NSUInteger count = _buttons.count;
    _bottomBar.hidden = (count < 1);
    if(count < 1) {
        return;
    }
    
    CGFloat padding = 12.0;
    
    __block CGFloat    w = 0;
    [_buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        CGFloat titleWidth = btn.intrinsicContentSize.width;
        if(titleWidth > w) {
            w = titleWidth;
        }
    }];
    
    w += 2*padding;
    if(w*count <= self.width) {
        w = self.width/count;
    }

    for(int i = 0 ; i < count; i++) {
        UIButton *btn = _buttons[i];
        btn.frame = CGRectMake(i*w, 0, w, self.height);
    }
    
    _contentView.contentSize = CGSizeMake(w*count, self.height);
    _bottomBar.frame = CGRectMake(_selectedIdx*w, self.height - 2.0, w, 2.0);
    
    _bottomLine.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}

#pragma mark - private method

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    
    _contentView = [[UIScrollView alloc] init];
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.scrollsToTop = NO;
    
    [self addSubview:_contentView];
    
    _style = [YNSelectionControlStyle defaultStyle];
    _buttons = [NSMutableArray array];
    
    _bottomBar = [[UIView alloc] init];
    _bottomBar.backgroundColor = _style.selectedColor;
    [_contentView addSubview:_bottomBar];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor colorWithRGBHex:0xD0D0D0];
    [self addSubview:_bottomLine];
    
    _selectedIdx = -1;
}

- (void)clearButtons
{
    for(UIButton *btn in _buttons) {
        [btn removeFromSuperview];
    }
    
    [_buttons removeAllObjects];
}

- (UIButton*)buttonWithTitle:(NSString*)title
{
    UIButton* btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor clearColor];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)buttonPressed:(UIButton *)btn
{
    NSInteger idx = [_buttons indexOfObject:btn];
    
    if (idx != self.selectedIdx) {
        self.selectedIdx = idx;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)updateLookAndFeel
{
    _bottomBar.backgroundColor = _style.selectedColor;
    
    [_buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        btn.titleLabel.font = _style.titleFont;
        [btn setTitleColor:_style.titleColor forState:UIControlStateNormal];
        [btn setTitleColor:_style.selectedColor forState:UIControlStateSelected];
    }];
}

#pragma getter/setter

- (void)setStyle:(YNSelectionControlStyle *)style
{
    _style = style;
    
    [self updateLookAndFeel];
}

- (void)setSelectedIdx:(NSInteger)selectedIdx
{
    if(_selectedIdx != selectedIdx) {
        _selectedIdx = selectedIdx;
        [_buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
            btn.selected = (idx == selectedIdx);
        }];
        
        CGFloat w = _bottomBar.width;
        [UIView animateWithDuration:0.05 animations:^{
            _bottomBar.frame = CGRectMake(_selectedIdx*w, self.height - 2.0, w, 2.0);
        }];
        
        // if there is more then one selection out of the current frame, show half of it
        if((selectedIdx + 1)*w - _contentView.contentOffset.x > self.width) {
            CGFloat offsetX = (selectedIdx + 1)*w - self.width;
            if(selectedIdx + 1 < _buttons.count) {
                offsetX += w/2.0;
            }
            [_contentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        }
        else if(selectedIdx*w - _contentView.contentOffset.x < 0) {
            CGFloat offsetX = selectedIdx*w;
            if(selectedIdx > 0) {
                offsetX -= w/2.0;
            }
            [_contentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        }
    }
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    [self clearButtons];
    
    NSInteger count = titles.count;
    for(int i = 0; i < count; i++) {
        UIButton *btn = [self buttonWithTitle:titles[i]];
        [_buttons addObject:btn];
        [_contentView addSubview:btn];
    }
    
    [self updateLookAndFeel];
    [self setNeedsLayout];
    if(count > 0) {
        _selectedIdx = -1;
        self.selectedIdx = 0;
    }
}

- (void)setShowBottomSepratorLine:(BOOL)showBottomLine
{
    _bottomLine.hidden = !showBottomLine;
}

@end

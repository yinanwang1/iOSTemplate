//
//  YNAddressSelectionControl.m
//  Pods
//
//  Created by 格格 on 16/7/19.
//
//

#import "YNAddressSelectionControl.h"
#import "UIColor+Extensions.h"
#import "UIView+Extension.h"

#define BUTTON_PADDING 15.0
#define MAX_TITLE_WIDTH 90.0

@implementation YNAddressSelectionControlStyle

+ (YNAddressSelectionControlStyle*)defaultStyle
{
    
    YNAddressSelectionControlStyle *style = [[YNAddressSelectionControlStyle alloc]init];
    style.titleFont     = [UIFont systemFontOfSize:16];
    style.titleColor    = [UIColor colorWithRGBHex:0x333333];
    style.selectedColor = [UIColor colorWithRGBHex:0x07A9FA];
    style.invalidColor  = [UIColor colorWithRGBHex:0x999999];
    style.backgroundColor = [UIColor colorWithRGBHex:0xFFFFFF];
    return style;
}

@end

@interface YNAddressSelectionControl (){
    UIScrollView    *_contentView;
    NSMutableArray  *_buttons;
    UIView          *_bottomBar;
    UIView          *_bottomLine;
}
@end

@implementation YNAddressSelectionControl


#pragma mark - lift cycle

- (instancetype)init
{
    self = [super init];
    if(self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _contentView.frame = self.bounds;
    
    NSInteger count = _buttons.count;
    _bottomBar.hidden = (count < 1);
    if(count < 0){
        return;
    }
    
    __block NSMutableArray *buttonTitleWidthArr = [NSMutableArray array];
    
    [_buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        CGFloat titleWidth = btn.intrinsicContentSize.width;
        if(titleWidth > MAX_TITLE_WIDTH)
            titleWidth = MAX_TITLE_WIDTH;
        [buttonTitleWidthArr addObject:@(titleWidth)];
    }];
    
    CGFloat w = 0;
    
    for(int i = 0 ; i < count; i++) {
        UIButton *btn = _buttons[i];
        NSNumber *buttonWidth = buttonTitleWidthArr[i];
        btn.frame = CGRectMake(w, 0, buttonWidth.floatValue + 2*BUTTON_PADDING, self.height);
        w += 2*BUTTON_PADDING + buttonWidth.floatValue;
    }
    
    _contentView.contentSize = CGSizeMake(w, self.height);
    
    if(_selectedIdx >= 0 && _selectedIdx < count){
        UIButton *selectedButton = [_buttons objectAtIndex:_selectedIdx];
        NSNumber *selectButtonWidth = buttonTitleWidthArr[_selectedIdx];
        _bottomBar.frame = CGRectMake(selectedButton.center.x - selectButtonWidth.floatValue/2 , self.height - 2.0, selectButtonWidth.floatValue, 2.0);
        
        if(selectedButton.frame.size.width + selectedButton.frame.origin.x > self.width){
            CGFloat offsetX = selectedButton.frame.size.width + selectedButton.frame.origin.x - self.width;
            [_contentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        }else if (selectedButton.frame.origin.x < _contentView.contentOffset.x){
            [_contentView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    } else {
        _bottomBar.frame = CGRectZero;
    }
    
    _bottomLine.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}


#pragma mark - private method

- (void)setup
{
    _style = [YNAddressSelectionControlStyle defaultStyle];
    
    self.backgroundColor = _style.backgroundColor;
    
    _contentView = [[UIScrollView alloc]init];
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.scrollsToTop = NO;
    [self addSubview:_contentView];
    
    _buttons = [NSMutableArray array];
    
    _bottomBar = [[UIView alloc] init];
    _bottomBar.backgroundColor = _style.selectedColor;
    [_contentView addSubview:_bottomBar];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor colorWithRGBHex:0xD0D0D0];
    [self addSubview:_bottomLine];
    
    _selectedIdx = -1;
    _availableIdx = -1;
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
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)buttonPressed:(UIButton *)btn
{
    NSInteger idx = [_buttons indexOfObject:btn];
    
    if(self.availableIdx != -1){
        if(idx > self.availableIdx)
            return;
        else{
            if (idx != self.selectedIdx) {
                self.selectedIdx = idx;
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }
    } else {
        if (idx != self.selectedIdx) {
            self.selectedIdx = idx;
            
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)updateLookAndFeel
{
    _bottomBar.backgroundColor = _style.selectedColor;
    
    [_buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        btn.titleLabel.font = _style.titleFont;
        [btn setTitleColor:_style.titleColor forState:UIControlStateNormal];
        [btn setTitleColor:_style.selectedColor forState:UIControlStateSelected];
        [btn setTitleColor:_style.invalidColor forState:UIControlStateDisabled];
        
        if (idx == _selectedIdx) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }];
}

- (void)setStyle:(YNAddressSelectionControlStyle *)style
{
    _style = style;
    
    [self updateLookAndFeel];
}

- (void)setAvailableIdx:(NSInteger)availableIdx
{
    if(_availableIdx != availableIdx) {
        _availableIdx = availableIdx;
        
        [_buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
            btn.enabled = (idx <= availableIdx);
            if(_selectedIdx > -1 && _selectedIdx < _buttons.count)
                btn.selected = (idx == _selectedIdx);
        }];
    }
}

- (void)setSelectedIdx:(NSInteger)selectedIdx
{
    if(_selectedIdx != selectedIdx) {
        _selectedIdx = selectedIdx;
        
        __block NSMutableArray *buttonTitleWidthArr = [NSMutableArray array];
        [_buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
            
            if(_availableIdx > -1 && _availableIdx < _buttons.count)
                btn.enabled = (idx <= _availableIdx);
            
            btn.selected = (idx == selectedIdx);
            
            CGFloat titleWidth = btn.intrinsicContentSize.width;
            if(titleWidth > MAX_TITLE_WIDTH)
                titleWidth = MAX_TITLE_WIDTH;
            [buttonTitleWidthArr addObject:@(titleWidth)];
        }];
        
        CGFloat w = 0;
        
        for(int i = 0 ; i < buttonTitleWidthArr.count; i++) {
            UIButton *btn = _buttons[i];
            NSNumber *buttonWidth = buttonTitleWidthArr[i];
            btn.frame = CGRectMake(w, 0, buttonWidth.floatValue + 2*BUTTON_PADDING, self.height);
            w += 2*BUTTON_PADDING + buttonWidth.floatValue;
        }
        
        UIButton *selectButton = [_buttons objectAtIndex:_selectedIdx];
        NSNumber *selectButtonWidth = [buttonTitleWidthArr objectAtIndex:_selectedIdx];
        [UIView animateWithDuration:0.05 animations:^{
            _bottomBar.frame = CGRectMake(selectButton.center.x - selectButtonWidth.floatValue/2, self.height - 2.0, selectButtonWidth.floatValue, 2.0);
        }];
        
        if(selectButton.frame.size.width + selectButton.frame.origin.x > self.width){
            CGFloat offsetX = selectButton.frame.size.width + selectButton.frame.origin.x - self.width;
            [_contentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        }else if (selectButton.frame.origin.x < _contentView.contentOffset.x){
            [_contentView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else{
          // do nothing
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
}

- (void)setShowBottomSepratorLine:(BOOL)showBottomLine
{
    _bottomLine.hidden = !showBottomLine;
}


@end

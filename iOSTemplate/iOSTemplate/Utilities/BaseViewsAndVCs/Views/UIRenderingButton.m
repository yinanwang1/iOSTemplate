//
//  UIRenderingButton.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "UIRenderingButton.h"

#import "UIImage+Extension.h"
#import "UIColor+Extensions.h"

@interface UIRenderingButton()
{
    CALayer*    _hignlightedBgLayer;
}

@property (nonatomic, strong) UIColor *normalTitleColor;

-(void)setup;

@end

@implementation UIRenderingButton

-(id)init
{
    self = [super init];
    if(self) {
        [self setup];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    
    return self;
}

-(void)setup
{
    _hignlightedBgLayer = [[CALayer alloc] init];
    [self.layer addSublayer:_hignlightedBgLayer];
    _hignlightedBgLayer.hidden = YES;
    
    [self setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithRGBHex:0xE5E5E5]] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!self.enabled) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
    else {
        self.layer.borderColor = _borderColor.CGColor;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _hignlightedBgLayer.frame = self.bounds;
}

#pragma mark - getter/setter

// borderColor
//-(UIColor*)borderColor {
//    return [UIColor colorWithCGColor:self.layer.borderColor];
//}

#pragma mark - override

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (!enabled) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
    else {
        self.layer.borderColor = _borderColor.CGColor;
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setHighlightedBorderColor:(UIColor *)highlightedBorderColor
{
    _highlightedBorderColor = highlightedBorderColor;
}

// border width
- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

// corner Radius
- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.masksToBounds = cornerRadius > 0;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setHighlightedbackGroundColor:(UIColor *)highlightedbackGroundColor
{
    _highlightedbackGroundColor = highlightedbackGroundColor;
    _hignlightedBgLayer.backgroundColor = highlightedbackGroundColor.CGColor;
}

- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor
{
    _highlightedTitleColor = highlightedTitleColor;
    _normalTitleColor = [self titleColorForState:UIControlStateNormal];
}


// override UIButton highlighted property
- (void)setHighlighted:(BOOL)highlighted
{
    _hignlightedBgLayer.hidden = !highlighted;
    
    [self.layer insertSublayer:_hignlightedBgLayer atIndex:0];
    
    if (highlighted) {
        if (nil != self.highlightedBorderColor) {
            self.layer.borderColor = self.highlightedBorderColor.CGColor;
        }
        
        if (nil != self.highlightedTitleColor) {
            [self setTitleColor:self.highlightedTitleColor forState:UIControlStateNormal];
        }
    } else {
        self.layer.borderColor = self.borderColor.CGColor;
        if (nil != self.normalTitleColor) {
            [self setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
        }
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + 2*self.layer.borderWidth, size.height + 2*self.layer.borderWidth);
}

@end

//
//  YNWarningBarView.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNWarningBarView.h"

#import "Color+Image.h"
#import "UIColor+Extensions.h"

@implementation YNWarningBarView

#pragma mark - UIView LifeCycle

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:248.0/255.0 blue:217.0/255.0 alpha:1.0];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-1, CGRectGetWidth(self.bounds), 1)];
        lineView.backgroundColor = [UIColor clearColor];
        [self addSubview:lineView];
        
        _warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetHeight(self.bounds),
                                                               0,
                                                               CGRectGetWidth(self.bounds) - 2 * CGRectGetHeight(self.bounds),
                                                               CGRectGetHeight(self.bounds))];
        self.warnLabel.text = NSLocalizedString(@"Network unavailable.Please check it!", nil);
        CGFloat warnFont = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 16 : 14;
        self.warnLabel.font = [UIFont systemFontOfSize:warnFont];
        self.warnLabel.textAlignment = NSTextAlignmentCenter;
        self.warnLabel.backgroundColor = [UIColor clearColor];
        self.warnLabel.textColor = [UIColor colorWithRGBHex:0x333333];
        
        UIButton *xBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        xBtn.frame = CGRectMake(CGRectGetMaxX(self.warnLabel.frame), 0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds));
        [xBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [xBtn addTarget:self action:@selector(letItDismiss:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.warnLabel];
//        [self addSubview:xBtn]; // Don't display this button
    }
    return self;
}

- (void)dealloc
{
    self.warnLabel = nil;
}


#pragma mark - Public Methods

- (void)customWarningText:(NSString *)warningText;
{
    self.warnLabel.text = warningText;
}

- (void)removeMyselfViewFromSuperview
{
    CGRect selfFrame = self.frame;
    selfFrame.origin.y -= CGRectGetHeight(selfFrame);
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.25f
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         weakSelf.frame = selfFrame;
                     } completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                     }];
}


#pragma mark - Target Methods

- (void)letItDismiss:(id)sender
{
    [self removeMyselfViewFromSuperview];
}

#pragma mark - UIView Override Methods

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        CGRect originFrame = self.frame;
        CGRect selfFrame = self.frame;
        selfFrame.origin.y -= CGRectGetHeight(selfFrame);
        self.frame = selfFrame;
        selfFrame.origin.y = CGRectGetMinY(originFrame);
        
        __weak typeof(self) weakSelf = self;
        
        [UIView animateWithDuration:0.25f
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             weakSelf.frame = selfFrame;
                         } completion:^(BOOL finished) {
                             [super willMoveToSuperview:newSuperview];
                         }];
        
    }else {
        [super willMoveToSuperview:newSuperview];
    }
}

@end

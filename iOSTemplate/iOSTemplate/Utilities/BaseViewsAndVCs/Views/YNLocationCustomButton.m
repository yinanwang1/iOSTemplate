//
//  YNLocationCustomButton.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNLocationCustomButton.h"

#import "YNMacrosUtils.h"

#define LOCATION_CUSTOM_BUTTON_WIDTH  200

@implementation YNLocationCustomButton

+ (id)buttonWithType:(UIButtonType)buttonType
{
    YNLocationCustomButton * button = [super buttonWithType:buttonType];
    [button setContentMode:UIViewContentModeScaleAspectFit];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumScaleFactor = 0.5;
    button.imageView.contentMode = UIViewContentModeCenter;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    button.bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    button.bottomLabel.font = [UIFont systemFontOfSize:10.0f];
    button.bottomLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    [button addSubview:button.bottomLabel];
    button.bottomLabel.adjustsFontSizeToFitWidth = YES;
    
    return button;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    CGRect frame = self.frame;
    frame.size = [self sizeThatFits:CGSizeMake(LOCATION_CUSTOM_BUTTON_WIDTH, SCREEN_HEIGHT)];
    frame.size.width += 5;
    frame.size.width = MIN(frame.size.width, LOCATION_CUSTOM_BUTTON_WIDTH);
    self.frame = frame;
    
    [self layoutSubviews];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    CGRect frame = self.frame;
    frame.size = [self sizeThatFits:CGSizeMake(LOCATION_CUSTOM_BUTTON_WIDTH, SCREEN_HEIGHT)];
    frame.size.width += 5;
    frame.size.width = MIN(frame.size.width, LOCATION_CUSTOM_BUTTON_WIDTH);
    self.frame = frame;
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat spacing = 3.0;
    CGFloat offset = -5;
    
    self.titleLabel.numberOfLines = (self.titleLabel.text.length > 10) ? 3 : (self.titleLabel.text.length > 4) ? 2 : 1;
    
    if(self.bottomLabel.text.length > 0) {
        CGSize imageSize = self.imageView.frame.size;
        self.titleEdgeInsets = UIEdgeInsetsMake(-5, -imageSize.width + offset, 5, imageSize.width + spacing - offset);
        CGSize titleSize = self.titleLabel.frame.size;
        self.imageEdgeInsets = UIEdgeInsetsMake(-5, titleSize.width + spacing + offset, 5, - titleSize.width - spacing + offset);
        
        CGSize bottomSize = [self.bottomLabel sizeThatFits:CGSizeMake(SCREEN_HEIGHT, LOCATION_CUSTOM_BUTTON_WIDTH)];
        self.bottomLabel.frame = CGRectMake((self.frame.size.width - bottomSize.width) * 0.5 + offset, self.frame.size.height - self.bottomLabel.font.lineHeight + 8, bottomSize.width + 5, self.bottomLabel.font.lineHeight);
        
        self.bottomLabel.hidden = NO;
    }else {
        CGSize imageSize = self.imageView.frame.size;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width + offset, 0, imageSize.width + spacing - offset);
        CGSize titleSize = self.titleLabel.frame.size;
        self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + spacing + offset, 0, - titleSize.width - spacing - offset);
        
        self.bottomLabel.hidden = YES;
    }
}

@end

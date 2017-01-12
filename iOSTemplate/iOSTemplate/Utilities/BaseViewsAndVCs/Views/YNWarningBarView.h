//
//  YNWarningBarView.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNWarningBarView : UIView

@property (nonatomic, strong) UILabel *warnLabel;

- (void)customWarningText:(NSString *)warningText;

- (void)removeMyselfViewFromSuperview;

@end

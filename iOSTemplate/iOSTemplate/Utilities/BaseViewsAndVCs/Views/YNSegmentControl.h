//
//  YNSegmentControl.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YNSegmentStyle : NSObject

@property(nonatomic) UIColor *borderColor;               // color for border and separator line, default white
@property(nonatomic) UIFont  *titleFont;                 // default: system 15
@property(nonatomic) UIColor *titleColor;                // default white
@property(nonatomic) UIColor *selectedTitleColor;        // default: 0x07A9FA
@property(nonatomic) UIColor *backGroundColor;           // default: 0x07A9FA
@property(nonatomic) UIColor *selectedBackgroundColor;   // default: whiteColor


+ (YNSegmentStyle *)defaultStyle;

@end



/*
 *  How to use:
 *  _segment.titles = @[@"夜猫店", @"零食盒"];
 *  [_segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
 *  or set action in storyBoard/xib, but can not set titles in storyboard/xib for now.
*/

IB_DESIGNABLE
@interface YNSegmentControl : UIControl

@property(nonatomic) YNSegmentStyle *style;  // default style, change if needed

@property(nonatomic) NSInteger   selectedIdx;
@property(nonatomic) NSArray     *titles;    //  title for each segment


- (void)setSelectedIdx:(NSInteger)selectedIdx sendmessage:(BOOL)sendMessage;

@end

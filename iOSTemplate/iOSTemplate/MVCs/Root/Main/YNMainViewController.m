//
//  YNMainViewController.m
//  service
//
//  Created by ArthurWang on 2016/12/26.
//  Copyright © 2016年 骑迹. All rights reserved.
//

#import "YNMainViewController.h"

@interface YNMainViewController ()

@end

@implementation YNMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}


#pragma mark - Override Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationNone;
}

@end

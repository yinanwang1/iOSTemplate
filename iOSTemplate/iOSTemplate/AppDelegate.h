//
//  AppDelegate.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UIViewController *rootViewController;

+ (AppDelegate *)sharedDelegate;

- (void)showPayload:(NSString *)payload;

@end


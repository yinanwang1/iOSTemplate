//
//  YNOrderActivityInfo.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YNBaseJSONModel.h"

@protocol YNOrderActivityInfo

@end

@interface YNOrderActivityInfo : JSONModel

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *shareBtnImgUrl;

@end

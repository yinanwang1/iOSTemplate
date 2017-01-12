//
//  YNAppConfig.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface YNMailComponents : NSObject

@property (nonatomic, strong) NSArray* receivers;
@property (nonatomic, strong) NSString* subject;
@property (nonatomic, strong) NSString* body;
@property (nonatomic, strong) NSData* logAttachement;

@end

@interface YNAppConfig : NSObject

+ (YNAppConfig *)sharedInstance;

@property(nonatomic, strong) NSString              *appName;
@property(nonatomic, strong) NSString              *appVersion;
@property(nonatomic, strong) NSString              *appBuild;

@property(nonatomic, strong) NSOrderedSet          *historyVersions;

@end


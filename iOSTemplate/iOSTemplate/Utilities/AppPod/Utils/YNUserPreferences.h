//
//  YNUserPreferences.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_PREFERENCE_PUSH_ENABLED            @"hx.userSetting.pushEnabled"

@interface YNUserPreferences : NSObject {
    
}

+ (YNUserPreferences *)sharedInstance;

// change current user
- (void)setCurrntUser:(NSString *)userId;
// return current user
- (NSString *)currentUser;


- (id)objectForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (NSInteger)intForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (long long)longlongForKey:(NSString *)key;

- (id)objectForKey:(NSString *)key defaultValue:(NSObject *)defaultValue;
- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSArray *)arrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
- (NSDictionary *)dictForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;
- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (NSInteger)intForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (float)floatForKey:(NSString *)key defaultValue:(float)defaultValue;
- (long long)longlongForKey:(NSString *)key defaultValue:(long long)defaultValue;

- (void)setObject:(id)value forKey:(NSString *)key;
- (void)setString:(NSString *)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setInt:(int)value forKey:(NSString *)key;
- (void)setBool:(bool)value forKey:(NSString *)key;

- (void)removeArrayItemAtIndex:(NSUInteger)index forKey:(NSString *)key;
- (void)replaceArrayItemAtIndex:(NSUInteger)index withObject:(id)newValue forKey:(NSString *)key;
- (void)addArrayItemWithObject:(id)newValue forKey:(NSString *)key;

@end

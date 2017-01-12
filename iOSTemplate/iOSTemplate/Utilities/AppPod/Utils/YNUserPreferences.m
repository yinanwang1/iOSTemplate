//
//  YNUserPreferences.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNUserPreferences.h"

#define SETTINGS_KEY @"hx.usersSettings"
#define SETTINGS_CURRENT_USER @"hx.currentSettingsUser"
#define DEFAULT_USER @"_DefaultUser"

static YNUserPreferences *__sharedUserPreference = nil;

@interface YNUserPreferences()

@property(nonatomic, strong) NSString *currentUser;

@end

@implementation YNUserPreferences

@synthesize currentUser = _currentUser;

+(YNUserPreferences *)sharedInstance {
    if (__sharedUserPreference == nil) {
        __sharedUserPreference = [[YNUserPreferences alloc] init];
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_CURRENT_USER];
        if (user == nil)
            user = DEFAULT_USER;
        __sharedUserPreference.currentUser = user;
    }
    return __sharedUserPreference;
}


- (void)setCurrntUser:(NSString *)userId {
    _currentUser = userId;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userId forKey:SETTINGS_CURRENT_USER];
    [defaults synchronize];
}

- (NSString *)currentUser {
    return _currentUser;
}

-(id)objectForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *users = [defaults objectForKey:SETTINGS_KEY];
    if (users == nil)
        return nil;
    NSDictionary *userSettings = [users objectForKey:self.currentUser];
    if (userSettings == nil)
        return nil;
    return [userSettings objectForKey:key];
}

-(NSString *)stringForKey:(NSString *)key {
    return (NSString *)[self objectForKey:key];
}

-(NSArray *)arrayForKey:(NSString *)key {
    return (NSArray *)[self objectForKey:key];
}

-(NSDictionary *)dictForKey:(NSString *)key {
    return (NSDictionary *)[self objectForKey:key];
}

-(BOOL)boolForKey:(NSString *)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
        return [value boolValue];
    else if ([value isKindOfClass:[NSString class]]) {
        NSString *str = [value lowercaseString];
        return [str isEqualToString:@"yes"] || [str isEqualToString:@"true"];
    } else
        return (value!=nil);
}

-(NSInteger)intForKey:(NSString *)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
        return [value intValue];
    else if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    } else
        return 0;
}

-(float)floatForKey:(NSString *)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
        return [value floatValue];
    else if ([value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    } else
        return 0;
}

-(long long)longlongForKey:(NSString *)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
        return [value longLongValue];
    else if ([value isKindOfClass:[NSString class]]) {
        return [value longLongValue];
    } else
        return 0;
}

-(id)objectForKey:(NSString *)key defaultValue:(NSObject *)defaultValue {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *users = [defaults objectForKey:SETTINGS_KEY];
    if (users == nil)
        return defaults;
    NSDictionary *userSettings = [users objectForKey:self.currentUser];
    if (userSettings == nil)
        return defaults;
    
    id value = [userSettings objectForKey:key];
    if (value == nil)
        return defaults;
    else
        return value;
}

-(NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    id value = [self objectForKey:key];
    if (value != nil)
        return (NSString *)value;
    else
        return defaultValue;
}

-(NSArray *)arrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue {
    id value = [self objectForKey:key];
    if (value != nil)
        return value;
    else
        return defaultValue;
}

-(NSDictionary *)dictForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue {
    id value = [self objectForKey:key];
    if (value != nil)
        return value;
    else
        return defaultValue;
}

-(BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    id value = [self objectForKey:key];
    if (value == nil)
        return defaultValue;
    if ([value isKindOfClass:[NSNumber class]])
        return [value boolValue];
    else if ([value isKindOfClass:[NSString class]]) {
        NSString *str = [value lowercaseString];
        return [str isEqualToString:@"yes"] || [str isEqualToString:@"true"];
    } else
        return (value!=nil);
}

-(NSInteger)intForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {
    id value = [self objectForKey:key];
    if (value == nil)
        return defaultValue;
    if ([value isKindOfClass:[NSNumber class]])
        return [value intValue];
    else if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    } else
        return 0;
}

-(float)floatForKey:(NSString *)key defaultValue:(float)defaultValue {
    id value = [self objectForKey:key];
    if (value == nil)
        return defaultValue;
    if ([value isKindOfClass:[NSNumber class]])
        return [value floatValue];
    else if ([value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    } else
        return 0;
}

-(long long)longlongForKey:(NSString *)key defaultValue:(long long)defaultValue {
    id value = [self objectForKey:key];
    if (value == nil)
        return defaultValue;
    if ([value isKindOfClass:[NSNumber class]])
        return [value longLongValue];
    else if ([value isKindOfClass:[NSString class]]) {
        return [value longLongValue];
    } else
        return 0;
}

-(void)setObject:(id)value forKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *users = [defaults objectForKey:SETTINGS_KEY];
    if (users == nil) {
        users = [NSMutableDictionary dictionaryWithCapacity:5];
    } else
        users = [NSMutableDictionary dictionaryWithDictionary:users];
    
    NSMutableDictionary *userSettings = [users objectForKey:self.currentUser];
    if (userSettings == nil) {
        userSettings = [NSMutableDictionary dictionaryWithCapacity:5];
        [users setObject:userSettings forKey:self.currentUser];
    } else {
        userSettings = [NSMutableDictionary dictionaryWithDictionary:userSettings];
        [users setObject:userSettings forKey:self.currentUser];
    }
    
    [userSettings setObject:value forKey:key];
    [defaults setObject:users forKey:SETTINGS_KEY];
    [defaults synchronize];
    
}

-(void)setString:(NSString *)value forKey:(NSString *)key {
    [self setObject:value forKey:key];
}

-(void)setFloat:(float)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithFloat:value] forKey:key];
}

-(void)setInt:(int)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithInt:value] forKey:key];
}

-(void)setBool:(bool)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithBool:value] forKey:key];
}

- (void)removeArrayItemAtIndex:(NSUInteger)index forKey:(NSString *)key {
    NSArray *list = [self arrayForKey:key];
    if (![list isKindOfClass:[NSArray class]])
        return;
    if (index >= [list count])
        return;
    else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[list count]-1];
        for(int i=0;i<[list count];i++) {
            if (i!=index) {
                [newList addObject:[list objectAtIndex:i]];
            }
        }
        [self setObject:newList forKey:key];
    }
}

- (void)replaceArrayItemAtIndex:(NSUInteger)index withObject:(id)newValue forKey:(NSString *)key {
    NSArray *list = [self arrayForKey:key];
    if (![list isKindOfClass:[NSArray class]])
        return;
    if (index >= [list count])
        return;
    else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[list count]-1];
        for(int i=0;i<[list count];i++) {
            if (i!=index) {
                [newList addObject:[list objectAtIndex:i]];
            } else {
                [newList addObject:newValue];
            }
        }
        [self setObject:newList forKey:key];
    }
}

- (void)addArrayItemWithObject:(id)newValue forKey:(NSString *)key {
    NSArray *list = [self arrayForKey:key];
    if (list != nil && ![list isKindOfClass:[NSArray class]])
        return;
    
    NSMutableArray *newList = [NSMutableArray arrayWithArray:list];
    [newList addObject:newValue];
    [self setObject:newList forKey:key];
}

@end

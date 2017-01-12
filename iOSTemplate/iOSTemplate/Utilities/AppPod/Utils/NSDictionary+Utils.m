//
//  NSDictionary+Utils.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

- (NSDictionary *) dictionaryByReplacingNullsWithStrings {
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        const id object = [self objectForKey: key];
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [(NSDictionary *) object dictionaryByReplacingNullsWithStrings] forKey: key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:replaced];
}

- (id)objectForKeyExpectNSNull:(id)aKey
{
    id value = [self objectForKey:aKey];
    
    if ( [value isKindOfClass:[NSNull class]] )
    {
        value = nil;
    }
    
    return value;
}

- (id)objectForKeyExpectNil:(id)aKey
{
    id value = [self objectForKey:aKey];
    
    if ( nil == value )
    {
        value = [NSNull null];
    }
    
    return value;
}

@end

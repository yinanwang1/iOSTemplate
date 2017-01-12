//
//  NSMutableDictionary+Safety.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "NSMutableDictionary+Safety.h"

@implementation NSMutableDictionary (Safety)


- (void)setObjectExceptNil:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (nil == anObject) {
        return;
    }
    
    [self setObject:anObject forKey:aKey];
}

@end

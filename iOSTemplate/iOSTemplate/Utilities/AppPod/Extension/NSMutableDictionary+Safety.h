//
//  NSMutableDictionary+Safety.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Safety)

- (void)setObjectExceptNil:(id)anObject forKey:(id<NSCopying>)aKey;

@end

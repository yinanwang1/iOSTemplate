//
//  NSDictionary+Utils.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utils)

- (NSDictionary *)dictionaryByReplacingNullsWithStrings;
- (id)objectForKeyExpectNSNull:(id)aKey;
- (id)objectForKeyExpectNil:(id)aKey;

@end

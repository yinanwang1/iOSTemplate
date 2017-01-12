//
//  YNBundle.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNBundle.h"

@implementation YNBundle

NSString* YNLocalizedString(NSString* key, NSString* comment) {
    NSBundle *bundle = [NSBundle mainBundle];
    
    return [bundle localizedStringForKey:key value:key table:nil];
}

+ (NSBundle*)YNAppBundle
{
    return [NSBundle mainBundle];
}


@end

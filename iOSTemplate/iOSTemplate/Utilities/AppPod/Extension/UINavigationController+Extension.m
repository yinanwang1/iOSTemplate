//
//  UINavigationController+Extension.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "UINavigationController+Extension.h"

@implementation UINavigationController (Extension)

- (UIViewController *)firstViewControllerOfClass:(NSString *)className
{
    NSArray *controllers = self.viewControllers.reverseObjectEnumerator.allObjects;

    NSArray *result = [controllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject isKindOfClass:NSClassFromString(className)];
    }]];
        
    if (result.count > 0) {
        return result[0];
    }
    
    return nil;
}

- (BOOL)containedController:(NSString *)className
{
    NSArray *controllers = self.viewControllers.reverseObjectEnumerator.allObjects;
    
    NSArray *result = [controllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:NSClassFromString(className)];
    }]];
    
    return (result.count > 0);
}

@end

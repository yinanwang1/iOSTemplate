/*
 *  UIViewController+MBProgressHUD.m
 *
 *  Created by Adam Duke on 10/20/11.
 *  Copyright 2011 appRenaissance, LLC. All rights reserved.
 *
 */

#import "UIViewController+Extensions.h"

#import <objc/runtime.h>
#import "UINavigationController+Extension.h"
#import "YNMacrosUtils.h"

@implementation UIViewController (Extensions)

- (UIViewController *)topMostViewController
{
    if (self.presentedViewController == nil)
    {
        return self;
    }
    else if ([self.presentedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)self.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [lastViewController topMostViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)self.presentedViewController;
    return [presentedViewController topMostViewController];
}


+ (id)controllerFromXib
{
    return [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (id)controllerFromXibWithModuleName:(NSString *)moduleNameStr
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:moduleNameStr ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    return [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:bundle];
}

- (void)back
{
    if(self.navigationController.viewControllers.count == 1) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)backToController:(NSString *)ctrlClassName
{
    if (self.navigationController) {
        NSArray *controllers = self.navigationController.viewControllers;
        NSArray *result = [controllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject isKindOfClass:NSClassFromString(ctrlClassName)];
        }]];
        
        if (result.count > 0) {
            [self.navigationController popToViewController:result[0] animated:YES];
        }
    }
}

- (void)backToControllerBeforeController:(NSString *)ctrlClassName
{
    UIViewController * vc = [self.navigationController firstViewControllerOfClass:ctrlClassName];
    if (vc) {
        NSInteger idx = [[self.navigationController viewControllers] indexOfObject:vc];
        if (idx > 0) {
            UIViewController *prevCtrl = [[self.navigationController viewControllers] objectAtIndex:(idx - 1)];
            [self.navigationController popToViewController:prevCtrl animated:YES];
        }
        else {
            DLog(@"UIViewController+Extensions: In self.navigationController's stack, the first ViewController with class (%@) is the root ViewController", ctrlClassName);
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    else {
        DLog(@"UIViewController+Extensions: In self.navigationController's stack, there isn't a ViewController with class : (%@)", ctrlClassName);
    }
}

@end

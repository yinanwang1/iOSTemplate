/*
 *  UIViewController+MBProgressHUD.h
 *
 *  Created by Adam Duke on 10/20/11.
 *  Copyright 2011 appRenaissance, LLC. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@interface UIViewController (Extensions) 

- (UIViewController *)topMostViewController;

+ (id)controllerFromXib;

+ (id)controllerFromXibWithModuleName:(NSString *)moduleNameStr;

//@Note,  Default: (self.navigationController.viewControllers.count == 1) ? Dismiss : Pop,
// subClass override if needed
- (void)back;

//@Note: will find all controllers which class is ctrlClassName, and back to the first result.
- (void)backToController:(NSString *)ctrlClassName;

- (void)backToControllerBeforeController:(NSString *)ctrlClassName;

@end

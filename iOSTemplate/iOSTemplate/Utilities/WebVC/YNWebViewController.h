//
//  YNWebViewController.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNBaseViewController.h"

@interface YNWebViewController : YNBaseViewController

/* Get/set the current URL being displayed. (Will automatically start loading) */
@property (nonatomic,strong)    NSURL *url;

/* Show the loading progress bar (default YES) */
@property (nonatomic,assign)    BOOL showLoadingBar;

/* Tint colour for the loading progress bar. Default colour is iOS system blue. */
@property (nonatomic,copy)      UIColor *loadingBarTintColor;

/* Disable the contextual popup that appears if the user taps and holds on a link. */
@property (nonatomic,assign)    BOOL disableContextualPopupMenu;

/* When being presented as modal, this optional block can be performed after the users dismisses the controller. */
@property (nonatomic,copy)      void (^modalCompletionHandler)(void);

- (NSString *)setUpNavigationRightButton:(NSDictionary *)button;

- (void)justBack;

@end

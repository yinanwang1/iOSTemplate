//
//  YNWebViewController.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNWebViewController.h"

//model
#import "YNMyJSInterface.h"
#import "AFImageDownloader.h"
#import "YNWXApiManager.h"

//category
#import "NSString+Addition.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "NSURL+QueryDictionary.h"
#import "WKWebViewJavascriptBridge.h"


#define PADDING_LEFT_BAR_ITEM  10

/* Hieght of the loading progress bar view */
#define LOADING_BAR_HEIGHT          2

/* Blank UIBarButtonItem creation */
#define BLANK_BARBUTTONITEM [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]

/* Unique URL triggered when JavaScript reports page load is complete */
NSString *kCompleteRPCURL = @"webviewprogress:///complete";

/* Default load values to defer to during the load process */
static const float kInitialProgressValue                = 0.1f;
static const float kBeforeInteractiveMaxProgressValue   = 0.5f;
static const float kAfterInteractiveMaxProgressValue    = 0.9f;

#pragma mark -
#pragma mark Loading Bar Private Interface
@interface YNWebLoadingView : UIView
@end

@implementation YNWebLoadingView
- (void)tintColorDidChange { self.backgroundColor = self.tintColor; }
@end

@interface YNWebViewController ()<WKNavigationDelegate, WKUIDelegate, UIPopoverControllerDelegate, UIScrollViewDelegate>
{
    //State tracking for load progress of current page
    struct {
        NSInteger   loadingCount;       //Number of requests concurrently being handled
        NSInteger   maxLoadCount;       //Maximum number of load requests that was reached
        BOOL        interactive;        //Load progress has reached the point where users may interact with the content
        CGFloat     loadingProgress;    //Between 0.0 and 1.0, the load progress of the current page
    } _loadingProgressState;
}

@property (nonatomic, strong)  WKWebView                *commonWebView;

@property (nonatomic, strong) YNWebLoadingView         *loadingBarView;/* The loading bar, displayed when a page is being loaded */
@property (nonatomic, strong) YNMyJSInterface          *interface;
@property (nonatomic, assign) BOOL                      hasRefreshed;
@property (nonatomic, strong) UIImageView               *imageView;
@property (nonatomic, copy)   NSString                  *rightNaviLink;

@end

@implementation YNWebViewController

#pragma mark - View Controller Lifestyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    
    [self initialNavigationBar];
    
    [self initialCommonWebView];
    
    [self initialLoadingView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //start loading the initial page
    if (self.url && self.commonWebView.URL == nil)
    {
        [self.commonWebView loadRequest:[NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1]];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.commonWebView.UIDelegate           = nil;
    self.commonWebView.navigationDelegate   = nil;
    self.interface.currentViewController    = nil;
}

#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    [self initialNavigationLeftItem];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.exclusiveTouch = YES;
    [refreshBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [refreshBtn setImage:[UIImage imageNamed:@"ic_renovate"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(tokenRefreshed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *refreshBarBtn = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    
    self.navigationItem.rightBarButtonItem = refreshBarBtn;
}

- (void)initialCommonWebView
{
    self.interface = [[YNMyJSInterface alloc] init];
    self.interface.currentViewController = self;
    
    self.commonWebView.UIDelegate = self;
    self.commonWebView.navigationDelegate = self;
    self.commonWebView.backgroundColor = [UIColor clearColor];
    self.commonWebView.contentMode = UIViewContentModeRedraw;
    self.commonWebView.opaque = NO;
    self.commonWebView.scrollView.delegate = self;
    self.commonWebView.configuration.mediaPlaybackRequiresUserAction = NO;
    self.commonWebView.configuration.allowsInlineMediaPlayback = YES;
    
#if DEBUG
    [WKWebViewJavascriptBridge enableLogging];
#endif
    
    WKWebViewJavascriptBridge *bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.commonWebView];
    [bridge setWebViewDelegate:self];
    
    [self.interface setUpWithBridge:bridge];
}

- (void)initialLoadingView
{
    //Set up the loading bar
    CGFloat y = self.commonWebView.scrollView.contentInset.top;
    self.loadingBarView = [[YNWebLoadingView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.frame), LOADING_BAR_HEIGHT)];
    self.loadingBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //set the tint color for the loading bar
    if (self.loadingBarTintColor == nil) {
        if (self.navigationController && self.navigationController.view.window.tintColor)
            self.loadingBarView.backgroundColor = self.navigationController.view.window.tintColor;
        else if (self.view.window.tintColor)
            self.loadingBarView.backgroundColor = self.view.window.tintColor;
        else
            self.loadingBarView.backgroundColor = [UIColor whiteColor];
    }else {
        self.loadingBarView.backgroundColor = self.loadingBarTintColor;
    }
}

- (NSURL *)cleanURL:(NSURL *)url
{
    //If no URL scheme was supplied, defer back to HTTP.
    if (url.scheme.length == 0)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", [url absoluteString]]];
    }
    
    NSString *tokenStr = [YNUserAccount currentAccount].strToken;
    
    NSString * string = [NSString stringWithString:url.absoluteString];
    if([string rangeOfString:@"?"].length > 0) {
        string = [NSString stringWithFormat:@"%@&token=%@", string, [tokenStr urlencode]];
    }else {
        string = [NSString stringWithFormat:@"%@?token=%@", string, [tokenStr urlencode]];
    }
    
    url = [NSURL URLWithString:string];
    
    return url;
}

- (void)setup
{
    _showLoadingBar = YES;
    
    //Set the initial default style as full screen (But this can be easily overwritten)
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    _commonWebView = [[WKWebView alloc] init];
    [self.view addSubview:self.commonWebView];
    
    [self.commonWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}


#pragma mark - Manual Property Accessors

- (void)setUrl:(NSURL *)url
{
    if (self.url == url)
        return;
    
    _url = [self cleanURL:url];
    
    if (self.commonWebView.loading)
        [self.commonWebView stopLoading];
    
    [self.commonWebView loadRequest:[NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1]];
}

- (void)setLoadingBarTintColor:(UIColor *)loadingBarTintColor
{
    if (loadingBarTintColor == self.loadingBarTintColor)
        return;
    
    _loadingBarTintColor = loadingBarTintColor;
    
    self.loadingBarView.backgroundColor = self.loadingBarTintColor;

}

#pragma mark - WKNavigationDelegate, WKUIDelegate

- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    BOOL resultBOOL = [self webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
    BOOL isLoadingDisableScheme = [self isLoadingWKWebViewDisableScheme:navigationAction.request.URL];
    
    if (resultBOOL && !isLoadingDisableScheme) {
        
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}
- (void)webView:(WKWebView*)webView didStartProvisionalNavigation:(WKNavigation*)navigation
{
    //increment the number of load requests started
    _loadingProgressState.loadingCount++;
    
    //keep track if this is the highest number of concurrent requests
    _loadingProgressState.maxLoadCount = MAX(_loadingProgressState.maxLoadCount, _loadingProgressState.loadingCount);
    
    //start tracking the load state
    [self startLoadProgress];
}
- (void)webView:(WKWebView*)webView didFinishNavigation:(WKNavigation*)navigation
{
    [self handleLoadRequestCompletion];
    
    //see if we can set the proper page title at this point
    __weak typeof(self) weakSelf = self;
    [self.commonWebView evaluateJavaScript:@"document.title" completionHandler:^(id title, NSError *error) {
        weakSelf.navigationItem.title = title;
    }];
    DLog(@"=====title %@",self.navigationItem.title);
}
- (void)webView:(WKWebView*)webView didFailProvisionalNavigation:(WKNavigation*)navigation withError:(NSError*)error
{
    [self handleLoadRequestCompletion];
}
- (void)webView:(WKWebView*)webView didFailNavigation:(WKNavigation*)navigation withError:(NSError*)error
{
    [self handleLoadRequestCompletion];
}


#pragma mark - Setup Methods

- (BOOL)webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType
{
    BOOL shouldStart = YES;
    
    NSURL * url = request.URL;
    if([url.scheme isEqualToString:@"YN"])
    {
        NSDictionary *paramDic = [url uq_queryDictionary];
        
        if([url.host isEqualToString:@"copy"])
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            
            pasteboard.string = paramDic?[paramDic objectForKey:@"text"]:@"";
            
            [MBProgressHUD showInViewWithoutIndicator:self.view status:@"已复制到剪贴板,记得去粘帖分享哦" afterDelay:1.5];
        }
        else if([url.host isEqualToString:@"share"] && paramDic != nil)
        {
            [self shareToOtherApplicationWithDic:paramDic];
        }
        else if([url.host isEqualToString:@"finish"])
        {
            [self close];
        }
        
        return NO;
    }
    
    //if the URL is the load completed notification from JavaScript
    if ([request.URL.absoluteString isEqualToString:kCompleteRPCURL])
    {
        [self finishLoadProgress];
        return NO;
    }
    
    //If the URL contrains a fragement jump (eg an anchor tag), check to see if it relates to the current page, or another
    //If we're merely jumping around the same page, don't perform a new loading bar sequence
    BOOL isFragmentJump = NO;
    if (request.URL.fragment)
    {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:self.commonWebView.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
    if (shouldStart && !isFragmentJump && isHTTP && isTopLevelNavigation && navigationType != UIWebViewNavigationTypeBackForward)
    {
        //Save the URL in the accessor property
        _url = [request URL];
        DLog(@"_url is %@.", _url);
        [self resetLoadProgress];
    }
    
    return shouldStart;
}

///判断当前加载的url是否是WKWebView不能打开的协议类型
- (BOOL)isLoadingWKWebViewDisableScheme:(NSURL*)url
{
    BOOL retValue = NO;
    
    //判断是否正在加载WKWebview不能识别的协议类型：phone numbers, email address, maps, etc.
    if ([url.scheme isEqualToString:@"tel"]) {
        UIApplication* app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            [app openURL:url];
            retValue = YES;
        }
    }
    
    return retValue;
}


#pragma mark - Target Methods

- (void)tokenRefreshed
{
    if (self.hasRefreshed) {
        return;
    }
    
    self.hasRefreshed = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self.commonWebView reload];
    
    [self performSelector:@selector(updateRefreshButtonStatus)
               withObject:nil
               afterDelay:1];
}

- (void)updateRefreshButtonStatus
{
    self.hasRefreshed = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)back
{
    if (self.commonWebView.canGoBack)
    {
        [self.commonWebView goBack];
    }
    else
    {
        [self close];
    }
}

- (void)justBack
{
    if (self.commonWebView.canGoBack)
    {
        [self.commonWebView goBack];
    }
}

- (void)close
{
    if(self.beingPresentedModally && !self.onTopOfNavigationControllerStack) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:self.modalCompletionHandler];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ShareTo Methods

- (void)shareToOtherApplicationWithDic:(NSDictionary *)paramDic
{
    NSString *title         = [paramDic objectForKey:@"title"];
    NSString *text          = [paramDic objectForKey:@"text"];
    NSString *imageString   = [paramDic objectForKey:@"image_url"];
    NSString *urlString     = [paramDic objectForKey:@"url"];
    NSInteger type          = [[paramDic objectForKey:@"type"] integerValue];
    UIImage *image;
    
    if(!imageString)
    {
        [self shareTo:type
                title:title
                 text:text
                image:image
             imageUrl:imageString
                  url:urlString];
        
        return;
    }
    
    image = [[UIImageView sharedImageDownloader].imageCache imageforRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageString]] withAdditionalIdentifier:nil];
    
    if(!image)
    {
        if(!self.imageView) {
            self.imageView = [[UIImageView alloc] init];
        }
        
        __weak typeof(self) weakSelf = self;
        
        [MBProgressHUD showInView:self.view status:@"获取分享资源..."];
        
        [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageString]]
                              placeholderImage:nil
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
         {
             BEGIN_MAIN_THREAD
             [[UIImageView sharedImageDownloader].imageCache addImage:image
                                                           forRequest:request
                                             withAdditionalIdentifier:nil];
             
             [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
             [weakSelf shareTo:type
                         title:title
                          text:text
                         image:image
                      imageUrl:imageString
                           url:urlString];
             END_MAIN_THREAD
         }
                                       failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error)
         {
             BEGIN_MAIN_THREAD
             [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:@"获取资源失败" afterDelay:1.0f];
             END_MAIN_THREAD
         }];
    }
    else
    {
        [self shareTo:type
                title:title
                 text:text
                image:image
             imageUrl:imageString
                  url:urlString];
    }

}

- (void)shareTo:(NSInteger)type
          title:(NSString *)title
           text:(NSString *)text
          image:(UIImage *)image
       imageUrl:(NSString *)imageUrl
            url:(NSString *)url
{
    // 此版本不提供
}

#pragma mark Page Load Progress Tracking Handlers

- (void)resetLoadProgress
{
    memset(&_loadingProgressState, 0, sizeof(_loadingProgressState));
    [self setLoadingProgress:0.0f];
}

- (void)startLoadProgress
{
    //If we haven't started loading yet, set the progress to small, but visible value
    if (_loadingProgressState.loadingProgress < kInitialProgressValue)
    {
        //reset the loading bar
        CGRect frame = self.loadingBarView.frame;
        frame.size.width = CGRectGetWidth(self.view.bounds);
        frame.origin.x = -frame.size.width;
        frame.origin.y = self.commonWebView.scrollView.contentInset.top;
        self.loadingBarView.frame = frame;
        self.loadingBarView.alpha = 1.0f;
        
        //add the loading bar to the view
        if (self.showLoadingBar)
            [self.view insertSubview:self.loadingBarView aboveSubview:self.commonWebView];
        
        //kickstart the loading progress
        [self setLoadingProgress:kInitialProgressValue];
        
        //show that loading started in the status bar
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)incrementLoadProgress
{
    float progress          = _loadingProgressState.loadingProgress;
    float maxProgress       = _loadingProgressState.interactive ? kAfterInteractiveMaxProgressValue : kBeforeInteractiveMaxProgressValue;
    float remainingPercent  = (float)_loadingProgressState.loadingCount / (float)_loadingProgressState.maxLoadCount;
    float increment         = (maxProgress - progress) * remainingPercent;
    progress                = fmin((progress+increment), maxProgress);
    
    [self setLoadingProgress:progress];
}

- (void)finishLoadProgress
{
    //hide the activity indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self setLoadingProgress:1.0f];
    
    //in case it didn't succeed yet, try setting the page title again
    __weak typeof(self) weakSelf = self;
    [self.commonWebView evaluateJavaScript:@"document.title" completionHandler:^(id title, NSError *error) {
        weakSelf.navigationItem.title = title;
    }];
}

- (void)setLoadingProgress:(CGFloat)loadingProgress
{
    // progress should be incremental only
    if (loadingProgress > _loadingProgressState.loadingProgress || loadingProgress == 0)
    {
        _loadingProgressState.loadingProgress = loadingProgress;
        
        //Update the loading bar progress to match
        if (self.showLoadingBar)
        {
            CGRect frame = self.loadingBarView.frame;
            frame.origin.x = -CGRectGetWidth(self.loadingBarView.frame) + (CGRectGetWidth(self.view.bounds) * _loadingProgressState.loadingProgress);
            
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.loadingBarView.frame = frame;
            } completion:^(BOOL finished) {
                //once loading is complete, fade it out
                if (loadingProgress >= 1.0f - FLT_EPSILON)
                {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.loadingBarView.alpha = 0.0f;
                    }];
                }
            }];
        }
    }
}

- (void)handleLoadRequestCompletion
{
    //decrement the number of concurrent requests
    _loadingProgressState.loadingCount--;
    
    //update the progress bar
    [self incrementLoadProgress];
    
    //Query the webview to see what load state JavaScript perceives it at
    __weak typeof(self) weakSelf = self;
    [self.commonWebView evaluateJavaScript:@"document.readyState" completionHandler:^(id readyState, NSError *error) {
        BOOL interactive = [readyState isEqualToString:@"interactive"];
        
        if (interactive)
        {
            //interactive means the page has loaded sufficiently to allow user interaction now
            [weakSelf dealWithInteractive];
        }
        
        BOOL isNotRedirect = weakSelf.url && [weakSelf.url isEqual:weakSelf.commonWebView.URL];
        BOOL complete = [readyState isEqualToString:@"complete"];
        if (complete && isNotRedirect) {
            [weakSelf finishLoadProgress];
        }
    }];
}

- (void)dealWithInteractive
{
    _loadingProgressState.interactive = YES;
    
    //if we're at the interactive state, attach a Javascript listener to inform us when the page has fully loaded
    NSString *waitForCompleteJS = [NSString stringWithFormat:   @"window.addEventListener('load',function() { "
                                   @"var iframe = document.createElement('iframe');"
                                   @"iframe.style.display = 'none';"
                                   @"iframe.src = '%@';"
                                   @"document.body.appendChild(iframe);"
                                   @"}, false);", kCompleteRPCURL];
    
    __weak typeof(self) weakSelf = self;
    [self.commonWebView evaluateJavaScript:waitForCompleteJS completionHandler:nil];
    
    //see if we can set the proper page title yet
    [self.commonWebView evaluateJavaScript:@"document.title" completionHandler:^(id title, NSError *error) {
        weakSelf.navigationItem.title = title;
    }];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //finally, if the app desires it, disable the ability to tap and hold on links
    if (self.disableContextualPopupMenu) {
        [self.commonWebView evaluateJavaScript:@"document.body.style.webkitTouchCallout='none';" completionHandler:nil];
    }
}

#pragma mark UIWebView Attrbutes

- (UIView *)webViewContentView
{
    //loop through the views inside the webview, and pull out the one that renders the HTML content
    for (UIView *view in self.commonWebView.scrollView.subviews)
    {
        if ([NSStringFromClass([view class]) rangeOfString:@"WebBrowser"].location != NSNotFound)
            return view;
    }
    
    return nil;
}


#pragma mark State Tracking

- (BOOL)beingPresentedModally
{
    // Check if we have a parentl navigation controller being presented modally
    if (self.navigationController)
        return ([self.navigationController presentingViewController] != nil);
    else // Check if we're directly being presented modally
        return ([self presentingViewController] != nil);
    
    return NO;
}

- (BOOL)onTopOfNavigationControllerStack
{
    if (self.navigationController == nil)
        return NO;
    
    if ([self.navigationController.viewControllers count] && [self.navigationController.viewControllers indexOfObject:self] > 0)
        return YES;
    
    return NO;
}



#pragma mark SET UP NAVIGATION RIGHT BUTTON

- (NSString *)setUpNavigationRightButton:(NSDictionary *)button
{
    NSString *typeStr;
    NSString *titleStr;
    NSString *linkStr;
    NSString *imageStr;
    SET_NULLTONIL(typeStr, [button objectForKey:@"type"]);
    SET_NULLTONIL(titleStr, [button objectForKey:@"title"]);
    SET_NULLTONIL(linkStr, [button objectForKey:@"link"]);
    SET_NULLTONIL(imageStr, [button objectForKey:@"image"]);
    
    if([typeStr isEqualToString:@"share"]) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.exclusiveTouch = YES;
        [shareBtn setFrame:CGRectMake(0, 0, 40, 40)];
        [shareBtn setImage:[UIImage imageNamed:@"ic_fenxiangBig"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(onClickshareBtn) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
        
        self.navigationItem.rightBarButtonItem = shareBarBtn;
    }else if(linkStr.length > 0) {
        self.rightNaviLink = linkStr;
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIBarButtonItem *shareBarBtn;
        shareBtn.exclusiveTouch = YES;
        [shareBtn setFrame:CGRectMake(0, 0, 40, 40)];
        if(imageStr.length > 0) {
            [shareBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:imageStr]];
            shareBarBtn = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
        }else {
            shareBarBtn = [[UIBarButtonItem alloc] initWithTitle:titleStr
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(onClickRightBtn)];
        }

        [shareBarBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x07a9fa]} forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(onClickRightBtn) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = shareBarBtn;
    }else {
        UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        refreshBtn.exclusiveTouch = YES;
        [refreshBtn setFrame:CGRectMake(0, 0, 40, 40)];
        [refreshBtn setImage:[UIImage imageNamed:@"ic_renovate"] forState:UIControlStateNormal];
        [refreshBtn addTarget:self action:@selector(tokenRefreshed) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *refreshBarBtn = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
        
        self.navigationItem.rightBarButtonItem = refreshBarBtn;
    }
    
    return @"0";
}

- (void)onClickshareBtn
{
    // 此版本不提供
}

- (void)onClickRightBtn
{
    // 此版本不提供
}


@end

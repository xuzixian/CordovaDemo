//
//  HTMLLocalViewController.m
//  CordovaDemo
//
//  Created by xianfx on 16/8/31.
//  Copyright © 2016年 RedLichee. All rights reserved.
//

#import "HTMLLocalViewController.h"

@interface HTMLLocalViewController ()

@end

@implementation HTMLLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHTMLUpdateServiceUpdateSuccessNotification) name:kHTMLUpdateServiceUpdateSuccessNotification object:nil];
}

#pragma mark - events response
- (void)onHTMLUpdateServiceUpdateSuccessNotification{
    NSURL *appURL = [self performSelector: @selector(appUrl) withObject: nil];
    UIWebView *webView = [self performSelector:@selector(webView) withObject:nil];
    
    if (appURL && webView){
        NSURLRequest* appReq = [NSURLRequest requestWithURL: appURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
        [webView loadRequest:appReq];
    }else
        [webView reload];
}

#pragma mark - getter
- (NSString *)wwwFolderName{
    return [[HTMLUpdateService shareInstance] htmlContentFolder];
}

@end

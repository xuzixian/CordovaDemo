//
//  TestViewController.m
//  CordovaDemo
//
//  Created by xianfx on 16/8/30.
//  Copyright © 2016年 RedLichee. All rights reserved.
//

#import "TestViewController.h"
#import "LocalTestViewController.h"
#import "NativeTestViewController.h"
#import "HTMLRemoteViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pluginNotificationFromWebNotification:) name:kHTMLPluginNotificationFromWebNotification object:nil];
    
    if (self.navigationController.viewControllers.count == 1) {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(closeSelf)];
        self.navigationItem.leftBarButtonItem = barItem;
    }
}

- (void)pluginNotificationFromWebNotification:(NSNotification *)noti{
    
    NSString *url = noti.object;
    if ([url rangeOfString:@"local"].location != NSNotFound) {
        LocalTestViewController *test = [[LocalTestViewController alloc] init];
        test.startPage = @"local.html";
        [self.navigationController pushViewController:test animated:YES];
    }else if ([url rangeOfString:@"remote"].location != NSNotFound){
        HTMLRemoteViewController *test = [[HTMLRemoteViewController alloc] init];
        test.wwwFolderName = @"";
        test.startPage = @"https://www.baidu.com";
        [self.navigationController pushViewController:test animated:YES];
    }else if ([url rangeOfString:@"native"].location != NSNotFound) {
        NativeTestViewController *test = [[NativeTestViewController alloc] init];
        [self.navigationController pushViewController:test animated:YES];
    }
    
}

- (void)closeSelf{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end

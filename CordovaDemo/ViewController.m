//
//  ViewController.m
//  CordovaDemo
//
//  Created by xianfx on 16/8/30.
//  Copyright © 2016年 RedLichee. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "HTMLUpdateService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self update:nil];
//    });
}

- (IBAction)update:(id)sender {
    [[HTMLUpdateService shareInstance] checkUpdateIfNeedDownload];
    
}

- (IBAction)showCordova:(id)sender {
    
    TestViewController *test = [[TestViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:test] animated:YES completion:NULL];
}

@end

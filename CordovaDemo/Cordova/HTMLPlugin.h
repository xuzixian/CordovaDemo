//
//  HTMLPlugin.h
//  CordovaDemo
//
//  Created by xianfx on 16/8/31.
//  Copyright © 2016年 RedLichee. All rights reserved.
//

#import <Cordova/CDV.h>

extern NSString * const kHTMLPluginNotificationFromWebNotification;

@interface HTMLPlugin : CDVPlugin

- (void)open:(CDVInvokedUrlCommand *)command;

@end

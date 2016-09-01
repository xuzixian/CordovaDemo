//
//  HTMLPlugin.m
//  CordovaDemo
//
//  Created by xianfx on 16/8/31.
//  Copyright © 2016年 RedLichee. All rights reserved.
//

#import "HTMLPlugin.h"

NSString * const kHTMLPluginNotificationFromWebNotification = @"kHTMLPluginNotificationFromWebNotification";

@implementation HTMLPlugin

- (void)open:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* pluginResult = nil;
    if(!command.arguments || command.arguments.count <= 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    else {
        NSLog(@"%@",command.arguments );
        id url = [command.arguments objectAtIndex:0];
        NSLog(@"%@\n=======================\n%@", [url class], url);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kHTMLPluginNotificationFromWebNotification object:url];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (BOOL)shouldAllowRequest:(NSString *)url{
    return YES;
}

- (BOOL)shouldAllowBridgeAccess:(NSString *)url{
    return YES;
}


@end

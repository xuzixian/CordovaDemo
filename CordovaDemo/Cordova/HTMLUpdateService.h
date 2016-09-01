//
//  HTMLUpdateService.h
//  CordovaDemo
//
//  Created by xianfx on 16/8/30.
//  Copyright © 2016年 RedLichee. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kHTMLUpdateServiceUpdateSuccessNotification;


@interface HTMLUpdateService : NSObject

+ (instancetype)shareInstance;
-(void)checkUpdateIfNeedDownload;

@property (nonatomic, copy, readonly) NSString *htmlContentWorkPath;  //www工作目录
@property (nonatomic, copy, readonly) NSString *htmlContentBundlePath; //www程序内目录
@property (nonatomic, copy, readonly) NSString *htmlContentNeedUpdatePath; //www待更新目录
@property (readonly) NSString *htmlContentFolder;

@end

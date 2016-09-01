//
//  HTMLUpdateService.m
//  CordovaDemo
//
//  Created by xianfx on 16/8/30.
//  Copyright © 2016年 RedLichee. All rights reserved.
//

#import "HTMLUpdateService.h"
#import <CoreGraphics/CoreGraphics.h>
//#import <RequestClient/RequestClient.h>
#import "IBZipArchive.h"

NSString * const kHTMLUpdateServiceUpdateSuccessNotification = @"kHTMLUpdateServiceUpdateSuccessNotification";

@interface HTMLUpdateService ()

@property (nonatomic, copy, readonly) NSString *htmlContentBundleVersion; //www版本
//@property (nonatomic, strong) DownloadManager *downloadManager;

@end

@implementation HTMLUpdateService
@synthesize htmlContentWorkPath = _htmlContentWorkPath;
@synthesize htmlContentBundlePath = _htmlContentBundlePath;
@synthesize htmlContentNeedUpdatePath = _htmlContentNeedUpdatePath;

+ (instancetype)shareInstance{
    static HTMLUpdateService *__htmlUpdateService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __htmlUpdateService = [[HTMLUpdateService alloc] init];
    });
    return __htmlUpdateService;
}

- (void)checkUpdateIfNeedDownload{
    NSLog(@"tmpPath = %@", [self tmpUpdateFilePath]);
    NSLog(@"BundlePath = %@", self.htmlContentBundlePath);
    NSLog(@"WorkPath = %@", self.htmlContentWorkPath);
    NSLog(@"NeedUpdatePath = %@", self.htmlContentNeedUpdatePath);
//    [self.downloadManager downloadFileWithUrl:@"http://ocplp2ovf.bkt.clouddn.com/1.5.zip" filePath:[self tmpUpdateFilePath]];
}

#pragma mark - SYAPICallBackDelegate, SYAPIManagerParamSource
//- (void)managerCallAPIDidSuccess:(SYAPIBaseManager *)manager{
//    NSLog(@"成功");
//    __weak typeof(self) weakSelf = self;
//    IBZipArchive *zip = [[IBZipArchive alloc] initWithUnZipPath:[self tmpUpdateFilePath] FileName:@"lastversion" CompltedBlock:^(BOOL success, NSString *filePath) {
//        if (success){
//            NSString *cachePath = [@"~/Documents/tmp_update" stringByExpandingTildeInPath];
//            if ([[NSFileManager defaultManager] moveItemAtPath: filePath toPath: weakSelf.htmlContentNeedUpdatePath error: nil]){
//                [[NSFileManager defaultManager] removeItemAtPath: cachePath error: nil];
//            }
//            
//            [weakSelf checkAndInstall];
//        }
//    }];
//    
//    [zip start];
////    [self checkAndInstall];
//}
//
//- (void)managerCallAPIDidFialed:(SYAPIBaseManager *)manager{
//    NSLog(@"成功");
//    
//    [self managerCallAPIDidSuccess:manager];
////    [self checkAndInstall];
//}
//
//- (void)manager:(SYAPIBaseManager *)manager downloadProgress:(NSProgress *)progress{
//    NSLog(@"%lld", progress.completedUnitCount);
//}
//
//- (NSDictionary *)paramsForApi:(SYAPIBaseManager *)manager{
//    return nil;
//}

#pragma mark - private methods
-(void)checkAndInstall
{
    if ([[NSFileManager defaultManager] fileExistsAtPath: self.htmlContentNeedUpdatePath]){
        BOOL needBackup = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath: self.htmlContentWorkPath])
            needBackup = YES;
        NSString *backupFolder = [NSString stringWithFormat: @"%@_backup", self.htmlContentWorkPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath: backupFolder])
            [[NSFileManager defaultManager] removeItemAtPath: backupFolder error: nil];
        
        if (needBackup){
            if ([[NSFileManager defaultManager] moveItemAtPath: self.htmlContentWorkPath toPath: backupFolder error: nil]){
                if ([[NSFileManager defaultManager] moveItemAtPath: self.htmlContentNeedUpdatePath toPath: self.htmlContentWorkPath error: nil]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kHTMLUpdateServiceUpdateSuccessNotification object: nil];
                    });
                }else {
                    [[NSFileManager defaultManager] moveItemAtPath: backupFolder toPath: self.htmlContentWorkPath error: nil];
                }
            }
        }else {
            if ([[NSFileManager defaultManager] moveItemAtPath: self.htmlContentNeedUpdatePath toPath: self.htmlContentWorkPath error: nil]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kHTMLUpdateServiceUpdateSuccessNotification object: nil];
                });
            }
        }
    }
}

#pragma mark - getter
//- (DownloadManager *)downloadManager{
//    if (_downloadManager == nil) {
//        _downloadManager = [[DownloadManager alloc] init];
//        _downloadManager.delegate = self;
//    }
//    return _downloadManager;
//}

- (NSString *)htmlContentWorkPath{
    if (_htmlContentWorkPath == nil) {
        _htmlContentWorkPath = [@"~/Documents/html_content" stringByExpandingTildeInPath];
    }
    return _htmlContentWorkPath;
}

- (NSString *)htmlContentBundlePath{
    if (_htmlContentBundlePath == nil) {
        _htmlContentBundlePath = [NSString stringWithFormat: @"%@/www", [[NSBundle mainBundle] bundlePath]];
    }
    return _htmlContentBundlePath;
}

- (NSString *)htmlContentNeedUpdatePath{
    if (_htmlContentNeedUpdatePath == nil) {
        _htmlContentNeedUpdatePath = [@"~/Documents/html_content_lastversion" stringByExpandingTildeInPath];
    }
    return _htmlContentNeedUpdatePath;
}

- (NSString *)htmlContentBundleVersion{
    NSString *bundleVersionStr = nil;
    NSString *versionFilePath = [NSString stringWithFormat: @"%@/version", self.htmlContentBundlePath];
    NSData *versionData = [[NSData alloc] initWithContentsOfFile: versionFilePath];
    NSDictionary *versionInfo = [NSJSONSerialization JSONObjectWithData:versionData options:NSJSONReadingAllowFragments error:NULL];
    if (versionInfo && versionInfo.count > 0)
        bundleVersionStr = [versionInfo objectForKey: @"version"];
    return bundleVersionStr;
}

- (NSString *)tmpUpdateFilePath{
    NSString *cachePath = [@"~/Documents/tmp_update" stringByExpandingTildeInPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath: cachePath])
        [[NSFileManager defaultManager] createDirectoryAtPath: cachePath withIntermediateDirectories: YES attributes: nil error: nil];
    
    NSString *savePath = [NSString stringWithFormat: @"%@/lastversion.zip", cachePath];
    return savePath;
}

-(NSString*)htmlContentFolder
{
    NSString *result = [NSString stringWithFormat:@"%@/www", self.htmlContentWorkPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath: result])
        result = self.htmlContentBundlePath;
    else {
        NSString *bundleVersionStr = [self.htmlContentBundleVersion copy];
        
        NSString *versionFilePath = [NSString stringWithFormat: @"%@/www/version", self.htmlContentWorkPath];
        NSData *versionData = [[NSData alloc] initWithContentsOfFile: versionFilePath];
        NSDictionary *versionInfo = [NSJSONSerialization JSONObjectWithData:versionData options:NSJSONReadingAllowFragments error:NULL];
        NSString *contentBundleVersionStr = nil;
        if (versionInfo && versionInfo.count > 0)
            contentBundleVersionStr = [versionInfo objectForKey: @"version"];
        
        if (bundleVersionStr && contentBundleVersionStr){
            CGFloat bundleVersion = [bundleVersionStr floatValue];
            CGFloat contentBundleVersion = [contentBundleVersionStr floatValue];
            if (bundleVersion > contentBundleVersion)
                result = self.htmlContentBundlePath;
        }
    }
    return result;
}

@end

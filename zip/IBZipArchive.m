//
//  IBZipArchive.h
//  iDocument
//
//  Created by Heaven
//  Copyright 2012 111. All rights reserved.
//

#import "IBZipArchive.h"

@implementation IBZipArchive

-(id)initWithZipPath:(NSString*)source SavePath:(NSString*)savePath CompltedBlock:(void (^)(BOOL))aBlock
{
    if (self = [super init]){
        _source = [source copy];
        _savePath = [savePath copy];
        zipCompltedBlock = [aBlock copy];
        isZip = YES;
    }
    return self;
}

-(id)initWithUnZipPath:(NSString*)source FileName:(NSString*)fileName CompltedBlock:(void (^)(BOOL, NSString*))aBlock
{
    if (self = [super init]){
        _source = [source copy];
        _unzipFileName = [fileName copy];
        
        unzipCompltedBlock = [aBlock copy];
        isCancel = NO;
        isZip = NO;
    }
    return self;
}

-(void)start
{
    if (isZip){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            zipArchive = [[ZipArchive alloc] init];
            BOOL success = [zipArchive CreateZipFile2: _savePath];
            if (success){
                success = [zipArchive addDirectoryToZip: _source];
                if (![zipArchive CloseZipFile2]){
                    NSLog(@"ZipArchive add folder lost!");
                    zipCompltedBlock(NO);
                }else{
                    zipCompltedBlock(YES);
                }
            }else {
                NSLog(@"Create zip file lost!");
                zipCompltedBlock(NO);
            }
        });
    }else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            zipArchive = [[ZipArchive alloc] init];
            if ([zipArchive UnzipOpenFile: _source]){
                NSString *saveFolder = [NSString stringWithFormat: @"%@_F", _source];
                if (![[NSFileManager defaultManager] fileExistsAtPath: saveFolder])
                    [[NSFileManager defaultManager] createDirectoryAtPath: saveFolder withIntermediateDirectories: YES attributes: nil error: nil];
                __block NSString *exportFolderPath = [NSString stringWithFormat: @"%@/%@", saveFolder, _unzipFileName];
                if ([zipArchive UnzipFileTo: exportFolderPath overWrite:YES]){
                    unzipCompltedBlock(YES, exportFolderPath);
                    [zipArchive UnzipCloseFile];
                }else{
                    NSLog(@"unzip file lost!");
                    unzipCompltedBlock(NO, nil);
                }
            }else {
                NSLog(@"open unzip file lost!");
                unzipCompltedBlock(NO, nil);
            }
        });
    }
}

-(void)stop
{
    if (zipArchive)
        [zipArchive cancel];
}

@end

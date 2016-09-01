//
//  IBZipArchive.h
//  iDocument
//
//  Created by Heaven
//  Copyright 2012 111. All rights reserved.
//

#import "ZipArchive.h"

@interface IBZipArchive : NSObject{
    ZipArchive *zipArchive;
    
    NSString *_source;
    NSString *_savePath;
    NSString *_unzipFileName;
    void (^zipCompltedBlock)(BOOL);
    void (^unzipCompltedBlock)(BOOL, NSString*);
    BOOL isStarted;
    BOOL isCancel;
    BOOL isZip;
}

-(id)initWithZipPath:(NSString*)source SavePath:(NSString*)savePath CompltedBlock:(void (^)(BOOL))aBlock;
-(id)initWithUnZipPath:(NSString*)source FileName:(NSString*)fileName CompltedBlock:(void (^)(BOOL, NSString*))aBlock;
-(void)start;
-(void)stop;

@end

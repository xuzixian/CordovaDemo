//
//  ZipArchive.h
//  
//
//  Created by aish on 08-9-11.
//  acsolu@gmail.com
//  Copyright 2008  Inc. All rights reserved.
//


#import "zip.h"
#import "unzip.h"
#import <Foundation/Foundation.h>


@protocol ZipArchiveDelegate <NSObject>
@optional
-(void) ErrorMessage:(NSString*) msg;
-(BOOL) OverWriteOperation:(NSString*) file;

@end


@interface ZipArchive : NSObject {
@private
	zipFile		_zipFile;
	unzFile		_unzFile;
	
	NSString*   _password;
	id			_delegate;
    BOOL isCancel;
}

@property (nonatomic, retain) id <ZipArchiveDelegate> delegate;

-(BOOL)CreateZipFile2:(NSString*) zipFile;
-(BOOL)CreateZipFile2:(NSString*) zipFile Password:(NSString*) password;
-(BOOL)addFileToZip:(NSString*) file newname:(NSString*) newname;
-(BOOL)addDirectoryToZip:(NSString*)fromPath;
-(BOOL)CloseZipFile2;

-(BOOL)UnzipOpenFile:(NSString*) zipFile;
-(BOOL)UnzipOpenFile:(NSString*) zipFile Password:(NSString*) password;
-(BOOL)UnzipFileTo:(NSString*) path overWrite:(BOOL) overwrite;
-(BOOL)UnzipCloseFile;

-(void)cancel;
@end

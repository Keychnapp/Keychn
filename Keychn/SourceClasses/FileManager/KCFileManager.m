//
//  KCFileManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCFileManager.h"

@interface KCFileManager () {
    NSFileManager *_fileManager;
}

@end

@implementation KCFileManager

- (BOOL)copyDatabase {
    //copy database to the system directory
    if(!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    NSString *appHomeDirectory   = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbDirectoryPath    = [appHomeDirectory stringByAppendingPathComponent:DATABASE_DIRECTORY_NAME];
    
    //create database directory in system libray
    [self createDirectoryAtPath:dbDirectoryPath];
    
    //get database file from Bundle
    NSString *filePath =  [[NSBundle mainBundle] pathForResource:DATABASE_FILE_NAME
                                                          ofType:DATABASE_FILE_EXTENTION];
    
    //prepare file name for the keychn database
    NSString *dbFilePath = [dbDirectoryPath stringByAppendingPathComponent:KEYCHN_DATABASE_FILE];
    
    
    
    //copy database to system library, if already not exists
    if(  !( [_fileManager fileExistsAtPath:dbFilePath])) {
        [_fileManager copyItemAtPath:filePath toPath:dbFilePath error:nil];
        return YES;
    }
    return NO;
}

- (BOOL)createDirectoryAtPath:(NSString *)directoryName {
    //create directory on the given path
    if(!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    BOOL dirStatusExist      = [_fileManager fileExistsAtPath:directoryName];
    BOOL dirStatusCreated    = NO;
    if (!dirStatusExist ) {
        dirStatusCreated = [_fileManager createDirectoryAtPath:directoryName withIntermediateDirectories:YES attributes:Nil error:nil];
    }
    if( dirStatusExist || dirStatusCreated) {
        return YES;
    }
    return NO;
}

- (BOOL)deleteFile:(NSString*)fileName {
    //delete file or directory by name
    NSError *error;
    NSString *appHomeDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dirPath          = [appHomeDirectory stringByAppendingPathComponent:fileName];
    if(!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
   return [_fileManager removeItemAtPath:dirPath error:&error];
}

- (BOOL)deleteSystemDatabase {
    //Delete database file
   BOOL status =  [self deleteFile:DATABASE_DIRECTORY_NAME];
    [self copyDatabase];
    return status;
}


@end

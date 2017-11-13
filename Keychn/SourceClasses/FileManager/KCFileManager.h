//
//  KCFileManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCFileManager : NSObject

/**
 @abstract This method copies the database from the project resource to the system direcotry
 @param No Parameter
 @return Yes if copied else No
*/
- (BOOL) copyDatabase;

/**
 @abstract This mehtod will create a sub-direcoty in the system diretory
 @param Direcory Name
 @return YES if deleted else NO
 */
- (BOOL) createDirectoryAtPath:(NSString *)directoryName;

/**
 @abstract This method will delete a file/directory from the system directory by its name
 @param File/Directory Name
 @return YES if deleted else NO
 */
- (BOOL) deleteFile:(NSString*)fileName;

/**
 @abstract This method will delete System Database
 @param No Parameter
 @return YES if deleted else NO
 */
- (BOOL) deleteSystemDatabase;

@end

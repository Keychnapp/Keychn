//
//  KCAutoLoginManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 18/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCAutoLoginManager.h"
#import "KCUserProfileDBManager.h"
#import "AppDelegate.h"
#import "KCFileManager.h"
#import "KCDatabaseOperation.h"


@interface KCAutoLoginManager () {
    KCUserProfile           *_userProfile;
}

@end

@implementation KCAutoLoginManager

- (void)validateUserLogin {
    // Validate user login and switch to various screens accoridingly
    // Get logged in User Profile
    KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
    _userProfile        = [KCUserProfile sharedInstance];
    [userProfileDBManager getLoggedInUserProfile];
    
    //Verify version number
    NSString *versionNumber      = [self getAppVersion];
    NSString *savedAppVersion    = [self getSavedAppVersion];
    if(!(savedAppVersion  && [versionNumber isEqualToString:savedAppVersion])) {
        if(DEBUGGING) NSLog(@"copyDatabase --> App version changed, deleting user profile");
        
        [self saveNewVersion:versionNumber];
        
        // Database backup
        NSDictionary *backupDictionary = [self createBackup];
        
        // Delete old database
        KCFileManager *fileManager = [KCFileManager new];
        [fileManager deleteSystemDatabase];
        [fileManager copyDatabase];
        
        // Restore database
        [self restoreWithTableData:backupDictionary];
    }
    
    [self pushNextViewController];
    
}

#pragma mark - App Navigation

- (void) pushNextViewController {
    // Push next view controller based on the condition
    
    NSString *storyboardID = nil;
     if([NSString validateString:_userProfile.userID]) {
        storyboardID = kHomeViewController;
    }
    else {
        storyboardID = signUpViewController;
    }
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:storyboardID];
    UINavigationController *appNavigationController = [mainStoryBoard instantiateViewControllerWithIdentifier:rootViewController];
    
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [appNavigationController pushViewController:viewController animated:YES];
    
    appDelegate.window.rootViewController  = appNavigationController;
    
    [UIView transitionWithView:appDelegate.window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                    }
                    completion:^(BOOL finished) {
                        
                    }];

}

- (void)validateAppVersionUpdate {
    //Validates sowftware version when app becomes active to watch if app version has been updated when the app was in background
    NSString *versionNumber      = [self getAppVersion];
    NSString *savedAppVersion    = [self getSavedAppVersion];
    if(!(savedAppVersion  && [versionNumber isEqualToString:savedAppVersion])) {
        [self saveNewVersion:versionNumber];
        [KCUtility logOutUser];
        
        //Delete old database
        KCFileManager *fileManager = [KCFileManager new];
        [fileManager deleteSystemDatabase];
        
        //Copy new database again to the system directory
        [fileManager copyDatabase];
    }
}

- (NSString*)getAppVersion {
    //Detect software version
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSString *versionNumber =  [NSString stringWithFormat:@"%@ (%@)",
                                majorVersion, minorVersion];
    return versionNumber;
}

- (NSString*)getSavedAppVersion {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString  *appVersion = [standardUserDefaults objectForKey:kAppVersionNumber];
    return appVersion;
}

- (void)saveNewVersion:(NSString*)version {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:version forKey:kAppVersionNumber];
}

#pragma mark - Backup and Restore

- (NSDictionary *)createBackup {
    NSLog(@"Create backup");
    NSArray *tableNamesArray = @[@"app_language_text", @"favorite_recipe", @"ingredient_selection",  @"placeholder_image", @"purchase_history", @"social_profile", @"user_profile", @"user_schedule"];
    
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation new];
    
    NSMutableDictionary *tableDataDictionary = [[NSMutableDictionary alloc] init];
    // Create backups
    for (NSString *table in tableNamesArray) {
        NSArray *dataArray = [dbOperation fetchDataFromTable:table withClause:nil];
        if([dataArray count] > 0) {
            [tableDataDictionary setObject:dataArray forKey:table];
        }
    }
    return tableDataDictionary;
}

- (void)restoreWithTableData:(NSDictionary *)tableDataDictionary {
    // Restoring database
    NSLog(@"Restoring database");
    if([tableDataDictionary count] > 0) {
        @autoreleasepool {
            KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
            for (NSString *tableName in tableDataDictionary) {
                // Iterate for all tables
                NSArray *rowsArray = [tableDataDictionary objectForKey:tableName];
                
                NSMutableString *columnNames     = [[NSMutableString alloc] init];
                NSMutableString *columnValue    = [[NSMutableString alloc] init];
                
                // Prepare column names
                NSMutableArray *allColumnNames  = [[[rowsArray firstObject] allKeys] mutableCopy];
                [allColumnNames removeObject:kIdentifier];
                for (NSString *columnName in allColumnNames) {
                    [columnNames appendFormat:@"`%@`,",columnName];
                }
                [columnNames deleteCharactersInRange:NSMakeRange([columnNames length]-1, 1)];
                
                
                // Iterate for all rows
                for (NSDictionary *tableRow in rowsArray) {
                    // Iterate for all columnns
                    NSMutableDictionary *tupleDictionary = [tableRow mutableCopy];
                    [tupleDictionary removeObjectForKey:kIdentifier];
                    [columnValue appendString:@"("];
                    for (NSString *column in tupleDictionary) {
                        NSString *value = [tupleDictionary objectForKey:column];
                        [columnValue appendFormat:@"'%@',",value.escapeSequence];
                    }
                    [columnValue deleteCharactersInRange:NSMakeRange([columnValue length]-1, 1)];
                    [columnValue appendString:@"),"];
                }
                
                @try {
                    // Remove last bracket
                    [columnValue deleteCharactersInRange:NSMakeRange([columnValue length]-1, 1)];
                    NSString *insertQuery  = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES %@",tableName, columnNames, columnValue];
                    [dbOperation executeSQLQuery:insertQuery];
                }
                @catch (NSException *exception) {
                    
                }
            }
        }
    }
}

@end

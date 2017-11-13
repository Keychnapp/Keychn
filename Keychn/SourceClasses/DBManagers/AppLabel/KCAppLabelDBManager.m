//
//  KCAppLabelDBManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCAppLabelDBManager.h"
#import "KCDatabaseOperation.h"
#import "KCPlaceholderImage.h"

@implementation KCAppLabelDBManager

- (void)saveAppLabel:(NSDictionary*)appLabelDictionary withLanguageID:(NSNumber*)languageID{
    //save app label in local database
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    
    //update default language
    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE default_language SET %@='%@'",kLanguageID,languageID];
    [dbOperation executeSQLQuery:updateQuery];
    
    __block NSNumber *languagePrefs  = languageID;
    NSDictionary *labelListDictionary = [appLabelDictionary objectForKey:kLabelList];
    KCAppLabel *appLabel = [KCAppLabel sharedInstance];
    
    for (NSString * key in labelListDictionary) {
        NSString *value = [labelListDictionary valueForKey:key];
        value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        @try {
            //assign app label
            [appLabel setValue:value forKey:key];
            //check for single quote (') for db insertion
            value             = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            //prepare raw query and insert it into database
            NSString *query   = [NSString stringWithFormat:@"INSERT INTO app_language_text (label, label_text, language_id) VALUES ('%@', '%@', '%@')",key,value,languagePrefs];
            [dbOperation executeSQLQuery:query];
        }
        @catch (NSException *exception) {
            if(DEBUGGING) NSLog(@"Lable not found with name: %@",key);
        }
    }
}

- (void)restoreAppLabel:(NSDictionary*)appLabelDictionary withLanguageID:(NSNumber*)languageID {
    //save app label in local database
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    
    //update default language
    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE default_language SET %@='%@'",kLanguageID,languageID];
    [dbOperation executeSQLQuery:updateQuery];
    
    NSArray *labelListArray = [appLabelDictionary objectForKey:kLabelList];
    KCAppLabel *appLabel = [KCAppLabel sharedInstance];
    
    for (NSString *labelListDictionary in labelListArray) {
        NSString *labelName = [labelListDictionary valueForKey:@"label"];
        NSString *labelText = [labelListDictionary valueForKey:@"label_text"];
        
        labelText = [labelText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        @try {
            //assign app label
            [appLabel setValue:labelText forKey:labelName];
            //check for single quote (') for db insertion
            labelText      = [labelText stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            //prepare raw query and insert it into database
            NSString *query   = [NSString stringWithFormat:@"INSERT INTO app_language_text (label, label_text, language_id) VALUES ('%@', '%@', '%@')",labelName,labelText,languageID];
            [dbOperation executeSQLQuery:query];
        }
        @catch (NSException *exception) {
            if(DEBUGGING) NSLog(@"Lable not found with name: %@",labelName);
        }
    }
}

- (void) getAppLabelWithLanguaeID:(NSNumber*)languageID {
    //get app label from local database
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    [dbOperation fetchAppLabelWithLanguageID:languageID];
    
    //Get placeholder images
    NSArray *placeholderImageArray = [dbOperation fetchDataFromTable:@"placeholder_image" withClause:nil];
    for (NSDictionary *placeholderImageDictionary in placeholderImageArray) {
        NSString *name      = [placeholderImageDictionary objectForKey:kName];
        NSString *imageURL   = [placeholderImageDictionary objectForKey:kImageURL];
        KCPlaceholderImage  *placeholderImage = [KCPlaceholderImage sharedInstance];
        @try {
            [placeholderImage setValue:imageURL forKey:name];
        }
        @catch (NSException *exception) {
            if(DEBUGGING) NSLog(@"Count not find placeholder variale for %@",name);
        }
    }
}


- (NSNumber *)getDefaultLanguage {
    //fetch default language
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSArray *languageArray           =  [dbOperation fetchDataFromTable:@"default_language" withClause:nil];
    NSNumber *defaultLanguage = @1;
    if([languageArray count] > 0) {
        NSDictionary *languageDictionary = [languageArray objectAtIndex:0];
        defaultLanguage        = [languageDictionary objectForKey:kLanguageID];
    }
    return defaultLanguage;
}

- (void) savePlaceholderImagesWithResponse:(NSArray*)response {
    //Save placeholder images
    if(response && [response isKindOfClass:[NSArray class]]) {
        KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
        KCPlaceholderImage  *placeholderImage = [KCPlaceholderImage sharedInstance];
        IOSDevices deviceType = [KCUtility getiOSDeviceType];
        //Delete previous entries
        NSString *deleteQuery = @"DELETE FROM placeholder_image";
        [dbOperation executeSQLQuery:deleteQuery];
        for (NSDictionary *placeholderImageDictionary in response) {
            NSString *name      = [placeholderImageDictionary objectForKey:kName];
            NSString *imageURL   = nil;
            if(deviceType == iPad) {
                imageURL = [placeholderImageDictionary objectForKey:kImageURLiPad];
            }
            else {
                imageURL = [placeholderImageDictionary objectForKey:kImageURLiPhone];
            }
            if([NSString validateString:imageURL]) {
                NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO placeholder_image (name,image_url) VALUES ('%@', '%@')",name,imageURL];
                [dbOperation executeSQLQuery:insertQuery];
                @try {
                    [placeholderImage setValue:imageURL forKey:name];
                }
                @catch (NSException *exception) {
                    if(DEBUGGING) NSLog(@"Count not find placeholder variale for %@",name);
                }
            }
        }
    }
}

@end

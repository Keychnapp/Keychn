//
//  KCAppLabelDBManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCAppLabelDBManager : NSObject

/**
 @abstract Save app labels in the local database
 @param app labels response from server, language id
 @return void
*/
- (void) saveAppLabel:(NSDictionary*)appLabelDictionary withLanguageID:(NSNumber*)languageID;

- (void)restoreAppLabel:(NSDictionary*)appLabelDictionary withLanguageID:(NSNumber*)languageID;

/**
 @abstract Save app placeholder images in local database
 @param placeholer images response from server
 @return void
 */
- (void) savePlaceholderImagesWithResponse:(NSArray*)response;

/**
 @abstract Get app label from local database
 @param Language ID
 @return void
 */
- (void) getAppLabelWithLanguaeID:(NSNumber*)languageID;

/**
 @abstract Get default language from local database
 @param No Parameter
 @return Default Language ID
 */
- (NSNumber*) getDefaultLanguage;

@end

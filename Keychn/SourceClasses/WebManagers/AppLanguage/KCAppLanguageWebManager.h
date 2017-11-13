//
//  KCAppLanguageWebManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KCSupportedLanguage;

@interface KCAppLanguageWebManager : NSObject

/**
 @abstract Get app labels from server
 @param language ID, completion handler
 @return void
*/
- (void)getAppLabelsForLanguage:(NSNumber*)langugeID withCompletionHandler:(void(^)(KCSupportedLanguage *supportedLanguage))success andFailureBlock:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will fetch the supported and active languages from server
 @param  User Profile Parameter and Success and Failure completion handler
 @return void
 */
- (void)getSupportedLanguagesWithParameters:(NSDictionary*)parameters andCompletionHandler:(void(^)(KCSupportedLanguage *supportedLanguage))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will update app language preference on server
 @param  params , success and failure completion handler
 @return void
 */
- (void) updateAppLanguagePreference:(NSDictionary*)params WithCompletionHandler:(void(^)(NSDictionary*response))success andFailure:(void(^)(NSString *title, NSString *message))failed;

@end

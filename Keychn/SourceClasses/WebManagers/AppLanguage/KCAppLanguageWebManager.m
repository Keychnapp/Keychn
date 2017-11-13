//
//  KCAppLanguageWebManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCAppLanguageWebManager.h"
#import "KCWebConnection.h"
#import "KCSupportedLanguage.h"
#import "KCAppLabelDBManager.h"
#import "KCUserProfileDBManager.h"

@implementation KCAppLanguageWebManager

- (void)getAppLabelsForLanguage:(NSNumber*)langugeID withCompletionHandler:(void(^)(KCSupportedLanguage *supportedLanguage))success andFailureBlock:(void(^)(NSString *title, NSString *message))failed{
    //get application label from server
    
    [KCProgressIndicator showProgressIndicatortWithText:AppLabel.activityUpdatingAppLanguage];
    KCWebConnection *webConnection = [[KCWebConnection alloc] init];
    if (!langugeID) {
        langugeID = @1;
    }
    NSDictionary *params           = @{kAppLanguage:langugeID};
    __block NSNumber *languagePrefs = langugeID;
    [webConnection sendDataToServerWithAction:getAppLabelAction withParameters:params success:^(NSDictionary *response) {
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //failed with response
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title               = [errorDictionary objectForKey:kTitle];
            NSString *message             =  [errorDictionary objectForKey:kMessage];
            failed(title,message);
            [KCProgressIndicator hideActivityIndicator];
        }
        else {
            //save in local database
            if(DEBUGGING) NSLog(@"getAppLabelsForLanguage %@",response);
            [self saveAppLabelsWithResponse:response withLanguageID:languagePrefs];
                [KCProgressIndicator hideActivityIndicator];
                success(nil);
        }
        
    } failure:^(NSString *response) {
        failed(AppLabel.errorTitle,AppLabel.unexpectedErrorMessage);
        [KCProgressIndicator hideActivityIndicator];
    }];
}

- (void) getSupportedLanguagesWithParameters:(NSDictionary*)parameters andCompletionHandler:(void(^)(KCSupportedLanguage *supportedLanguage))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    //get supported and active languages from server
    [KCProgressIndicator showProgressIndicatortWithText:AppLabel.activityUpdatingLanguageList];
    KCWebConnection *webConnection = [[KCWebConnection alloc] init];
    //hit server request
    [webConnection sendDataToServerWithAction:languageListAction withParameters:parameters success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"Supported Language Response %@",response);
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //failed with response
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title               = [errorDictionary objectForKey:kTitle];
            NSString *message             =  [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            KCSupportedLanguage *supportedLanguage = [KCSupportedLanguage new];
            [supportedLanguage parseAllSupportedLanguages:response];
            success(supportedLanguage);
            
        }
        [KCProgressIndicator hideActivityIndicator];
    } failure:^(NSString *response) {
        failed(AppLabel.errorTitle,AppLabel.unexpectedErrorMessage);
        [KCProgressIndicator hideActivityIndicator];
    }];
}

- (void) updateAppLanguagePreference:(NSDictionary*)params WithCompletionHandler:(void(^)(NSDictionary*response))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    //update app language and user preference languages on server
    KCWebConnection *webConnection = [[KCWebConnection alloc] init];
    [KCProgressIndicator showProgressIndicatortWithText:AppLabel.activityUpdatingAppLanguage];
    [webConnection sendDataToServerWithAction:setLanguagePreferenceAction withParameters:params success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"Updated language preference on server %@",response);
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //failed with response
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title               = [errorDictionary objectForKey:kTitle];
            NSString *message             =  [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            //app language preference updated on server
            [self updateUserLanguagePreferenceWithResponse:response];
            [KCProgressIndicator hideActivityIndicator];
            success(response);
        }
    } failure:^(NSString *response) {
        failed(AppLabel.errorTitle,AppLabel.unexpectedErrorMessage);
        [KCProgressIndicator hideActivityIndicator];
    }];

}

- (void) saveAppLabelsWithResponse:(NSDictionary*)response withLanguageID:(NSNumber*)languageID{
  //Save app label in local db
    if(DEBUGGING) NSLog(@"App Labels %@",response);
    KCAppLabelDBManager *appLabelDBManager = [KCAppLabelDBManager new];
    [appLabelDBManager saveAppLabel:response withLanguageID:languageID];
    
    //Save placeholder images in local database
    NSArray *placeholderImageArray = [response objectForKey:kPlaceholderImages];
    [appLabelDBManager savePlaceholderImagesWithResponse:placeholderImageArray];
}

- (BOOL) isFinishedWithError:(NSDictionary*)responseDictionary {
    //verify that the server returns some error
    if(responseDictionary) {
        NSString *status = [responseDictionary objectForKey:kStatus];
        return [status isEqualToString:kErrorCode];
    }
    return YES;
}

#pragma mark - Local DB Methods

- (void) updateUserLanguagePreferenceWithResponse:(NSDictionary*)response {
    //save language preferences to the local database
    KCUserProfile *userProfile = [KCUserProfile sharedInstance];
    userProfile.languageID     = [response objectForKey:kLanguageID];
    KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
    [userProfileDBManager updateUserProfile:userProfile];
}


@end

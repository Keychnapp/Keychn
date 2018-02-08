//
//  KCWebConnection.m
//  Keychn
//
//  Created by Keychn Experience SL on 30/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCWebConnection.h"
#import "AFNetworking.h"
#import "IAPSubscription.h"
#import "KeychnStore.h"

@implementation KCWebConnection

- (void) sendDataToServerWithAction:(NSString*) action withParameters:(NSDictionary*)parameters success:(void(^)(NSDictionary *response))success failure:(void(^)(NSString *response))failure {
    // a genereic method to hit the API for POST Request, using AFNetworking API
    AFHTTPRequestOperationManager *manager    = [AFHTTPRequestOperationManager manager];
    NSString                      *apiURL     = [baseURL stringByAppendingString:action];
    
    //add default language to the API request parameters
    NSMutableDictionary *params      = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [params setObject:[self userLanguageIdentifier] forKey:kLanguageID];
    
    if(DEBUGGING) NSLog(@"Server Request with URL %@ and parameters %@",apiURL,params);
    
    [manager setResponseSerializer:[AFHTTPResponseSerializer new]];
    [manager POST:apiURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if([self isUserSessionValid:responseDictionary]) {
           success(responseDictionary);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(DEBUGGING) NSLog(@"Unable to reach to server %@",error.description);
        failure(error.description);
    }];
}

- (void)httpPOSTRequestWithURL:(NSString*)url andParameters:(NSDictionary*)parameters success:(void(^)(NSDictionary *response))success failure:(void(^)(NSString *response))failure {
    // a genereic method to hit the API for POST Request, using AFNetworking API
    AFHTTPRequestOperationManager *manager    = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFJSONResponseSerializer new]];
    [manager setRequestSerializer:[AFJSONRequestSerializer new]];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // Request completed with response
//        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:NULL];
        NSLog(@"Request completed with response %@", responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Unable to reach to server %@",error.description);
        failure(error.description);
    }];
}


- (void) sendMultipartData:(NSDictionary*)parameter onAction:(NSString*)action withFileData:(NSData*)fileData success:(void(^)(NSDictionary *response))success failure:(void(^)(NSString *response))failure{
    //a generic method to send Multipart data on sever
    AFHTTPRequestOperationManager *manager    = [AFHTTPRequestOperationManager manager];
    NSString                      *updateURL  = [baseURL stringByAppendingString:action];
    
    //add default language to the API request parameters
    NSMutableDictionary *params      = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    [params setObject:[self userLanguageIdentifier] forKey:kLanguageID];
    
    if(DEBUGGING) NSLog(@"Server Request with URL %@ and parameters %@",updateURL,params);
    
    //Set Response Serializer
    [manager setResponseSerializer:[AFHTTPResponseSerializer new]];
    
    //Add Dictionary as parameter and image data as multipart form request
    [manager POST:updateURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(fileData) {
            //Add image file data as binary data
            [formData appendPartWithFileData:fileData name:kImageURL fileName:@"user_image.png" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Get Dictionary and return to block
        if(responseObject) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if([self isUserSessionValid:responseDictionary]) {
               success(responseDictionary);
            }
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Failure block, return failure description
        if(DEBUGGING) NSLog(@"Error Description %@",error.description);
        failure(error.description);
    }];
}

- (void) monitorInternetConnectionWithCompletionHandler:(void(^)(void))finished {
    //monitors internet connetoin
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        //        NSLog(@"Reachability changed: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // -- Reachable -- //
                isNetworkReachable = YES;
                [self syncSubscription];
                finished();
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                // -- Not reachable -- //
                isNetworkReachable = NO;
                finished();
                break;
        }
    }];
}

- (BOOL)isUserSessionValid:(NSDictionary*)response {
    //if session expired log out user and bring app to Sign Up screen again
    KCUserProfile *userProfile = [KCUserProfile sharedInstance];
    if(response && [response isKindOfClass:[NSDictionary class]]) {
        NSString *errorType = [response objectForKey:kErrorType];
        if([NSString validateString:errorType] && [errorType caseInsensitiveCompare:kSessionExpiredError] == NSOrderedSame) {
            if(DEBUGGING) NSLog(@"Session Expired %@",response);
            NSDictionary *errorDetails = [response objectForKey:kErrorDetails];
            NSString *errorTitle     = [errorDetails objectForKey:kTitle];
            NSString *errorMessage   = [errorDetails objectForKey:kMessage];
            [KCProgressIndicator hideActivityIndicator];
            if(userProfile.accessToken) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMasterclassPreviewDismissNotification object:nil];
                userProfile.accessToken = nil;
                [userProfile releseSharedInstance];
                [KCUIAlert showInformationAlertWithHeader:errorTitle message:errorMessage withButtonTapHandler:^{
                    [KCUtility logOutUser];
                }];
            }
            
            return NO;
        }
        else {
            return YES;
        }
    }
    return YES;
}

- (BOOL) isFinishedWithError:(NSDictionary*)responseDictionary {
    //Verify that the server returns some error
    if(responseDictionary) {
        NSString *status = [responseDictionary objectForKey:kStatus];
        return [status isEqualToString:kErrorCode];
    }
    return YES;
}

- (NSString*)userLanguageIdentifier {
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary *languageDic = [NSLocale componentsFromLocaleIdentifier:language];
    NSString *languageCode = [languageDic objectForKey:@"kCFLocaleLanguageCodeKey"];
    LanguageCode apiLanguage = English;
    if ([languageCode containsString:@"es"]) {
        apiLanguage = Spanish;
    }
    else if ([languageCode containsString:@"fr"]) {
        apiLanguage = French;
    }
    else if ([languageCode containsString:@"de"]) {
        apiLanguage = German;
    }
    return  [NSString stringWithFormat:@"%lu", (unsigned long)apiLanguage];
}

#pragma mark - Sync Purchase History

- (void)syncSubscription {
    // Check if there is any Unsynced purchase
    KCUserProfile *userProfile       = [KCUserProfile sharedInstance];
    IAPSubscription *iapSubscription = [IAPSubscription subscriptionForUser:userProfile.userID];
    if(iapSubscription && !iapSubscription.isSynced) {
        KeychnStore *keychnStore         = [KeychnStore getSharedInstance];
        [keychnStore verifyAndRestorePurchaseForProductId:iapSubscription.productId];
    }
}

@end

//
//  KCFacebookManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 14/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCFacebookManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "KCUserProfile.h"


@interface KCFacebookManager () <FBSDKSharingDelegate>

@property (nonatomic,copy) void (^facebookCompletionHandler)(BOOL flag);

@end

@implementation KCFacebookManager

/**
 @abstract Facebook Keys for facebook data from Graph API
 
*/
static NSString *fkEmailID              = @"email";
static NSString *fkSocialID             = @"id";
static NSString *fkLocationData         = @"location";
static NSString *fkLocation             = @"name";
static NSString *fkUserFullName         = @"name";
static NSString *fkPictureDictionary    = @"picture";
static NSString *fkPictureData          = @"data";
static NSString *fkPictureURL           = @"url";

- (void) connectToFacebookWithViewController:(id)viewController completionHandler:(void(^)(BOOL flag))loggedIn {
    //connect to facebook for user log in service
    self.facebookCompletionHandler = loggedIn;
    [FBSDKAccessToken setCurrentAccessToken:nil];
    
    //login with permission
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    
    //check that native facebook app is installed on device
//    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
//    
//    if (isInstalled) {
//        //autheticate from facebook app
//        [login setLoginBehavior:FBSDKLoginBehaviorNative];
//    } else {
//        //autheticate from facebook web dialog
//        
//    }
    [login setLoginBehavior:FBSDKLoginBehaviorNative];
    
    //get permissiion to read user data
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     fromViewController:viewController
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
            if(DEBUGGING) NSLog(@"Process error %@",error.description);
             self.facebookCompletionHandler(NO);
         } else if (result.isCancelled) {
            if(DEBUGGING) NSLog(@"Facebook Cancelled");
             self.facebookCompletionHandler(NO);
         } else {
            if(DEBUGGING) NSLog(@"Facebook Logged in");
             [self fetchFacebookProfile]; //get logged in user detail from facebook
         }
     }];
}

- (BOOL) isFacebookNativeAppInstalled {
    //Check if native app in installed
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    return isInstalled;
}

- (void) fetchFacebookProfile {
    //get logged in user detail from facebook
    NSDictionary *profileParameters = @{@"fields" : @"id,email,name,picture.width(400).height(400),location"};
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:profileParameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary *result, NSError *error) {
         if (!error) {
             if(DEBUGGING)  NSLog(@"fetched user:%@", result);
             [self parseFacebookData:result];
             KCUserProfile *userProfile           = [KCUserProfile sharedInstance];
             //check for email id
             if([NSString validateString:userProfile.facebookProfile.emailID]) {
               self.facebookCompletionHandler(YES);
             }
             else {
                 //do not allow facebook login if email id is not available
                 self.facebookCompletionHandler(NO);
             }
             
         }
         else {
            if(DEBUGGING) NSLog(@"Error in facebook profile %@",error.description);
             self.facebookCompletionHandler(NO);
         }
         
     }];
}

- (void) parseFacebookData:(NSDictionary*)resultDictionary {
    //parse facebook data, fethced from facebook server
    if([resultDictionary isKindOfClass:[NSDictionary class]]) {
        //parse fetched data to model
        KCUserProfile *userProfile           = [KCUserProfile sharedInstance];
        
        //basic information
        userProfile.facebookProfile.emailID     = [resultDictionary objectForKey:fkEmailID];
        userProfile.facebookProfile.username    = [resultDictionary objectForKey:fkUserFullName];
        userProfile.facebookProfile.accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
        userProfile.facebookProfile.facebookID  = [resultDictionary objectForKey:kIdentifier];
        
        //get image
        NSDictionary *pictureDictionary      = [resultDictionary objectForKey:fkPictureDictionary];
        NSDictionary *pictureDataDictionary  = [pictureDictionary objectForKey:fkPictureData];
        userProfile.facebookProfile.imageURL = [pictureDataDictionary objectForKey:fkPictureURL];
        
        //get location
        NSDictionary *locationDictionary     = [resultDictionary objectForKey:fkLocationData];
        userProfile.facebookProfile.location = [locationDictionary objectForKey:fkLocation];
    }
}

- (void) showFacebookShareDialogWithImage:(UIImage*)image inViewController:(UIViewController*)controller withCompletionHandler:(void(^)(BOOL status))finished {
    //Share image on facebook
    self.facebookCompletionHandler = finished;
    if(DEBUGGING) NSLog(@"Sharing image on facebook");
    FBSDKSharePhoto *photo          = [[FBSDKSharePhoto alloc] init];
    photo.image                     = image;
    
    photo.userGenerated             = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos                  = @[photo];

    
    FBSDKShareDialog *facebookShareDialog   = [[FBSDKShareDialog alloc] init];
    facebookShareDialog.mode                = FBSDKShareDialogModeAutomatic;
    facebookShareDialog.shareContent        = content;
    facebookShareDialog.fromViewController  = controller;
    facebookShareDialog.delegate            = self;
    [facebookShareDialog show];

}

- (void)showFacebookShareDialogWithText:(NSString*)text inViewController:(UIViewController *)controller withCompletionHandler:(void (^)(BOOL))finished {
    // Share text on facebook
    self.facebookCompletionHandler = finished;
    FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
    linkContent.contentDescription     = text;
    linkContent.contentTitle           = text;
    linkContent.contentURL             = [NSURL URLWithString:kShareURL];

    
    FBSDKShareDialog *facebookShareDialog   = [[FBSDKShareDialog alloc] init];
    // Set mode of the sheet ie: How it should be presented
    facebookShareDialog.mode                = FBSDKShareDialogModeAutomatic;
    facebookShareDialog.shareContent        = linkContent;
    facebookShareDialog.fromViewController  = controller;
    facebookShareDialog.delegate            = self;
    [facebookShareDialog show];
}

- (void) logOutFacebookUser {
    //log out from facebook and delete all session with access tokens
    
    [[FBSDKLoginManager new] logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
    }];
}

#pragma mark - Sharing Delegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    //Image shared on facebook
    if(DEBUGGING) NSLog(@"Facebook share completed %@",results);
    self.facebookCompletionHandler(YES);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    //Unable to share image
    if(DEBUGGING) NSLog(@"Facebook share failed %@",error.description);
    self.facebookCompletionHandler(NO);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {

}

@end

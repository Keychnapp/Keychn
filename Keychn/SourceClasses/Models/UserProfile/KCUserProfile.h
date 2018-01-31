//
//  KCUserProfile.h
//  Keychn
//
//  Created by Keychn Experience SL on 14/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCUserFacebookProfile.h"
#import "KCUserTwitterProfile.h"


#pragma mark - Class Forward Declarations

//@class KCUserFacebookProfile;
//@class KCUserGooglePlusProfile;
//@class KCUserTwitterProfile;

@interface KCUserProfile : NSObject

#pragma mark - User Social Profiles

@property (nonatomic,strong) KCUserFacebookProfile    *facebookProfile;
@property (nonatomic,strong) KCUserTwitterProfile     *twitterProfile;

#pragma mark - User Parameters

@property (nonatomic,copy) NSString  *username;
@property (nonatomic,copy) NSString  *emailID;
@property (nonatomic,copy) NSString  *password;
@property (nonatomic,copy) NSString  *accessToken;
@property (nonatomic,copy) NSString  *bannerImageURL;
@property (nonatomic,copy) NSString  *userType;
@property (nonatomic,copy) NSString  *imageURL;
@property (nonatomic,copy) NSString  *location;
@property (nonatomic,copy) NSNumber  *userID;
@property (nonatomic,copy) NSNumber  *credits;
@property (nonatomic,copy) NSNumber  *isActive;
@property (nonatomic,copy) NSNumber  *receiveNewsletter;
@property (nonatomic,strong) UIImage *selectedImage;

#pragma mark - Class Methods

/**
 @abstract Returns a shared instance of the KCUserProfile Class
 @param No Parameter
 @return instacne type
*/
+ (instancetype) sharedInstance;

/**
 @abstract Releases the shared instance of the user profile
 @param No Parameter
 @return void
*/
- (void) releseSharedInstance;

/**
 @abstract This method will return user profile in dictionary format.
 @param No Parameter
 @return User Profile
 */
- (NSDictionary*) getUserProfileDictionary;

/**
 @abstract This method will return user profile model from dictionary
 @param Response Dictionay
 @return void
 */
- (void) getModelFromDictionary:(NSDictionary*)response withType:(ResponseType)type;

/**
 @abstract This method will update Keychn points in local database
 @param Keychn Points
 @return void
 */
- (void)updateKeychnPoints:(NSNumber*)keychnPoints;

/**
 @abstract This method will deduct MasterClass amount when user buys a spot
 @param void
 @return void
 */
- (void)deductMasterClassAmount;

- (BOOL)isMastercef;

- (void)update;

@end

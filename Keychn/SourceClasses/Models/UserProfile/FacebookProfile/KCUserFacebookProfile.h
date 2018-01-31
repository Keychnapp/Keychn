//
//  KCUserFacebookProfile.h
//  Keychn
//
//  Created by Keychn Experience SL on 14/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCUserFacebookProfile : NSObject

@property (nonatomic, copy) NSString  *facebookID;
@property (nonatomic, copy) NSString  *username;
@property (nonatomic, copy) NSString  *emailID;
@property (nonatomic, copy) NSString  *accessToken;
@property (nonatomic, copy) NSString  *imageURL;
@property (nonatomic, copy) NSString  *location;
@property BOOL                        isActive;

/**
 @abstract This method will return user's facebook profile dictionary from model
 @param No Parameter
 @return User Social Profile Dictionary
*/
- (NSDictionary*)getSocialUserProfileDictionary;

/**
 @abstract This method will intialize facebook model from dictionary
 @param Response Dictionary and Response Type
 @return void
 */
- (void) getModelFromDictionary:(NSDictionary*)responseDictionary withType:(ResponseType)type;

@end

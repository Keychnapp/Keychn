//
//  KCGroupSession.h
//  Keychn
//
//  Created by Keychn Experience SL on 22/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCGroupSession : NSObject

/**
 @abstract This mehtod will intialize a model for MasterClass or Chew/It session from NSDictionary
 @param Server Response NSDictionary
 @return Group Session Model
 */
- (instancetype)initWithResponse:(NSDictionary*)response;
- (instancetype)initWithMasterclassDetail:(NSDictionary*)response;

@property (copy,nonatomic) NSString *videoPlaceholderImageURL;
@property (copy,nonatomic) NSString *videoURL;
@property (copy,nonatomic) NSNumber *sessionID;
@property (copy,nonatomic) NSString *chefName;
@property (copy,nonatomic) NSNumber *chefId;
@property (copy,nonatomic) NSString *conferenceId;
@property (copy,nonatomic) NSString *chefAttribute;
@property (copy,nonatomic) NSString *chefLocation;
@property (copy,nonatomic) NSString *scheduleDate;
@property (copy,nonatomic) NSString *masterChefImageURL;
@property (copy,nonatomic) NSString *facebookLink;
@property (copy,nonatomic) NSString *instagramLink;
@property (copy,nonatomic) NSString *twitterLink;
@property (copy,nonatomic) NSString *webLink;
@property (copy,nonatomic) NSString *amount;
@property BOOL                      isBooked;
@property BOOL                      isFullCapacity;
@property BOOL                      isFree;


@end

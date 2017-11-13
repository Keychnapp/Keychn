//
//  KCUserTwitterProfile.h
//  Keychn
//
//  Created by Keychn Experience SL on 14/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCUserTwitterProfile : NSObject

@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *fullName;
@property (nonatomic,copy) NSString *twitterID;
@property (nonatomic,copy) NSString *imageURL;
@property (nonatomic,copy) NSString *twitterEmailID;
@property BOOL                      isActive;

@end

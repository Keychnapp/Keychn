//
//  KCPlaceholerImage.h
//  Keychn
//
//  Created by Keychn Experience SL on 04/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCPlaceholderImage : NSObject

/**
 @abstract This method will create shared instance of the model Placeholder Image
 @param No Parameters
 @return void
 */
+ (instancetype) sharedInstance;

/**
 @abstract This method will prepare model from server response
 @param Response Array
 @return void
 */
- (void) getModelFromArrray:(NSArray*)responseArray;


// Placeholder Image
@property (nonatomic,copy) NSString *chopchop;
@property (nonatomic,copy) NSString *chewit;
@property (nonatomic,copy) NSString *tutorial;
@property (nonatomic,copy) NSString *freeride;
@property (nonatomic,copy) NSString *sunday;
@property (nonatomic,copy) NSString *monday;
@property (nonatomic,copy) NSString *tuesday;
@property (nonatomic,copy) NSString *wednesday;
@property (nonatomic,copy) NSString *thursday;
@property (nonatomic,copy) NSString *friday;
@property (nonatomic,copy) NSString *saturday;
@property (nonatomic,copy) NSString *breakfast;
@property (nonatomic,copy) NSString *lunch;
@property (nonatomic,copy) NSString *dinner;
@property (nonatomic,copy) NSString *dishofweek;
@property (nonatomic,copy) NSString *user;
@property (nonatomic,copy) NSString *masterchef;
@property (nonatomic,copy) NSString *blogger;
@property (nonatomic,copy) NSString *myschedule;

@end

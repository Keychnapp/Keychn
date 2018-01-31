//
//  KCGeoLocation.h
//  Keychn
//
//  Created by Keychn Experience SL on 29/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCGeoLocation : NSObject 

@property (nonatomic,strong) NSString     *country;
@property (nonatomic,strong) NSString     *state;
@property (nonatomic,strong) NSString     *city;
@property (nonatomic,strong) NSString     *postalCode;
@property (nonatomic,strong) NSString     *throughFare;
@property (nonatomic,strong) NSString     *locality;
@property (nonatomic,strong) NSString     *subLocality;

/**
 @abstract Update geo location and reverse geo code the updated location
 @param Completion Handler
 @return void
*/
- (void)getUserLocationWithCompletionHandeler:(void(^)(BOOL status))finished;

/**
 @abstract Stop the location update explicitly
 @param No Parameter
 @return void
 */
- (void) stopLocationUpdate;

@end

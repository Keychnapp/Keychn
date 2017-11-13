//
//  KCUtility.h
//  Keychn
//
//  Created by Keychn Experience SL on 07/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCUtility : NSObject

/**
 @abstract This method will find out the current device based on the screen height
 @param NO Parameters
 @return iOS Device Type
*/
+ (IOSDevices)getiOSDeviceType;

/**
 @abstract This method will open the iOS Settigns
 @param NO Parameters
 @return void
 */
+ (void) openiOSSettings;

/**
 @abstract This method will find out the current running version of the OS
 @param NO Parameters
 @return iOS OS Version
 */
+ (IOSVersion) getiOSVersion;

/**
 @abstract This method will log our user from all sessions and delete the user from from local database
 @param NO Parameters
 @return void
 */
+ (void) logOutUser;

/**
 @abstract This method will get the proper value suffix for decimal value. i.e. st, nd or th.
 @param Integer Value
 @return Suffix
 */
+ (NSString*)getValueSuffix:(NSInteger)value;

/**
 @abstract This method will spilit the name by white space character and return the last name.
 @param Full Name
 @return Last Name
 */
+(NSString*)getLastNameFromFullName:(NSString*)fullName;

/**
 @abstract This method will spilit the name by white space character and return the first name.
 @param Full Name
 @return First Name
 */
+(NSString*)getFirstNameFromFullName:(NSString*)fullName;

/**
 @abstract This method will spilit the alert message by :  character and return the first name.
 @param Alert Message
 @return First Name
 */
+(NSString*)getUserNameFromMessage:(NSString*)alertMessage;

@end

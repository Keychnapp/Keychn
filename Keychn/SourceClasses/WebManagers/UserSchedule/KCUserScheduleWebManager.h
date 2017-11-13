//
//  KCUserSchedule.h
//  Keychn
//
//  Created by Keychn Experience SL on 05/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCWebConnection.h"

@interface KCUserScheduleWebManager : KCWebConnection

/**
 @abstract This methhod will fetch user schedules from server
 @param Parameter Dictionary and Completion Handlers
 @return void
 */
- (void) getUserSchedulesWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This methhod will fetch various data to be displayed on InstaAction Screen from server. (MasterClass, Chew/It session, User Interaction, MySchedule)
 @param Parameter Dictionary and Completion Handlers
 @return void
 */
- (void) getUserDataWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This methhod will refresh user schedule and notifications.
 @param Parameter Dictionary
 @return void
 */

- (void)refreshUseScheduleWithParameters:(NSDictionary *)parameters;


/**
 @abstract This method will fetch all the MasterClassess and Scheduled calls.
 @param Parameter Dictionary and Completion Handlers
 @return void
 */
- (void)getMasterClassAndScheduledCallsWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

- (void)getMasterClassWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will schedule a call with the selected user's schedule.
 @param Parameter Dictionary and Completion Handlers
 @return void
 */
- (void)requestACallScheduleWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will fetch my schedule for a user which is either open or matched
 @param User credential parameter, Completion Handler
 @return void
 */
- (void) getMySchedulesWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will schedule a user's call on the selected day and slot
 @param Parameter Dictionary and Completion Handlers
 @return void
 */
- (void) scheduleUserCallWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will find other user to connect with. The user will be connected based on their preferences
 @param User Prefrences, Completion Handler
 @return void
 */
- (void) findUserForConnectionWithParameters:(NSDictionary*)parametrs withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will verify that the user notification is valid from current time
 @param Parameters and completion Handler
 @return void
 */
- (void)verifyNotificationWithScheduleDate:(NSDictionary*)params withCompletionHandler:(void (^)(BOOL))validated;

/**
 @abstract This method will mark the confernce as close when one of the user disconnects the call
 @param Conference details and Completion Handlers
 @return void
 */
- (void)closeConferenceWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will reconnect user for the same conference
 @param Conference details and Completion Handlers
 @return void
 */
- (void)reconnectUserForWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will cancel now scheduled action
 @param Conference details and Completion Handlers
 @return void
 */
- (void)cancelUserNowScheduleWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will flag a user for abuse
 @param Reported User ID and Absuer ID
 @return void
 */
- (void)flagUserWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will rate an item given by the user
 @param Item ID, Rating and User Details in Parameters
 @return void
 */
- (void)rateAnItemWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will save Free Ride item details provided by user. This may contain image data if the image is not already uploaded on server.
 @param Free/Ride details and Image to be shared
 @return void
 */
- (void) saveFreeRideUserDetailWithParamaters:(NSDictionary*)parameters andImage:(UIImage*)image withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will save Chew/It food name and rating on server
 @param User Profile Parameters, Chew/It rating and food name with completion handlers
 @return void
 */
- (void)saveChewItItemAndRatingWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will share user's cooked image with another user
 @param Users'details and Image Data
 @return void
 */
- (void)uploadFoodImageWithParametes:(NSDictionary *)parametrs andImage:(UIImage*)clickedImage withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will cancel user interaction schedule
 @param User Profile, User Interaction to cancel, Completion Handlers
 @return void
 */
- (void)cancelUserSchduleWithParametes:(NSDictionary*)parameters withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed;


@end

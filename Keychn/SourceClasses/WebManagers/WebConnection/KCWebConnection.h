//
//  KCWebConnection.h
//  Keychn
//
//  Created by Keychn Experience SL on 30/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCWebConnection : NSObject

/**
 @abstract This method will send an HTTP POST request to the server with the provided data. It uses the AFNetworking API and hence the request will be sent in background.
 @param action, Key-Value Pair, success block, failure block
 @return void
*/
- (void) sendDataToServerWithAction:(NSString*) action withParameters:(NSDictionary*)parameters success:(void(^)(NSDictionary *response))success failure:(void(^)(NSString *response))failure;

- (void)httpPOSTRequestWithURL:(NSString*)url andParameters:(NSDictionary*)parameters success:(void(^)(NSDictionary *response))success failure:(void(^)(NSString *response))failure;

/**
 @abstract This method will send an HTTP POST request to the server with the multipart data. Multipart request are handy to send files on server. It uses the AFNetworking API and hence the request will be sent in background.
 @param action, Key-Value Pair, Action Type success block, failure block
 @return void
 */
- (void) sendMultipartData:(NSDictionary*)parameter onAction:(NSString*)action withFileData:(NSData*)fileData success:(void(^)(NSDictionary *response))success failure:(void(^)(NSString *response))failure;

/**
 @abstract This method will monitor the internet connection
 @param No Parameters
 @return void
 */
- (void) monitorInternetConnectionWithCompletionHandler:(void(^)(void))finished;

/**
 @abstract This method will verify that the reques has been completed with error or not
 @param Response Dictionary
 @return YES if error occured else NO
 */
- (BOOL) isFinishedWithError:(NSDictionary*)responseDictionary;
@end

//
//  AppDelegate.m
//  Keychn
//
//  Created by Keychn Experience SL on 03/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "KCFileManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "KCAutoLoginManager.h"
#import <PushKit/PushKit.h>
#import <AudioToolbox/AudioServices.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "KeychnStore.h"
#import "KCWebConnection.h"
#import <UserNotifications/UserNotifications.h>
#import <AppsFlyerFramework/AppsFlyerLib/AppsFlyerTracker.h>
#import <Twitter/Twitter.h>
#import <TwitterCore/TwitterCore.h>
#import <TwitterKit/TwitterKit.h>

#define kTwitterAPIKey @"YEJvDUQHJl7GC6qd205dYUXPf"
#define kTwitterConsumerSecret @"i0Cff9yVdeMPdWxtJBlMOVfxKuhM5wTqaOYyJNl04tTVEphucO"

@import Firebase;

@interface AppDelegate () <UNUserNotificationCenterDelegate> {
    
    KCWebConnection     *_webConnection;
    BOOL                _appLaunched;
    KCAutoLoginManager  *_autoLoginManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    [[Twitter sharedInstance] startWithConsumerKey:kTwitterAPIKey consumerSecret:kTwitterConsumerSecret];
        
    //copy database to the system directory
    [self copyDatabase];
    
    
    // Appsflyer
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = kAppsFlyerDeveloperKey;
    [AppsFlyerTracker sharedTracker].appleAppID      = kAppleAppIdForKeychn;
    
    // MixPanel
    [Mixpanel sharedInstanceWithToken:kMixPanelToken];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:mixpanel.distinctId];
    
    // Google Firebase Configuration
    [FIRApp configure];
    
    // Initialize Fabric SDK with Crashlytics
    [Fabric with:@[[Crashlytics class]]];
    
    //manages the System ActivityIndicator on status bar for on going network request
    AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    
    
    //monitor internet connection
    _webConnection = [KCWebConnection new];
    [_webConnection monitorInternetConnectionWithCompletionHandler:^{
       
    }];
    
    [self registerForPushNotifaction];
    
#if TARGET_IPHONE_SIMULATOR
    keychnDeviceToken = [@"AEOI-09IU-56TY-MNB0-NBHY-YKC" stringByAppendingString:[NSString stringWithFormat:@"%ld", random()]];
#endif
     // Validate user login and push the required view controller based on the current user profile status
    isNetworkReachable = YES;
    _autoLoginManager = [[KCAutoLoginManager alloc] init];
    [_autoLoginManager validateUserLogin];
    _appLaunched = YES;
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // Track Installs, updates & sessions(app opens) (You must include this API to enable tracking)
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Push Notification

- (void) registerForPushNotifaction {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate                  = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                              if(granted) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                  });
                              }
                          }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    // Get Bundle Info for Remote Registration (handy if you have more than one app)
        // Prepare the Device Token for Registration (remove spaces and < >)
   keychnDeviceToken =  [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString:@"<"withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""];
    [FIRMessaging messaging].APNSToken = deviceToken;
    if(DEBUGGING) NSLog(@"Device Token is %@",keychnDeviceToken);
    [self updatePushNotificationTokenWithToken:keychnDeviceToken andDevieId:DEVICE_UDID];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel.people addPushDeviceToken:deviceToken];
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
   // Let the app know how to present notification
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Remote/Local Notification received
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if(DEBUGGING) NSLog(@"Remote notification received %@",userInfo);
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}


#pragma mark- System Datbase Management

- (void)copyDatabase {
    //copy database to the system folder
    KCFileManager *fileManager = [[KCFileManager alloc] init];
    [fileManager copyDatabase];
}

- (void)updatePushNotificationTokenWithToken:(NSString *)token andDevieId:(NSString *)deviceId {
    // Update Push Notification token to the server every time the token is refreshed
    NSDictionary *parameters = @{kDeviceToken:token, kDeviceID: deviceId, kDeviceType:IOS_DEVICE};
    [_webConnection sendDataToServerWithAction:updatePushNotification withParameters:parameters success:^(NSDictionary *response) {
        
    } failure:^(NSString *response) {
        
    }];
}

@end

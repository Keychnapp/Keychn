//
//  KCTwitterManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 30/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCTwitterManager.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>

@import TwitterKit;

@interface KCTwitterManager ()

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) NSArray *accounts;

@end

@implementation KCTwitterManager

#pragma mark - Twitter Profile Keys

NSString const *TWUsername      = @"screen_name";
NSString const *TWUserFullName  = @"name";
NSString const *TWUserEmailID   = @"email_address";
NSString const *TWIdentifier    = @"id";
NSString const *TWUserImageURL  = @"profile_image_url";


- (void)loginTwiiterAccountWithCompletionHandler:(void(^)(BOOL status))finished {
    if (_accounts == nil) {
        if (_accountStore == nil) {
            self.accountStore = [[ACAccountStore alloc] init];
        }
        ACAccountType *accountTypeTwitter =
        [self.accountStore
         accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [self.accountStore requestAccessToAccountsWithType:accountTypeTwitter options:nil completion:^(BOOL granted, NSError *error) {
            if(granted) {
                self.accounts = [self.accountStore
                                 accountsWithAccountType:accountTypeTwitter];
                ACAccount *account = [self.accounts lastObject];
                NSLog(@"Username %@",account.userFullName);
                NSLog(@"Identifier %@",account.identifier);
                
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
                if(account.username) {
                    NSDictionary *params = @{@"screen_name" : account.username
                                             };
                    SLRequest *request =
                    [SLRequest requestForServiceType:SLServiceTypeTwitter
                                       requestMethod:SLRequestMethodGET
                                                 URL:url
                                          parameters:params];
                    //  Attach an account to the request
                    [request setAccount:account];
                    
                    [request performRequestWithHandler:^(NSData *responseData,
                                                         NSHTTPURLResponse *urlResponse,
                                                         NSError *error) {
                        if (responseData) {
                            
                            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                                [self performSelectorOnMainThread:@selector(twitterdetails:)
                                                       withObject:responseData waitUntilDone:YES];
                                finished(YES);
                            }
                        }
                    }];
                }
                else {
                    //no account setup for twiiter
                }
                
            }
            else {
                //show alert for permission disallowed for access
                dispatch_async(dispatch_get_main_queue(), ^{
                    finished(NO);
                });
            }
        }];
    }
}

-(void)twitterdetails:(NSData *)responseData {
    
    NSError* error = nil;
    NSDictionary* responseDictionary = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          options:NSJSONReadingAllowFragments
                          error:&error];
    KCUserProfile *userProfile = [KCUserProfile sharedInstance];
    userProfile.twitterProfile.username         = [responseDictionary objectForKey:TWUsername];
    userProfile.twitterProfile.fullName         = [responseDictionary objectForKey:TWUserFullName];
    userProfile.twitterProfile.twitterID        = [responseDictionary objectForKey:TWIdentifier];
    userProfile.twitterProfile.imageURL         = [responseDictionary objectForKey:TWUserImageURL];
    //edit image URL to get the original profile image
    userProfile.twitterProfile.imageURL         = [userProfile.twitterProfile.imageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    if(DEBUGGING) NSLog(@"Twiiter User Profile %@", responseDictionary);
    //email ID is not provided by twiitter, hence created symobilically to store in server's database
    userProfile.twitterProfile.twitterEmailID   = [userProfile.twitterProfile.username stringByAppendingString:@"@twitter.com"];
}

- (void) openTweetSheetWithTitle:(NSString*)title andImage:(UIImage*)image inViewController:(UIViewController*)view {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Initial Tweet Text!"];
        [tweetSheet addImage:[UIImage imageNamed:@"france_flag.png"]];
        [view presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (void)composeTweetWithText:(NSString *)text andImage:(UIImage *)image inViewController:(UIViewController *)controller withCompletionHandler:(void(^)(BOOL isTweeted))finished{
    // Show tweet compose dialog box
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    [composer setImage:image];
    [composer setText:text];
    
    // Called from a UIViewController
    [composer showFromViewController:controller completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
           if(DEBUGGING) NSLog(@"Tweet composition cancelled");
            finished(NO);
        }
        else {
            if(DEBUGGING)NSLog(@"Sending Tweet!");
            finished(YES);
        }
    }];
}


@end

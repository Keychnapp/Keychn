//
//  KCDeepLinkManager.m
//  Keychn
//
//  Created by Rohit Kumar on 10/06/2018.
//  Copyright © 2018 Keychn Experience. All rights reserved.
//

#import "KCDeepLinkManager.h"
#import "KCMasterClassViewController.h"
#import "KCItemDetailsViewController.h"
#import "KCMasterchefViewController.h"
#import "MasterclassDetailViewController.h"
#import "MasterclassVideo.h"
#import "KCItem.h"
#import "AppDelegate.h"
#import "RecordedMasterclassViewController.h"
#import "BranchUniversalObject.h"
#import "BranchLinkProperties.h"

#define kControllerMapping @{@"LiveClass":@"masterClassViewController", @"Recipe":@"itemDetailsViewController", @"Masterchef":@"KCMasterchefViewController", @"RecordedClass":@"MasterclassDetailViewController"}

@implementation KCDeepLinkManager

#pragma mark - Link Sharing

+ (void)shareLinkWithTitle:(NSString *)title content:(NSString *)text canonicalURL:(NSString *)url imageURL:(NSString *)imageURL controller:(NSString *)controller identfier:(NSNumber *)identifier presentOn:(UIViewController *)viewController {
    // Create a link and share
    NSString *urlIdentifier = [NSString stringWithFormat:@"%@/identifier/%@/%@", controller, identifier, [KCUserProfile sharedInstance].userID];
    BranchUniversalObject *branchUniversalObject = [[BranchUniversalObject alloc] initWithCanonicalIdentifier:urlIdentifier];
    branchUniversalObject.title              = title;
    branchUniversalObject.contentDescription = text;
    branchUniversalObject.imageUrl           = imageURL;
    branchUniversalObject.canonicalUrl       = url;
    [branchUniversalObject.contentMetadata.customMetadata setObject:controller forKey:@"controller"];
    [branchUniversalObject.contentMetadata.customMetadata setObject:[NSString stringWithFormat:@"%@",identifier] forKey:@"identifier"];
    BranchLinkProperties *linkProperties = [[BranchLinkProperties alloc] init];
    linkProperties.feature = @"share";
    linkProperties.channel = @"facebook";
    
    
    [branchUniversalObject showShareSheetWithLinkProperties:linkProperties
                                               andShareText:text
                                         fromViewController:viewController
                                                 completion:^(NSString *activityType, BOOL completed) {
                                                     NSLog(@"finished presenting");
                                                 }];
}

#pragma mark - Navigation

+ (void)navigateLinkWithParameter:(NSDictionary *)parameters {
    // Navigate screen to link
    NSString *controller = [parameters objectForKey:@"controller"];
    NSNumber *identifier = [parameters objectForKey:@"identifier"];
    NSString *storyboardController = [kControllerMapping objectForKey:controller];
    if(DEBUGGING) NSLog(@"navigateLinkWithParameter --> %@", parameters);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: kDeeplinkParameter];
    
    if(storyboardController && identifier.integerValue > 0) {
        // View Controller exists
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *rootViewController = (UINavigationController *) (((AppDelegate *) [UIApplication sharedApplication].delegate).window.rootViewController);
        
        /**** LINK 1 - LIVE MASTERCLASS DETAIL ****/
        if([storyboardController isEqualToString:@"masterClassViewController"]) {
            KCMasterClassViewController *masterclassViewController = [mainstoryboard instantiateViewControllerWithIdentifier:storyboardController];
            masterclassViewController.masterClassID = identifier;
            [rootViewController presentViewController:masterclassViewController animated:true completion:^{
                
            }];
        }
        
        /**** LINK 2 - ITEM DETAILS ****/
        else if([storyboardController isEqualToString:@"itemDetailsViewController"]) {
            KCItemDetailsViewController *itemDetailsViewController = [mainstoryboard instantiateViewControllerWithIdentifier:storyboardController];
            KCItem *item            = [[KCItem alloc] init];
            item.itemIdentifier     = identifier;
            itemDetailsViewController.selectedItem = item;
            [rootViewController pushViewController:itemDetailsViewController animated:true];
        }
        
        /**** LINK 3 - MASTERCHEF DETAILS ****/
        else if([storyboardController isEqualToString:@"KCMasterchefViewController"]) {
            KCMasterchefViewController *masterchefViewController = [mainstoryboard instantiateViewControllerWithIdentifier:storyboardController];
            MasterclassVideo *video = [[MasterclassVideo alloc] init];
            video.chefId            = identifier;
            masterchefViewController.selectedMasterclass = video;
            [rootViewController pushViewController:masterchefViewController animated:true];
        }
        
        /**** LINK 4 - RECORDED MASTERCLASS DETAILS ****/
        else if([storyboardController isEqualToString:@"MasterclassDetailViewController"]) {
            MasterclassDetailViewController *masterclassDetailsViewController = [mainstoryboard instantiateViewControllerWithIdentifier:storyboardController];
            MasterclassVideo *video = [[MasterclassVideo alloc] init];
            video.videoId           = identifier;
            masterclassDetailsViewController.selectedVideo = video;
            [rootViewController pushViewController:masterclassDetailsViewController animated:true];
        }
    }
}

@end

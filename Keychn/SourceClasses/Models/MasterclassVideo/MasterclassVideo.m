//
//  MasterclassVideo.m
//  Keychn
//
//  Created by Rohit Kumar on 20/05/2018.
//  Copyright © 2018 Keychn Experience. All rights reserved.
//

#import "MasterclassVideo.h"


@implementation MasterclassVideo

- (instancetype)initWithResponse:(NSDictionary *)response {
    self = [super init];
    IOSDevices deviceType = [KCUtility getiOSDeviceType];
    self.videoId                = [response objectForKey:@"id"];
    if (deviceType == iPad) {
        self.placeholderImageURL    = [response objectForKey:@"image_url_ipad"];
    }
    else {
        self.placeholderImageURL    = [response objectForKey:@"image_url_iphone"];
    }
    
    self.chefName               = [response objectForKey:@"masterchef_name"];
    self.aboutChef              = [response objectForKey:@"about_user"];
    self.chefImageURL           = [response objectForKey:@"masterchef_profile_image"];
    self.videoName              = [response objectForKey:@"label_name"];
    self.chefId                 = [response objectForKey:@"masterchef_id"];
    
    return self;
}

@end

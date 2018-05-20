//
//  MasterclassVideo.h
//  Keychn
//
//  Created by Rohit Kumar on 20/05/2018.
//  Copyright © 2018 Keychn Experience. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterclassVideo : NSObject

- (instancetype)initWithResponse:(NSDictionary *)response;

@property (strong, nonatomic) NSNumber *videoId;
@property (strong, nonatomic) NSNumber *chefId;
@property (strong, nonatomic) NSString *placeholderImageURL;
@property (strong, nonatomic) NSString *chefName;
@property (strong, nonatomic) NSString *aboutChef;
@property (strong, nonatomic) NSString *chefImageURL;
@property (strong, nonatomic) NSString *videoName;

@end

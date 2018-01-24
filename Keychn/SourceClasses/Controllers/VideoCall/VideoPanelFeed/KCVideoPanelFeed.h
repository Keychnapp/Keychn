//
//  KCVideoPanelFeed.h
//  Keychn
//
//  Created by Keychn Experience SL on 26/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>


@interface KCVideoPanelFeed : UIView

@property (weak, nonatomic) IBOutlet UIView *usernameContainerView;
@property (weak, nonatomic) IBOutlet UIView  *videoFeedPanel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic)  UIView  *videoRender;
@property (strong, nonatomic) AgoraRtcVideoCanvas *videoCanvas;

@end

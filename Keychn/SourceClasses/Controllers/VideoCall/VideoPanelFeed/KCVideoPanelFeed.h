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

@property (weak, nonatomic)    IBOutlet UIView  *videoFeedPanel;
@property (strong, nonatomic)  UIView  *videoRender;
@property (weak, nonatomic) IBOutlet UILabel *shortnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *queuePositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) AgoraRtcVideoCanvas *videoCanvas;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end

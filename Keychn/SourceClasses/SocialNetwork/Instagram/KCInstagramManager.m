//
//  KCInstagramManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 24/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCInstagramManager.h"


@interface KCInstagramManager () <UIDocumentInteractionControllerDelegate>

@property (nonatomic,strong) UIDocumentInteractionController *instagramContoller;
@property (nonatomic,strong) UIViewController *presentationViewController;

@end

@implementation KCInstagramManager

- (void)shareImageOnInstagramWithErrorHandler:(UIImage*)image withPresentationViewController:(UIViewController*)controller withErrorHandler:(void (^)(void))failed {
    //Share image on Instagram
    self.presentationViewController = controller;
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        if(DEBUGGING) NSLog(@"Opening Instagram app");
        //Create Instagram image directory
        NSFileManager *fileManager   = [NSFileManager defaultManager];
        NSString      *directoryPath = [NSHomeDirectory() stringByAppendingString:@"Library/Instagram"];
        NSString      *imagePath     = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/instagram_share.igo"];
        //Create directory
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:Nil error:nil];
        //Write image
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
        
        NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", imagePath]];
        self.instagramContoller.UTI = @"com.instagram.photo";
        self.instagramContoller = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
        self.instagramContoller=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
        [self.instagramContoller presentOptionsMenuFromRect:controller.view.frame inView:controller.view animated:YES];
    }
    else {
        if(DEBUGGING) NSLog(@"Instagram not installed");
        failed();
    }
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}


@end

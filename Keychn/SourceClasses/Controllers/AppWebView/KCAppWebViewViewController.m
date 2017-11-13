//
//  KCAppWebViewViewController.m
//  Keychn
//
//  Created by Keychn Experience SL on 05/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCAppWebViewViewController.h"

@interface KCAppWebViewViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *appWebView;

@end

@implementation KCAppWebViewViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.isPlayingVideo)  {
        NSArray *urlSplitArray = [self.urlToOpen componentsSeparatedByString:@"?"];
        NSString *videoId;
        if([urlSplitArray count] > 1) {
            videoId = [urlSplitArray lastObject];
        }
        if(videoId) {
            [self playVideoWithId:videoId];
        }
        
    }
    else {
        NSURL *url = [NSURL URLWithString:self.urlToOpen];
        //open the url in app web view
        [self.appWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    HideNetworkActivityIndicator();
}

#pragma mark - WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    ShowNetworkActivityIndicator();
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    HideNetworkActivityIndicator();
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    HideNetworkActivityIndicator();
}


#pragma mark - Button Action

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)playVideoWithId:(NSString *)videoId {
    
    NSString *youTubeVideoHTML = @"<html><body style='margin:0px;padding:0px;'><script type='text/javascript' src='http://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){a.target.playVideo();}</script><iframe id='playerId' type='text/html' width='\(self.view.frame.size.width)' height='\(self.view.frame.size.height)' src='http://www.youtube.com/embed/\(videoID)?enablejsapi=1&rel=0&playsinline=1&autoplay=1' frameborder='0'></body></html>";
    
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, videoId];
    
    self.appWebView.mediaPlaybackRequiresUserAction = NO;
    
    [self.appWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] resourceURL]];
}



@end
